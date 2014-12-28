#!/bin/bash

# Prereqs
sudo apt-get install davfs2 s3cmd
mkdir egnyte
mkdir egnyte-local

# Download data
sudo mount.davfs http://webdav-pda.egnyte.com/pda-egnyte egnyte -o ro
sudo cp egnyte/Shared/PDA/* egnyte-local/

# Upload data
file="`date +"PDA %Y-%m-%d %H:%M:00 (Full)"`"
zip -r "$file" egnyte-local/*
s3cmd put "$file" s3://pharmadataassociates-backups/
rm "$file"

# Compute stats
find egnyte-local > files
du -hs egnyte-local > size
