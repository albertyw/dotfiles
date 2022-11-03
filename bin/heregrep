#!/bin/bash

# This script runs git grep through all git repositories directly underneath my
# home directory

set -euo pipefail
IFS=$'\n\t'

if [[ -z "${1+x}" ]] || [[ "$1" == "-h" ]]; then
    echo "Runs a grep operation under each git repository underneath the current pwd"
    exit
fi

for f in ./*; do
    if [ ! -d "$f/.git" ]; then
        continue
    fi
    echo "$f"
    tput rmam
    git -C "$f" --no-pager grep "$@" || true
    tput smam
done
