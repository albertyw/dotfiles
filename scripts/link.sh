#!/bin/bash

set -e

dotfiles=$HOME/.dotfiles/files/

move () {
    if [ -z $2 ] ; then
        dest=$1
    else
        dest=$2
    fi
    echo $1
    if [ -L $HOME/.$dest ] ; then
        return 0
    fi
    if [ -f $HOME/.$dest ] || [ -d $HOME/.$dest ] ; then
        mv $HOME/.$dest $HOME/.$dest~
    fi
    ln -s $dotfiles/$1 $HOME/.$dest
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

. ~/.bashrc
. ~/.bash_profile
