#!/bin/bash

# Check whether local time is correct.  System time might drift on VMs.

if [[ "$(hostname)" != *"personal"* ]]; then
    exit 0
fi

URL='https://www.google.com'

DATESTRING=$(curl -sI "$URL" | grep -i "^date: ")

if [[ $? -ne 0 ]]; then
    echo "Can't connect to $HOST"
    exit 1
fi

DATESTRING="${DATESTRING/Date: /}"
DATESTRING="${DATESTRING/date: /}"

REMOTE_TIME="$(date --date="${DATESTRING}" +%s)"
LOCAL_TIME="$(date +%s)"

DIFFERENCE="$((LOCAL_TIME-REMOTE_TIME))"
DIFFERENCE="${DIFFERENCE#-}"
if [ "$DIFFERENCE" -ge 60 ]; then
    echo "Local time is out of sync by $DIFFERENCE seconds.  Running 'timesync'"
    sudo timedatectl set-ntp false
    sudo timedatectl set-ntp true
    echo "Finished timesync"
fi
