#!/bin/bash
# Test dotfiles

set -e

bashshebang=$(git grep -El '#!.*bash')
bashfiles=$(git ls-files | grep bash)
bashfiles="$bashshebang$IFS$bashfiles"

while read -r bashfile; do
    shellcheck -e SC1090,SC1091 "$bashfile"
done <<< "$bashfiles"

pythonfiles=$(git grep -El '#!.*python' | grep -v "test.sh")

while read -r pythonfile; do
    flake8 "$pythonfile"
done <<< "$pythonfiles"
