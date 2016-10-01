#!/bin/bash

secure_secret_files () {
    if [ -n "$1" ]; then
        chmod 600 $1
    fi
}

secretfiles=$(find ~/.ssh | grep id_.*$)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep .pem)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep s3cfg)
secure_secret_files $secretfiles

secretfiles=$(find ~/.ssh | grep p12)
secure_secret_files $secretfiles
