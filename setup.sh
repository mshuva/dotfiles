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
