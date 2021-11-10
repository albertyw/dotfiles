#!/bin/bash
# Test dotfiles

set -euo pipefail
IFS=$'\n\t'

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$BASEDIR/.." || exit 1


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
        additionalignores=",SC2148,SC2048"
    fi
    shellcheck -e "$shellcheckignores$additionalignores" "$bashfile"
done <<< "$bashfiles"
