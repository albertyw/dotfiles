#!/bin/bash

# EC2 Instance
# t2.small
# 600 GB EBS Cold HDD Volume

# Prereqs
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y iftop htop iotop davfs2 s3cmd zip git

# Set up scratch disk
sudo mkfs -t ext4 /dev/xvdb
mkdir scratch
sudo mount /dev/xvdb scratch
cd scratch
sudo chmod 777 .
mkdir egnyte
mkdir egnyte-local

# Download data
sudo mount.davfs pda.egnyte.com/webdav egnyte -o ro
screen rsync -rv egnyte/Shared/PDA/* egnyte-local/

# Download website
git clone git@github.com:albertyw/pharmadataassociates egnyte-local/pharmadataassociates.com

# Upload data
file="`date +"PDA %Y-%m-%d %H:%M:00 (Full)"`"
screen zip -r "$file" egnyte-local/*
gpg -r 8B4CEA83 -e $file
screen s3cmd put "$file.gpg" s3://pharmadataassociates-backups/
rm "$file"

# Compute stats
find egnyte-local | wc -l > files
du -hs egnyte-local > size


# To uncompress/decrypt
# screen s3cmd get s3://pharmadataassociates-backups/$file.gpg $file.gpg
# gpg -d $file.gpg > $file
# tar xvf $file
