#!/bin/sh

dotfiles=$HOME/.dotfiles/files/

if [ -f ~/.bashrc ]; then
    mv $HOME/.bashrc $HOME/.bashrc~
fi
ln -s $dotfiles/bashrc $HOME/.bashrc

if [ -f $HOME/.forward ]; then
    mv $HOME/.forward $HOME/.forward~
fi
ln -s $dotfiles/forward $HOME/.forward

if [ -f $HOME/.git ]; then
    mv $HOME/.git $HOME/.git~
fi
ln -s $dotfiles/git $HOME/.git

if [ -f $HOME/.gitconfig ]; then
    mv $HOME/.gitconfig $HOME/.gitconfig~
fi
ln -s $dotfiles/gitconfig $HOME/.gitconfig

if [ -f $HOME/.gitignore ]; then
    mv $HOME/.gitignore $HOME/.gitignore~
fi
ln -s $dotfiles/gitignore $HOME/.gitignore

if [ -f $HOME/.selected_editor ]; then
    mv $HOME/.selected_editor $HOME/.selected_editor~
fi
ln -s $dotfiles/selected_editor $HOME/.selected_editor

if [ -f $HOME/.sudo_as_admin_successful ]; then
    mv $HOME/.sudo_as_admin_successful $HOME/.sudo_as_admin_successful~
fi
ln -s $dotfiles/sudo_as_admin_successful $HOME/.sudo_as_admin_successful
