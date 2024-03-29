Dot Files
=========

[![Build Status](https://drone.albertyw.com/api/badges/albertyw/dotfiles/status.svg)](https://drone.albertyw.com/albertyw/dotfiles)

This repository includes my personal Unix config files that are synchronized
across my various computers.

It is based off of [hrs's dotfiles](https://github.com/hrs/dotfiles).

Contents
--------

There are a few particular files/directories to note in here:

- [bashrc](https://github.com/albertyw/dotfiles/blob/master/files/bashrc)
- [gitconfig](https://github.com/albertyw/dotfiles/blob/master/files/gitconfig)
  - [git browse](https://github.com/albertyw/git-browse)
  - [git reviewers](https://github.com/albertyw/git-reviewers)
- [vim configs](https://github.com/albertyw/dotfiles/tree/master/files/vim/)

Setup
-----

```shell
git clone git@github.com:albertyw/dotfiles.git .dotfiles
cd .dotfiles
scripts/link.sh
scripts/install.sh
```
