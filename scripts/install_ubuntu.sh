#!/bin/bash

set -euxo pipefail
IFS=$'\n\t'

sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
sudo apt update
sudo apt upgrade -y
# shellcheck disable=SC2006,SC2046
sudo apt install -y \
    direnv      `: directory-specific environments` \
    iotop       `: top for disk I/O` \
    iftop       `: top for network I/O` \
    jq          `: parse and prettify json` \
    htop        `: better top` \
    ngrep       `: read network traffic` \
    nmap        `: network map` \
    neovim      `: better vim` \
    traceroute  `: find network hops to an IP` \
    tree        `: recursive ls` \
    vim         `: editor of choice` \
    whois       `: lookup domain ownership` \
    zip         `: when gzip fails`

# Unattended upgrades
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

# Git
# Install a more recent version of git than is bundled with Ubuntu
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git

# Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts

# Python/pip/virtualenv
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.13 python3.13-venv python3.13-dev

# Install Go
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install firefox
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt install firefox
