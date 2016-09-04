#!/bin/bash

set -e

VM='personal'

case "$1" in
    start)
        VBoxManage startvm $VM --type headless
        ;;
    stop)
        VBoxManage controlvm $VM acpipowerbutton
        ;;
    mount)
        DIR=`dirname $0`
        echo $DIR
        sshfs -o follow_symlinks -o reconnect -o cache=no $VM:/home/albertyw/ $DIR
        ;;
esac
