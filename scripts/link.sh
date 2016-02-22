#!/bin/bash

set -e

dotfiles=$HOME/.dotfiles/files/

move () {
    if [ -z $2 ] ; then
        $2=$1
    fi
    echo $1
    if [ -L $HOME/.$2 ] ; then
        return 0
    fi
    if [ -f $HOME/.$2 ] || [ -d $HOME/.$2 ] ; then
        mv $HOME/.$2 $HOME/.$2~
    fi
    ln -s $dotfiles/$1 $HOME/.$2
}

move atom
move bash_profile
move bashrc
move git
move gitconfig
move gitignore
move irbrc
move selected_editor
move sudo_as_admin_successful
move vim
move vimrc
if [[ `hostname` == *"uber"* ]] ; then
    move gitconfig_uber gitconfig_local
    move bashrc_uber bashrc_local
fi
