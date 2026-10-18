#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

cd "$HOME/.dotfiles"
dotfiles=$HOME/.dotfiles/files
linked=false

move () {
    # shellcheck disable=SC2086
    if [ -z ${2+x} ] ; then
        dest=$1
    else
        dest=$2
    fi
    path="$HOME/.$dest"
    if [ "$(readlink "$path")" == "$dotfiles/$1" ] ; then
        return 0
    fi
    if [ -e "$path" ] || [ -L "$path" ] ; then
        if [ -e "$path~" ] || [ -L "$path~" ] ; then
            echo "Cannot back up $path: $path~ already exists" >&2
            exit 1
        fi
        mv "$path" "$path~"
    fi
    echo "$1"
    ln -s "$dotfiles/$1" "$path"
    linked=true
}

git submodule init
git submodule update --recursive

move bash_profile
move bashrc
move claude
move config
move direnvrc
move gitconfig
move gitignore
move screenrc
move selected_editor
move sudo_as_admin_successful
move tmux.conf
move vim
move vimrc
move zshrc
if [[ $(hostname) == *"uber"* ]] || [ -n "${UBER_OWNER:-}" ] ; then
    move gitconfig_uber gitconfig_local
    move bashrc_uber bashrc_local
fi

if [ "$linked" == true ] && [ -t 0 ] ; then
    exec bash
fi
