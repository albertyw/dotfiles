#!/bin/bash

set -ex

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install iotop iftop htop
sudo apt-get install finger whois tree traceroute
sudo apt-get install vim zip
sudo apt-get install jq ngrep

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
cd ~/.dotfiles
git checkout files/bashrc # Seriously, WTF is heroku doing modifying my personal files?
cd -

# Unattended upgrades
sudo apt-get install -y unattended-upgrades
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /tmp/20auto-upgrades
sudo mv /tmp/20auto-upgrades /etc/apt/apt.conf.d/

# Set time zone
echo "America/Los_Angeles" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure --frontend noninteractive locales

# git
sudo apt-add-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git

# RVM (takes a long time)
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# curl -sSL https://get.rvm.io | bash -s stable --ruby
# sudo apt-get install ruby-dev # Fixes mkmf errors
# sudo apt-get install libgmp3-dev # Fixes installing json gem

# Node.js
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs

# Python/pip/virtualenvwrapper
curl https://bootstrap.pypa.io/get-pip.py | sudo python2
curl https://bootstrap.pypa.io/get-pip.py | sudo python3
sudo pip2 install virtualenvwrapper
sudo pip3 install virtualenvwrapper

# Go
sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
sudo apt-get update
sudo apt-get install golang

# Go Glide
wget https://github.com/Masterminds/glide/releases/download/v0.12.1/glide-v0.12.1-linux-amd64.tar.gz
tar xvf glide-v0.12.1-linux-amd64.tar.gz
mv linux-amd64/glide ~/.dotfiles/bin
rm -r linux-amd64
rm glide-v0.12.1-linux-amd64.tar.gz

# Go Tools
go get -u github.com/golang/lint/golint
