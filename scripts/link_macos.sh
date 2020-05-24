#!/bin/bash

# Set up files for MacOS

set -euo pipefail
IFS=$'\n\t'

mkdir -p ~/Library/KeyBindings/
ln -s ~/.dotfiles/files/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
