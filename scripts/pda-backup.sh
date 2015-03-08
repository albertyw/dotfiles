#!/bin/bash

# Prereqs
sudo apt-get update
sudo apt-get install iftop htop iotop
sudo apt-get install davfs2 s3cmd zip

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

# Upload data
file="`date +"PDA %Y-%m-%d %H:%M:00 (Full)"`"
zip -r "$file" egnyte-local/*
s3cmd put "$file" s3://pharmadataassociates-backups/
rm "$file"

# Compute stats
find egnyte-local > files
du -hs egnyte-local > size
