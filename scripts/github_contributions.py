#!/usr/bin/env python3

import datetime
import json
import pathlib
import subprocess
import urllib.request


GITHUB_API_URL = "https://api.github.com/graphql"
GITHUB_TOKEN_FILE = pathlib.Path.home() / ".ssh" / "other" / "github.sh"


def get_github_api_headers() -> dict[str, str]:
    with open(GITHUB_TOKEN_FILE, "r") as f:
        data = f.readlines()
    for line in data:
        if 'export TOKEN=' in line:
            token = line.split("'")[1].strip()
            break
    github_api_headers = {
        "Authorization": "bearer %s" % token,
    }
    return github_api_headers


def get_remote_contributions() -> dict[datetime.date, int]:
    request_data = {
        "query": """
        query {
            viewer {
                contributionsCollection {
                    contributionCalendar {
                        weeks {
                            contributionDays {
                                date
                                contributionCount
                            }
                        }
                    }
                }
            }
        }
        """,
    }
    data_serialized = json.dumps(request_data).encode('utf-8')
    request = urllib.request.Request(
        GITHUB_API_URL,
        headers=get_github_api_headers(),
        data=data_serialized,
        method="POST",
    )
    with urllib.request.urlopen(request) as response:
        response_data_serialized = response.read().decode('utf-8')
    response_data = json.loads(response_data_serialized)["data"]["viewer"]
    weeks = response_data["contributionsCollection"]["contributionCalendar"]["weeks"]
    contributions: dict[datetime.date, int] = {}
    for week in weeks:
        for day in week["contributionDays"]:
            date = datetime.datetime.strptime(day["date"], "%Y-%m-%d").date()
            contributions[date] = day["contributionCount"]
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
        "git", "log", "--oneline",
        "--date=iso", "--pretty=%ad",
        "origin/%s..%s" % (current_branch, current_branch),
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
    get_local_contributions()
    today = datetime.date.today()
    remote_contributions_today = remote_contributions.get(today, 0)
    if remote_contributions_today > 15:
        print("Estimated Github contributions %s: %s" %
            (today, remote_contributions_today))
    return True


if __name__ == "__main__":
    main()
