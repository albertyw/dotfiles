#!/bin/bash

# EC2 Instance
# t2.small
# 700 GB EBS Cold HDD Volume

# Prereqs
sudo apt update
sudo apt upgrade -y
DEBIAN_FRONTEND=noninteractive sudo apt install -y davfs2 s3cmd zip git

# Set up scratch disk
sudo mkfs -t ext4 /dev/xvdb
mkdir scratch
sudo mount /dev/xvdb scratch
cd scratch
sudo chmod 777 .
mkdir egnyte
mkdir egnyte-local

# Download data
sudo mount.davfs https://pda.egnyte.com/webdav egnyte -o ro
screen rsync -rv egnyte/Shared/PDA/* egnyte-local/

# Download website
git clone git@github.com:albertyw/pharmadataassociates egnyte-local/pharmadataassociates.com

# Upload data
file="`date +"PDA %Y-%m-%d %H:%M:00 (Full)"`"
screen zip -r "$file" egnyte-local/*
screen s3cmd put "$file.zip" s3://pharmadataassociates-backups/
rm "$file"

# Compute stats
find egnyte-local | wc -l > files
du -hs egnyte-local > size

# To uncompress
# screen s3cmd get s3://pharmadataassociates-backups/$file.zip $file.zip
# unzip $file.zip
