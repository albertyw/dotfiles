#!/usr/bin/env python3

"""
Estimates whether a day's Github contributions will exceed 20 once the local
commits are pushed, by scraping the public contribution calendar.

The calendar is not real-time and can lag by ~2 hours.  Using an auth token,
the GraphQL API, setting timezones, or setting no-cache headers does not bust
cache to fix the lag.  Using personal access tokens with graphql leads to
undercounting because they will not count contributions to github
organizations that forbid access via personal access tokens.
"""

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


def get_remote_contributions(years: set[int]) -> dict[datetime.date, int]:
    """
    Returns a dict of contributions already known to Github, scraped from the
    public contribution calendar for each of the given calendar years.

    The GraphQL API is deliberately not used: organizations can forbid access
    via personal access tokens, and Github then silently omits contributions to
    those organizations from contributionsCollection rather than erroring.  It
    would however report contributions the public calendar has not caught up
    to yet, which is the tradeoff described in the module docstring.
    """
    contributions: dict[datetime.date, int] = {}
    for year in sorted(years):
        contributions.update(get_remote_year_contributions(year))
    return contributions


def get_remote_year_contributions(year: int) -> dict[datetime.date, int]:
    """
    Returns a dict of contributions known to Github for a single calendar year

    Github answers an unparseable `from` with the stale rolling-year calendar
    instead of an error, so the returned grid is checked to be the requested
    year: a silent fallback would undercount today and wave a push through.
    """
    url = f"{GITHUB_CALENDAR_URL}?from={year}-01-01"
    request = urllib.request.Request(url)
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
    if not contributions:
        raise RuntimeError(f"Could not parse contributions from {url}")
    if max(contributions) != datetime.date(year, 12, 31):
        raise RuntimeError(f"{url} did not return the {year} calendar")
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
    years = {date.year for date in local_contributions}
    remote_contributions = get_remote_contributions(years)
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
