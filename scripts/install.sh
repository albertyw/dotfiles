#!/bin/bash

sudo apt-get update
sudo apt-get install iotop iftop htop
sudo apt-get install finger whois tree traceroute
sudo apt-get install vim zip
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Unattended upgrades
sudo apt-get install -y unattended-upgrades
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /tmp/20auto-upgrades
sudo mv /tmp/20auto-upgrades /etc/apt/apt.conf.d/

# git
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git

# Python/pip/virtualenvwrapper
curl https://bootstrap.pypa.io/get-pip.py | sudo python
curl https://bootstrap.pypa.io/get-pip.py | sudo python3
sudo pip install virtualenvwrapper
