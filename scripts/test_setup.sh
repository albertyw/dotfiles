#!/bin/bash
# Test dotfiles

set -euo pipefail
IFS=$'\n\t'

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$BASEDIR/.." || exit 1

echo "--- Set up basic utilities"
apt-get update
apt-get install -y --no-install-recommends \
    curl ca-certificates tar xz-utils \
    python3.9 python3-setuptools \
    git

echo "--- Set up shellcheck"
curl -L https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz > "scripts/shellcheck.tar.xz"
tar xvf scripts/shellcheck.tar.xz -C scripts --strip-components=1 shellcheck-v0.7.1/shellcheck
rm scripts/shellcheck.tar.xz

echo "--- Set up flake8"
curl https://bootstrap.pypa.io/get-pip.py | python3.9
pip3 install flake8
