#!/bin/bash

set -e

DIR=/Users/albertyw/Desktop/personal
VM='personal'

case "$1" in
    start)
        VBoxManage startvm $VM --type headless
        ;;
    stop)
        VBoxManage controlvm $VM acpipowerbutton
        ;;
    mount)
        if [ ! -d "$DIR" ]; then
            mkdir -p $DIR
        fi
        if mount | grep $DIR > /dev/null; then
            sudo umount -f $DIR
        fi
        sshfs -o follow_symlinks -o reconnect -o cache=no $VM:/home/albertyw/ $DIR
        ;;
    status)
        VMS=`vboxmanage list runningvms | grep $VM || true`
        if [[ -z $VMS ]]; then
            echo "Not Running"
        else
            echo "Running"
        fi
        ;;
    *)
        echo $"Usage: $0 {start|stop|mount|status}"
        dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        script=`basename "$0"`
        $dir/$script status
        exit 1
esac
