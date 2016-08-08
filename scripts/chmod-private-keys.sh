#!/bin/bash

find ~/.ssh | grep _rsa$ | xargs chmod 600
find ~/.ssh | grep .pem | xargs chmod 600
find ~/.ssh | grep s3cfg | xargs chmod 600
find ~/.ssh | grep p12 | xargs chmod 600
