#!/bin/bash

# Checks the number of github contributions made in the last 24 hours

set -euo pipefail
IFS=$'\n\t'

source ~/.ssh/other/github.sh

events_data=$(curl -s \
    -X POST \
    -H "Authorization: bearer $TOKEN" \
    -d '{"query": "query {viewer {contributionsCollection {contributionCalendar {weeks {contributionDays {contributionCount date}}}}}}"}' \
    https://api.github.com/graphql)

last_event=$(echo "$events_data" | jq '.data.viewer.contributionsCollection.contributionCalendar.weeks[-1].contributionDays[-1]')
contributions=$(echo "$last_event" | jq -r '.contributionCount')
last_date=$(echo "$last_event" | jq -r '.date')

if [[ contributions -ge 15 ]]; then
    echo "Estimated Github contributions today $last_date: $contributions"
fi
