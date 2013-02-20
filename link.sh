#!/bin/sh

dotfiles=$HOME/.dotfiles/files/

if [ -f $HOME/.bashrc ] && [ ! -L $HOME/.bashrc ] ; then
    mv $HOME/.bashrc $HOME/.bashrc~
    ln -s $dotfiles/bashrc $HOME/.bashrc
fi

if [ -f $HOME/.forward ] && [ ! -L $HOME/.foward ]; then
    mv $HOME/.forward $HOME/.forward~
    ln -s $dotfiles/forward $HOME/.forward
fi

if [ -f $HOME/.git ] && [ ! -L $HOME/.git ]; then
    mv $HOME/.git $HOME/.git~
    ln -s $dotfiles/git $HOME/.git
fi

if [ -f $HOME/.gitconfig ] && [ ! -L $HOME/.gitconfig ]; then
    mv $HOME/.gitconfig $HOME/.gitconfig~
    ln -s $dotfiles/gitconfig $HOME/.gitconfig
fi

if [ -f $HOME/.gitignore ] && [ ! -L $HOME/.gitignore ]; then
    mv $HOME/.gitignore $HOME/.gitignore~
    ln -s $dotfiles/gitignore $HOME/.gitignore
fi

if [ -f $HOME/.selected_editor ] && [ ! -L $HOME/.selected_editor ]; then
    mv $HOME/.selected_editor $HOME/.selected_editor~
    ln -s $dotfiles/selected_editor $HOME/.selected_editor
fi

if [ -f $HOME/.sudo_as_admin_successful ] && [ ! -L $HOME/.sudo_as_admin_successful ]; then
    mv $HOME/.sudo_as_admin_successful $HOME/.sudo_as_admin_successful~
    ln -s $dotfiles/sudo_as_admin_successful $HOME/.sudo_as_admin_successful
fi

