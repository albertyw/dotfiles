#!/bin/bash
# This script synchronizes the local dotfiles repository

set -euo pipefail
IFS=$'\n\t'

check_internet () {
    ping github.com -c 1 > /dev/null 2>&1
}

check_time () {
    # Check that system time is correct.  System time might drift on VMs.
    if [[ "$(hostname)" != *"personal"* ]]; then
        return
    fi
    local_time="$(date +%s)"
    remote_time="$(curl -s "https://www.reaction.pics/time/" | jq .unixtime)"
    difference="$((local_time-remote_time))"
    difference="${difference#-}"
    if [ "$difference" -ge 60 ]; then
        echo "Local time is out of sync by $difference seconds.  Running 'timesync'"
        sudo timedatectl set-ntp false
        sudo timedatectl set-ntp true
        echo "Finished timesync"
    fi
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
check_time
check

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    check
fi
