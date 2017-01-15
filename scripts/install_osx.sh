#!/bin/bash

set -ex

# Set up homebrew
# TODO

# Python 3
brew install python3

# Install go
# TODO

# Go Glide
curl -OL https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-darwin-amd64.tar.gz
tar xvf glide-v0.12.3-linux-amd64.tar.gz
mv darwin-amd64/glide ~/.dotfiles/bin
rm -r linux-amd64
rm glide-v0.12.3-darwin-amd64.tar.gz

# Go Tools
go get -u github.com/golang/lint/golint
