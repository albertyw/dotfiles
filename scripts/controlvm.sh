#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

DIR="$HOME/Desktop/personal"
VM="personal"
IP="192.168.64.2"

status() {
    if ping "$IP" -c 1 -t 1 &> /dev/null; then
        echo "Running"
    else
        echo "Not Running"
    fi
}

case "${1:-}" in
    miniaturize)
        osascript -e 'tell application "Finder" to set visible of process "UTM" to false'
        ;;
    start)
        open "utm://start?name=$VM"
        miniaturize
        ;;
    stop)
        open "utm://stop?name=$VM"
        if [ -d "$DIR" ]; then
            rmdir "$DIR"
        fi
        ;;
    mount)
        mkdir -p "$DIR"
        if mount | grep "$DIR" > /dev/null; then
            umount -f "$DIR"
        fi
        sshfs -o follow_symlinks -o reconnect -o cache=no $VM:/home/albertyw/ "$DIR"
        ;;
    umount)
        if mount | grep "$DIR" > /dev/null; then
            umount -f "$DIR"
        fi
        if [ -d "$DIR" ]; then
            rmdir "$DIR"
        fi
        ;;
    tunnel)
        if [ -z "${2:-}" ]; then
            echo "Must set tunnel port"
            exit 1
        fi
        PORT="$2"
        ssh -fNL "0.0.0.0:$PORT:localhost:$PORT" $VM
        ;;
    untunnel)
        if [ -z "${2:-}" ]; then
            echo "Must set tunnel port"
            exit 1
        fi
        PORT="$2"
        pkill -f "ssh -fNL 0.0.0.0:$PORT:localhost:$PORT $VM"
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {start|stop|mount|umount|tunnel|untunnel|status}"
        status
        exit 1
esac
