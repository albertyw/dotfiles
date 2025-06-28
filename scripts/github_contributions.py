#!/usr/bin/env python3

import datetime
import json
import pathlib
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


def get_contributions() -> dict[datetime.date, int]:
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


def main() -> bool:
    """
    Returns whether already pushed plus planned-to-pushed contributions will
    be more than 20 per day
    """
    contributions = get_contributions()
    print(contributions)
    return True


if __name__ == "__main__":
    main()
