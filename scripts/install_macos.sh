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
    vim             `: install vim 8.0` \
    less            `: install newer version of less`

# System monitoring
gem install iStats

# Python
brew install python
brew install python3

# Install go
brew install go

# Go Glide
mkdir -p "$GOPATH/src/github.com/Masterminds"
cd "$GOPATH/src/github.com/Masterminds"
git clone git@github.com:Masterminds/glide.git
cd glide
go install

# Go Tools
go get -u github.com/golang/lint/golint

# jEdit
git clone git@github.com:albertyw/jEdit-settings
rm -r ~/Library/jEdit
mv jEdit-settings ~/Library/jEdit
