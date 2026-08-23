#!/usr/bin/env python3

"""
Estimates whether a day's Github contributions will exceed 20 once the local
commits are pushed, by scraping the public contribution calendar.

The calendar is not real-time and can lag by ~2 hours.  Setting timezones or
no-cache headers does not bust cache to fix the lag, and neither does any URL
parameter or nonce; only an authenticated API call sees contributions sooner.
Using personal access tokens with graphql leads to undercounting because they
will not count contributions to github organizations that forbid access via
personal access tokens.

Read the calendar the way the profile page does, from the <include-fragment>
it lazy-loads.  Github serves several grids of the same data that lag each
other by hours in no fixed order: a `from` parameter selects a calendar-year
grid that was once fresher than the default rolling grid by 6 contributions,
and later staler than it by 4.  The profile fragment is the one whose number
matches what the profile itself shows.
"""

import datetime
import re
import subprocess
import sys
import urllib.request

GITHUB_USER = "albertyw"
GITHUB_CALENDAR_URL = f"https://github.com/{GITHUB_USER}?tab=contributions"

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
    rolling-year calendar that github.com/<user> renders on its profile page.

    The GraphQL API is deliberately not used: organizations can forbid access
    via personal access tokens, and Github then silently omits contributions to
    those organizations from contributionsCollection rather than erroring.

    The profile page loads its calendar lazily through an <include-fragment>,
    so the request has to look like that fragment's own.  Without the header
    Github answers 200 with the profile shell and no calendar in it, which
    would parse as an empty grid rather than fail.
    """
    request = urllib.request.Request(GITHUB_CALENDAR_URL)
    request.add_header("X-Requested-With", "XMLHttpRequest")
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
        count_value = 0
        if count != "No":
            count_value = int(count.replace(",", ""))
        contributions[days[element_id]] = count_value
    if datetime.date.today() not in contributions:
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
    local_contributions = get_local_contributions()
    if not local_contributions:
        local_contributions = {datetime.date.today(): 0}
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
