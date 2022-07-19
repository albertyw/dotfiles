#!/bin/bash

# This script runs git grep through all git repositories directly underneath my
# home directory

set -euo pipefail
IFS=$'\n\t'

for f in ./*; do
    if [ ! -d "$f/.git" ]; then
        continue
    fi
    echo "$f"
    git -C "$f" grep "$@" || true
done
