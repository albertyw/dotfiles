#!/bin/bash
# This script synchronizes the local dotfiles repository

set -euo pipefail
IFS=$'\n\t'
lockdir="${HOME}/.dotfiles/sync"

check_internet () {
    ping github.com -c 1 > /dev/null 2>&1
}

update_dotfiles () {
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
        ~/.ssh/chmod.sh
        echo 'Dotfiles updated'
    fi
}

# Prevent other sync-dotfiles.sh runs from running
if ! mkdir "$lockdir" 2> /dev/null; then
    exit
fi
removelock () {
    rmdir "$lockdir"
}
trap removelock EXIT

# Check if there are updates to this dotfiles repo
cd ~/.dotfiles

check_internet
~/.dotfiles/scripts/timesync.sh &>/dev/null
update_dotfiles

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    update_dotfiles
fi
