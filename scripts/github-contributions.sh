#!/bin/bash

# Checks the number of github contributions made in the last 24 hours

set -euo pipefail
IFS=$'\n\t'

source ~/.ssh/other/github.sh

events_data=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    -u "$USER:$TOKEN" \
    https://api.github.com/users/albertyw/events)
yesterday="$(date -v -1d -u +"%Y-%m-%dT%H:%M:%SZ")"
events_data=$(
    echo "$events_data" \
    | jq ".[] | select(.created_at >= \"$yesterday\")" \
    | jq -s '.'
)

commit_count=$(
    echo "$events_data" \
    | jq ".[]
    | select(.type == \"PushEvent\")
    | select(.payload.ref == \"refs/heads/master\" or .payload.ref == \"refs/heads/main\")
    | .payload.commits
    | length" \
    | awk '{s+=$1} END {print s}'
)
issues_count=$(
    echo "$events_data" \
    | jq '.[]
    | select(.type == "IssuesEvent")
    | select(.payload.action == "opened")' \
    | jq -s '. | length'
)
pull_request_count=$(
    echo "$events_data" \
    | jq '.[]
    | select(.type == "PullRequestEvent")
    | select(.payload.action == "opened")' \
    | jq -s '. | length'
)

contributions=$((commit_count + issues_count))
if [[ contributions -ge 15 ]]; then
    echo "Estimated Github contributions in last 24 hours:"
    echo "Commits: $commit_count"
    echo "Issues: $issues_count"
    echo "Pull requests: $pull_request_count"
fi
