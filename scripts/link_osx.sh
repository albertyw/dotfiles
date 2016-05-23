#!/bin/bash

# Set up files for OSX

mkdir -p ~/Library/KeyBindings/
ln -s ~/.dotfiles/files/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict

# Set up iterm config
ln -s ~/.dotfiles/files/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
