#!/bin/bash

set -ex

# Set up homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Utilities
brew install \
    bash-completion `: autocompletion for bash terminal` \
    htop            `: better top` \
    iftop           `: top for network I/O` \
    jq              `: parse and prettify json` \
    ngrep           `: read network traffic` \
    nmap            `: network map` \
    tree            `: recursive ls` \
    wget            `: curl alternative` \
    vim             `: install vim 8.0`

# Python 3
brew install python3

# Install go
brew install go

# Go Glide
curl -OL https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-darwin-amd64.tar.gz
tar xvf glide-v0.12.3-linux-amd64.tar.gz
mv darwin-amd64/glide ~/.dotfiles/bin
rm -r linux-amd64
rm glide-v0.12.3-darwin-amd64.tar.gz

# Go Tools
go get -u github.com/golang/lint/golint

# jEdit
git clone git@github.com:albertyw/jEdit-settings
rm -r ~/Library/jEdit
mv jEdit-settings ~/Library/jEdit
