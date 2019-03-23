#!/bin/bash
# Test dotfiles

set -e

bashfiles=$(git grep -El '#!.*bash')
bashfiles="$bashfiles$IFS$(git ls-files | grep bash)"
bashfiles="$bashfiles$IFS$(git ls-files | grep -F .sh)"
bashfiles="$(echo "$bashfiles" | tr "$IFS" "\n" | sort -u | tr " " "$IFS" | sed '/./,$!d')"

while read -r bashfile; do
    shellcheck -e SC1090,SC1091 "$bashfile"
done <<< "$bashfiles"

pythonfiles=$(git grep -El '#!.*python' | grep -v "test.sh")

while read -r pythonfile; do
    flake8 "$pythonfile"
done <<< "$pythonfiles"
