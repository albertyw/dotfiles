#!/bin/bash

sudo apt-get update
sudo apt-get install iotop iftop htop
sudo apt-get install finger whois tree traceroute
sudo apt-get install vim zip

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
cd ~/.dotfiles
git checkout files/bashrc # Seriously, WTF is heroku doing modifying my personal files?
cd -

# Unattended upgrades
sudo apt-get install -y unattended-upgrades
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";\n" > /tmp/20auto-upgrades
sudo mv /tmp/20auto-upgrades /etc/apt/apt.conf.d/

# git
sudo apt-add-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git

# Python/pip/virtualenvwrapper
curl -sL https://raw.githubusercontent.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL

# RVM (takes a long time)
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# curl -sSL https://get.rvm.io | bash -s stable --ruby
# sudo apt-get install ruby-dev # Fixes mkmf errors

# Node.js
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install nodejs
