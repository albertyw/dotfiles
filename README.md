Dot Files
=========

[![Build Status](https://drone.albertyw.com/api/badges/albertyw/dotfiles/status.svg)](https://drone.albertyw.com/albertyw/dotfiles)
[![Codeship Status for albertyw/dotfiles](https://app.codeship.com/projects/3dc1f750-2855-0137-4069-2e43d34d05fc/status?branch=master)](https://app.codeship.com/projects/330763)
[![Code Climate](https://codeclimate.com/github/albertyw/dotfiles/badges/gpa.svg)](https://codeclimate.com/github/albertyw/dotfiles)

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
