#!/bin/bash
# Test dotfiles

bashfiles=$(git grep -El '#!.*bash')

while read -r bashfile; do
    shellcheck "$bashfile"
done <<< "$bashfiles"

pythonfiles=$(git grep -El '#!.*python' | grep -v "test.sh")

while read -r pythonfile; do
    flake8 "$pythonfile"
done <<< "$pythonfiles"
