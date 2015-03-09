#!/bin/bash

sudo apt-get update
sudo apt-get install iotop iftop htop
sudo apt-get install finger whois tree traceroute
sudo apt-get install vim zip
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# git
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git

# Python/pip/virtualenvwrapper
curl https://bootstrap.pypa.io/get-pip.py | sudo python
sudo pip install virtualenvwrapper
