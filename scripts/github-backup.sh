#!/bin/bash

# Back up all github data

mkdir github
cd github

mkvirtualenv backup
pip install git+git://github.com/albertyw/python-github-backup.git#egg=github-backup

token=''

mkdir albertyw
github-backup --username albertyw --token $token --private --all --prefer-ssh --output albertyw albertyw

mkdir cellabus
github-backup --username albertyw --token $token --private --all --prefer-ssh --output cellabus --organization cellabus

mkdir statsonice
github-backup --username albertyw --token $token --private --all --prefer-ssh --output statsonice --organization statsonice
github-backup --username albertyw --token $token --private --all --prefer-ssh --output statsonice curranoi

mkdir almlab
github-backup --username albertyw --token $token --private --all --prefer-ssh --output almlab --organization almlab


rmvirtualenv backup
