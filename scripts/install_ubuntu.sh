#!/bin/bash

set -ex

sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    finger      `: lookup users` \
    iotop       `: top for disk I/O` \
    iftop       `: top for network I/O` \
    jq          `: parse and prettify json` \
    htop        `: better top` \
    ngrep       `: read network traffic` \
    nmap        `: network map` \
    traceroute  `: find network hops to an IP` \
    tree        `: recursive ls` \
    vim         `: editor of choice` \
    whois       `: lookup domain ownership` \
    zip         `: when gzip fails`

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
cd ~/.dotfiles
git checkout files/bashrc # Seriously, WTF is heroku doing modifying my personal files?
cd -

# Unattended upgrades
sudo apt install -y unattended-upgrades
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /tmp/20auto-upgrades
sudo mv /tmp/20auto-upgrades /etc/apt/apt.conf.d/

# Set time zone
echo "America/Los_Angeles" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure --frontend noninteractive locales

# RVM (takes a long time)
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# curl -sSL https://get.rvm.io | bash -s stable --ruby
# sudo apt install ruby-dev # Fixes mkmf errors
# sudo apt install libgmp3-dev # Fixes installing json gem

# Node.js
sudo apt install build-essential checkinstall libssl-dev
mkdir -p ~/.nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
nvm install --lts

# Python/pip/virtualenvwrapper
sudo apt install python3 python3-dev python3-distutils
curl https://bootstrap.pypa.io/get-pip.py | sudo python3
sudo pip3 install virtualenvwrapper

# Install Go
sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
sudo apt update
sudo apt install golang

# Go Glide
mkdir -p $GOPATH/src/github.com/Masterminds
cd $GOPATH/src/github.com/Masterminds
git clone git@github.com:Masterminds/glide.git
cd glide
go install

# Go Tools
go get -u github.com/golang/lint/golint
