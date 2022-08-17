#!/bin/bash

set -euxo pipefail
IFS=$'\n\t'

# Set up homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

# Utilities
# shellcheck disable=SC2006,SC2046
brew install \
    bash-completion `: autocompletion for bash terminal` \
    git             `: more up-to-date git than what macos provides` \
    grep            `: faster gnu grep` \
    htop            `: better top` \
    iftop           `: top for network I/O` \
    jq              `: parse and prettify json` \
    less            `: more up-to-date less than what macos provides` \
    ngrep           `: read network traffic` \
    nmap            `: network map` \
    coreutils       `: utility for dereferencing symlinks` \
    tree            `: recursive ls` \
    wget            `: curl alternative` \
    vim             `: install vim 8.0` \

# Python
brew install python
brew install python3

# Install go
brew install go

# jEdit
git clone git@github.com:albertyw/jEdit-settings
rm -r ~/Library/jEdit
mv jEdit-settings ~/Library/jEdit

# Install inconsolata font
open https://fonts.google.com/specimen/Inconsolata

# Disable Spotlight Indexing
sudo mdutil -a -s
sudo mdutil -a -i off

# Disable showing accented characters when holding down key
defaults write -g ApplePressAndHoldEnabled -bool false
