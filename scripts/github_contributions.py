#!/usr/bin/env python3

import datetime
import re
import subprocess
import sys
import urllib.request

GITHUB_USER = "albertyw"
GITHUB_CALENDAR_URL = f"https://github.com/users/{GITHUB_USER}/contributions"

# <td data-date="2026-08-16" id="contribution-day-component-0-33" ...>
CALENDAR_DAY_RE = re.compile(
    r'data-date="(\d{4}-\d{2}-\d{2})" id="(contribution-day-component-[\d-]+)"',
)
# <tool-tip ... for="contribution-day-component-0-33" ...>22 contributions on ...
CALENDAR_COUNT_RE = re.compile(
    r'for="(contribution-day-component-[\d-]+)"[^>]*>(No|[\d,]+) contributions? on',
)


def get_remote_contributions() -> dict[datetime.date, int]:
    """
    Returns a dict of contributions already known to Github, scraped from the
    public contribution calendar.

    The GraphQL API is deliberately not used: organizations can forbid access
    via personal access tokens, and Github then silently omits contributions to
    those organizations from contributionsCollection rather than erroring.  The
    public calendar is what github.com/<user> itself renders, so it always
    agrees with the profile page.
    """
    request = urllib.request.Request(GITHUB_CALENDAR_URL)
    with urllib.request.urlopen(request) as response:
        html = response.read().decode('utf-8')
    days = {
        element_id: datetime.date.fromisoformat(date)
        for date, element_id in CALENDAR_DAY_RE.findall(html)
    }
    contributions: dict[datetime.date, int] = {}
    for element_id, count in CALENDAR_COUNT_RE.findall(html):
        if element_id not in days:
            continue
        contributions[days[element_id]] = 0 if count == "No" else int(count.replace(",", ""))
    if not contributions:
        raise RuntimeError(f"Could not parse contributions from {GITHUB_CALENDAR_URL}")
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
    remote_contributions = get_remote_contributions()
    local_contributions = get_local_contributions()
    for local_date, local_count in local_contributions.items():
        count = remote_contributions.get(local_date, 0) + local_count
        if count > 15:
            print(f"Estimated Github contributions {local_date}: {count}\n")
        if count > 20:
            return False
    return True


if __name__ == "__main__":
    allow = main()
    if not allow:
        sys.exit(1)
