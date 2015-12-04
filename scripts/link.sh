#!/bin/sh

set -e

dotfiles=$HOME/.dotfiles/files/

move () {
    echo $1
    if [ -L $HOME/.$1 ] ; then
        return 0
    fi
    if [ -f $HOME/.$1 ] || [ -d $HOME/.$1 ] ; then
        mv $HOME/.$1 $HOME/.$1~
    fi
    ln -s $dotfiles/$1 $HOME/.$1
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
#move gitconfig_local
