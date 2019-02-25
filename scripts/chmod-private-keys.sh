#!/bin/bash

secure_secret_files () {
    for i in "$@"; do
        chmod 600 "$i"
    done
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
