#!/bin/bash

secure_secret_files () {
    if [ -n "$1" ]; then
        chmod 600 "$@"
    fi
}

secretfiles=$(find ~/.ssh | grep id_.*$ | grep -vF .pub)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep _rsa$)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep .pem)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep s3cfg)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep p12)
secure_secret_files $secretfiles
