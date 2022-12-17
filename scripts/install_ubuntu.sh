#!/bin/bash

set -euxo pipefail
IFS=$'\n\t'

sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
sudo apt update
sudo apt upgrade -y
# shellcheck disable=SC2006,SC2046
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

# wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
# (
#     cd ~/.dotfiles
#     git checkout files/bashrc # Seriously, WTF is heroku doing modifying my personal files?
# )

# Unattended upgrades
sudo apt install -y unattended-upgrades
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /tmp/20auto-upgrades
sudo mv /tmp/20auto-upgrades /etc/apt/apt.conf.d/
sudo pro config set apt_news=false

# Set time zone
sudo timedatectl set-timezone America/Los_Angeles
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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts

# Python/pip/virtualenvwrapper
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.10 python3.10-dev python3.10-distutils
sudo python3 get-pip.py
sudo python3 -m pip install virtualenv
sudo python3 -m pip install virtualenvwrapper

# Install Go
sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
sudo apt update
sudo apt install golang

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
