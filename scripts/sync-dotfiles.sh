#!/bin/bash
# This script synchronizes the local dotfiles repository

set -euo pipefail
IFS=$'\n\t'

check_internet () {
    ping github.com -c 1 > /dev/null 2>&1
}

check () {
    git fetch --prune

    changes="$(git diff)"
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED CHANGES';
        exit
    fi

    changes="$(git ls-files --others --exclude-standard)"
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED FILES';
        exit
    fi

    changes="$(git diff HEAD..FETCH_HEAD)"
    if [ "$changes" != "" ] ; then
        git pull --quiet > /dev/null 2>&1
        git submodule --quiet init
        git submodule --quiet update --recursive
        ~/.dotfiles/scripts/chmod-private-keys.sh
        echo 'Dotfiles updated'
    fi
}

# Check if there are updates to this dotfiles repo
cd ~/.dotfiles

check_internet
check

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    check
fi
