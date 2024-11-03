#!/bin/bash
# This script synchronizes the local dotfiles repository

set -euo pipefail
IFS=$'\n\t'
lastupdated_file="${HOME}/.dotfiles/lastupdated"

check_internet () {
    ping github.com -c 1 > /dev/null 2>&1
}

update_dotfiles () {
    git fetch --prune

    branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch_name="(unnamed branch)"     # detached HEAD
    if [ "$branch_name" != "refs/heads/master" ]; then
        echo 'Dotfiles not on master';
        exit
    fi

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

# Ignore SIGINT (Ctrl-C) and SIGHUP (terminal closed)
trap '' SIGINT
trap '' SIGHUP

# Skip if last updated in 30 minutes
if [ -f "$lastupdated_file" ]; then
    if [[ $(uname) == Linux ]]; then
        lastupdated=$(stat -c %Y "$lastupdated_file")
    else
        lastupdated=$(stat -f %m "$lastupdated_file")
    fi
    now=$(date +%s)
    if [ $((now - lastupdated)) -lt 1800 ]; then
        exit
    fi
fi
touch "$lastupdated_file"

# Check if there are updates to this dotfiles repo
cd ~/.dotfiles

check_internet
update_dotfiles

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    update_dotfiles
fi

# Reenable SIGINT and SIGHUP
trap SIGINT
trap SIGHUP
