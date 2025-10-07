#!/bin/bash
which apt 
if [[ $? == 0 ]]; then
# for debian based distros
sudo apt update
cd ~/Downloads
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
sudo apt install -y ./docker-desktop-amd64.deb
sudo apt install yarn
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
systemctl enable docker-destkop
fi

which dnf 
if [[ $? == 0 ]]; then
# for fedora based distros
sudo dnf update
cd ~/Downloads
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
sudo dnf install -y ./docker-desktop-x86_64.rpm
sudo dnf install yarn
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
systemctl enable docker-destkop
fi
