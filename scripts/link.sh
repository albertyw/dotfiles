#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

cd "$HOME/.dotfiles"
dotfiles=$HOME/.dotfiles/files

move () {
    # shellcheck disable=SC2086
    if [ -z ${2+x} ] ; then
        dest=$1
    else
        dest=$2
    fi
    echo "$1"
    if [ -L "$HOME/.$dest" ] ; then
        return 0
    fi
    if [ -f "$HOME/.$dest" ] || [ -d "$HOME/.$dest" ] ; then
        mv "$HOME/.$dest" "$HOME/.$dest~"
    fi
    ln -s "$dotfiles/$1" "$HOME/.$dest"
}

git submodule init
git submodule update --recursive

move aider.conf.yml
move bash_profile
move bashrc
move config
move copilotignore
move direnvrc
move gitconfig
move gitignore
move selected_editor
move sudo_as_admin_successful
move tmux.conf
move vim
move vimrc
move zshrc
if [[ $(hostname) == *"uber"* ]] ; then
    move gitconfig_uber gitconfig_local
    move bashrc_uber bashrc_local
fi

exec bash
