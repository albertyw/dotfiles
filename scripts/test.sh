#!/bin/bash
# Test dotfiles

set -euo pipefail
IFS=$'\n\t'

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$BASEDIR/.." || exit 1

echo "--- Set up shellcheck"
if [ ! -f scripts/shellcheck ]; then
    if ! command -v curl &> /dev/null; then
        if [ ! -f /var/lib/apt/periodic/update-success-stamp ]; then
            apt-get update
        fi
        apt-get install -y curl tar xz-utils
    fi
    curl -L https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz > "scripts/shellcheck.tar.xz"
    tar xvf scripts/shellcheck.tar.xz -C scripts --strip-components=1 shellcheck-v0.7.1/shellcheck
    rm scripts/shellcheck.tar.xz
fi

echo "--- Set up flake8"
if ! command -v flake8 &> /dev/null; then
    if [ ! -f /var/lib/apt/periodic/update-success-stamp ]; then
        apt-get update
    fi
    apt-get install -y --no-install-recommends python3.9 python3-setuptools
    curl https://bootstrap.pypa.io/get-pip.py | python3.9
    pip3 install flake8
fi

echo "--- Set up git"
if ! command -v git &> /dev/null; then
    if [ ! -f /var/lib/apt/periodic/update-success-stamp ]; then
        apt-get update
    fi
    apt-get install -y --no-install-recommends git
fi

echo "--- Run shellcheck"
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
    scripts/shellcheck -e "$shellcheckignores$additionalignores" "$bashfile"
done <<< "$bashfiles"

echo "--- Run flake8"
pythonfiles=$(git grep -El '#!.*python' | grep -v "test.sh")

while read -r pythonfile; do
    echo "$pythonfile"
    flake8 "$pythonfile"
done <<< "$pythonfiles"
