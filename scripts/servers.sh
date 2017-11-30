#!/bin/bash
# This is a simple replacement for puppet

LOCAL_MACHINES="personal"
REMOTE_MACHINES="
statsonice.com
albertyw.com
log.fit
"

hosts=""
# hosts="$hosts $LOCAL_MACHINES"
hosts="$hosts $REMOTE_MACHINES"

for server in $hosts; do
    ssh $server -q '
        hostname
'
done
