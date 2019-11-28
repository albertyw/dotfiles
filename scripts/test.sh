#!/bin/bash
# Test dotfiles

set -e

bashfiles=$(git grep -El '#!.*bash')
bashfiles="$bashfiles$IFS$(git ls-files | grep bash)"
bashfiles="$bashfiles$IFS$(git ls-files | grep -F .sh)"
bashfiles="$(echo "$bashfiles" | tr "$IFS" "\n" | sort -u | tr " " "$IFS" | sed '/./,$!d')"
shellcheckignores="SC1090,SC1091"

while read -r bashfile; do
    echo "$bashfile"
    # bash completion files are meant to be sourced instead of run so they 
    # should not have a shebang
    additionalignores=""
    if [[ "$bashfile" == *"completion"* ]]; then
        additionalignores=",SC2148"
    fi
    shellcheck -e "$shellcheckignores$additionalignores" "$bashfile"
done <<< "$bashfiles"

pythonfiles=$(git grep -El '#!.*python' | grep -v "test.sh")

while read -r pythonfile; do
    echo "$pythonfile"
    flake8 "$pythonfile"
done <<< "$pythonfiles"
