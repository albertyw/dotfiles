#!/usr/bin/env python3

"""
Estimates whether a day's Github contributions will exceed 20 once the local
commits are pushed.

Contributions come from the graphql API, with a classic read:user token taken
from the environment or from ~/.ssh/other/github.sh.

Alternatives that do not work:

- A fine-grained token silently omits contributions to organizations that have
  not opted into fine-grained tokens, reporting 18 against a true 20.
- The REST API has no contributions endpoint, and its events feed is capped
  and carries no commit counts.
- Scraping any calendar off github.com trails the API by a couple of hours and
  buckets days in UTC rather than in the account's timezone.  No URL
  parameter, request header, or cache-busting nonce makes those pages any less
  stale, and the several grids Github serves of the same data disagree with
  each other by hours in no fixed order.
"""

import datetime
import json
import os
import pathlib
import shlex
import subprocess
import sys
import urllib.request

GITHUB_GRAPHQL_URL = "https://api.github.com/graphql"
TOKEN_VARIABLE = "TOKEN_CLASSIC"
TOKEN_FILE = pathlib.Path.home() / ".ssh" / "other" / "github.sh"
CONTRIBUTIONS_QUERY = """query {
  viewer {
    contributionsCollection {
      contributionCalendar {
        weeks { contributionDays { date contributionCount } }
      }
    }
  }
}"""


def get_today() -> datetime.date:
    """
    Returns today's date in the local timezone, which is what git reports
    commit dates in

    Github buckets calendar days in the account's own timezone rather than in
    UTC, and ignores any offset given to contributionsCollection, so these
    agree as long as this machine's timezone matches the account's.
    """
    return datetime.datetime.now().astimezone().date()


def get_token() -> str:
    """
    Returns the Github token from the environment or from the shell file that
    exports it, so that this script can be run directly without sourcing

    The file is shell rather than config, so it is read for an assignment to
    TOKEN_VARIABLE rather than executed.
    """
    token = os.environ.get(TOKEN_VARIABLE)
    if token:
        return token
    try:
        contents = TOKEN_FILE.read_text()
    except OSError as error:
        raise RuntimeError(f"Could not read {TOKEN_FILE}") from error
    for line in contents.splitlines():
        try:
            words = shlex.split(line, comments=True)
        except ValueError:
            continue
        if words and words[0] == "export":
            words = words[1:]
        if not words:
            continue
        name, separator, value = words[0].partition("=")
        if separator and name == TOKEN_VARIABLE and value:
            return value
    raise RuntimeError(f"{TOKEN_FILE} does not export {TOKEN_VARIABLE}")


def get_remote_contributions() -> dict[datetime.date, int]:
    """
    Returns a dict of contributions for the last year from the graphql API

    Counts here include private and organization contributions.
    """
    token = get_token()
    request = urllib.request.Request(
        GITHUB_GRAPHQL_URL,
        data=json.dumps({"query": CONTRIBUTIONS_QUERY}).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
    )
    with urllib.request.urlopen(request) as response:
        payload = json.loads(response.read().decode("utf-8"))
    if "errors" in payload:
        raise RuntimeError(f"Github graphql API returned {payload['errors']}")
    try:
        collection = payload["data"]["viewer"]["contributionsCollection"]
        weeks = collection["contributionCalendar"]["weeks"]
    except (KeyError, TypeError) as error:
        raise RuntimeError(f"Unexpected response from {GITHUB_GRAPHQL_URL}") from error
    contributions = {
        datetime.date.fromisoformat(day["date"]): day["contributionCount"]
        for week in weeks
        for day in week["contributionDays"]
    }
    # An empty or truncated calendar would otherwise read as zero contributions
    # for every day and wave a push through
    if get_today() not in contributions:
        raise RuntimeError(f"{GITHUB_GRAPHQL_URL} returned no contributions for today")
    return contributions


def get_local_contributions() -> dict[datetime.date, int]:
    """
    Returns a dict of local commits to be pushed to Github
    """
    git_branch_command = ["git", "branch", "--show-current"]
    current_branch = subprocess.run(
        git_branch_command,
        capture_output=True,
        text=True,
        check=True,
    ).stdout.strip()
    contributions: dict[datetime.date, int] = {}
    if current_branch not in ["master", "main"]:
        return contributions
    git_history_command = [
        "git", "log",
        "--date=iso", "--pretty=%ad",
        f"origin/{current_branch}..{current_branch}",
    ]
    git_history_output = subprocess.run(
        git_history_command,
        capture_output=True,
        text=True,
        check=True,
    ).stdout.strip()
    for line in git_history_output.split("\n"):
        if not line.strip():
            continue
        date = datetime.datetime.fromisoformat(line).date()
        contributions[date] = contributions.get(date, 0) + 1
    return contributions


def main() -> bool:
    """
    Returns whether already pushed plus planned-to-pushed contributions will
    be more than 20 per day
    """
    local_contributions = get_local_contributions()
    if not local_contributions:
        local_contributions = {get_today(): 0}
    remote_contributions = get_remote_contributions()
    for local_date, local_count in local_contributions.items():
        count = remote_contributions.get(local_date, 0) + local_count
        print(f"Estimated Github contributions {local_date}: {count}\n")
        if count > 20:
            return False
    return True


if __name__ == "__main__":
    allow = main()
    if not allow:
        sys.exit(1)
