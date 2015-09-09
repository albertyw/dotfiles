#!/bin/bash

# Prereqs
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y iftop htop iotop davfs2 s3cmd zip

# Set up scratch disk
sudo mkfs -t ext4 /dev/xvdb
mkdir scratch
sudo mount /dev/xvdb scratch
cd scratch
sudo chmod 777 .
mkdir egnyte
mkdir egnyte-local

# Download data
sudo mount.davfs http://webdav-pda.egnyte.com/pda-egnyte egnyte -o ro
screen cp -rvn egnyte/Shared/PDA/* egnyte-local/

# Download website
git clone git@github.com:albertyw/pharmadataassociates egnyte-local/pharmadataassociates.com

# Upload data
file="`date +"PDA %Y-%m-%d %H:%M:00 (Full)"`"
zip -r "$file" egnyte-local/*
s3cmd put --multipart-chunk-size-mb=100 "$file" s3://pharmadataassociates-backups/
rm "$file"

# Compute stats
find egnyte-local | wc -l > files
du -hs egnyte-local > size
