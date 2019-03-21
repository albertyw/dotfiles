#!/bin/bash

secure_secret_files () {
    if [ -z "$1" ] ; then
        return
    fi
    while read -r file; do
        chmod 600 "$file"
    done <<< "$1"
}

secretfiles=$(find ~/.ssh | grep id_ | grep -vF .pub)
secure_secret_files "$secretfiles"

secretfiles=$(find ~/.ssh | grep _rsa$)
secure_secret_files "$secretfiles"

secretfiles=$(find ~/.ssh | grep .pem)
secure_secret_files "$secretfiles"

secretfiles=$(find ~/.ssh | grep s3cfg)
secure_secret_files "$secretfiles"

secretfiles=$(find ~/.ssh | grep p12)
secure_secret_files "$secretfiles"

secretfiles=$(find ~/.ssh | grep gpg)
secure_secret_files "$secretfiles"

secretfiles=$(find ~/.ssh | grep davfs2)
secure_secret_files "$secretfiles"
