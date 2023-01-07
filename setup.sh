#!/bin/sh

PACKAGES = "zsh \
    neofetch \
    neovim \
    git"


echo "Running apt-get update to refresh package sources..."
sudo apt-get update

echo "Installing following packages"
echo $PACKAGES
sudo apt-get install -y $PACKAGES