#!/bin/sh

export PACKAGES="zsh \
    neofetch \
    neovim \
    curl \
    wget \
    git"


echo "Running apt-get update to refresh package sources..."
sudo apt-get update

echo "Installing following packages"
echo $PACKAGES
sudo apt-get install -y $PACKAGES

echo "Installing Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Zsh Autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing Zsh Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Copying files..."
cp .bashrc ~/
echo ".bashrc -> ~/ ...DONE"
cp .zshrc ~/
echo ".zshrc -> ~/ ...DONE"
cp neofetch/* ~/.config/neofetch/
echo "neofetch/* -> ~/config/neofetch/ ...DONE"

## For Debian
echo "Installing Codium"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo apt update && sudo apt install codium
