#!/bin/bash
which apt 
if [[ $? == 0 ]]; do
# for debian based distros
sudo apt update
cd ~/Downloads
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
sudo apt install -y ./docker-desktop-amd64.deb
sudo apt install yarn
sudo apt install nvm
sudo apt install gh
systemctl enable docker-destkop
gh auth login
endif

which dnf 
if [[ $? == 0 ]]; do
# for fedora based distros
sudo dnf update
cd ~/Downloads
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
sudo dnf install -y ./docker-desktop-x86_64.rpm
sudo dnf install yarn
sudo dnf install gh
systemctl enable docker-destkop
gh auth login
endif

