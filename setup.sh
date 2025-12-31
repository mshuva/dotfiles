#!/bin/sh

# Grab OS information
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

export PKGS="zsh \
    fastfetch \
    neovim \
    curl \
    wget \
    git \
    codium"

export DEBIAN_PKGS="chsh \
    btop \
    curl \
    fastfetch \
    neovim \
    python3-venv \
    power-profiles-daemon \
    xserver-xorg-input-synaptics \
    zsh"

export UBUNTU_PKGS="python3-venv \
		vlc"

export FEDORA_PKGS="util-linux-user \
    gvfs-mtp \
    simple-mtpsf"

if [ "$OS" = "Debian GNU/Linux" ]; then
echo "Adding Codium GPG keys"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
   | gpg --dearmor \
   | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
   | sudo tee /etc/apt/sources.list.d/vscodium.list

echo "Running apt-get update to refresh package sources..."
sudo apt-get update

echo "Installing following packages"
echo $PKGS $DEBIAN_PKGS
sudo apt-get install -y $PKGS $DEBIAN_PKGS
elif [ "$OS" = "Ubuntu" ]; then
echo "Adding Codium GPG keys"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
   | gpg --dearmor \
   | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
   | sudo tee /etc/apt/sources.list.d/vscodium.list

echo "Running apt-get update to refresh package sources..."
sudo apt-get update

echo "Installing following packages"
echo $PKGS $UBUNTU_PKGS
sudo apt-get install -y $PKGS $UBUNTU_PKGS
elif [ "$OS" = "Fedora Linux" ]; then
echo "Adding Codium rpm keys"
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo

echo "Running dnf check-update to refresh package sources..."
sudo dnf check-update

echo "Installing following packages"
echo $PKGS $FEDORA_PKGS
sudo dnf install -y $PKGS $FEDORA_PKGS
else
echo "Can't determine operating system. Exiting."
fi

echo "fastfetch installed..."
fastfetch

echo "Installing Oh My Zsh (unattended)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Installing Zsh Autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing Zsh Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Backing up old files..."
mv ~/.bashrc ~/.bashrc.backup
echo "~/.bashrc -> ~/.bashrc.backup ...DONE"

echo "Copying files..."
#cp .bashrc ~/
#echo ".bashrc -> ~/ ...DONE"
cp .zshrc ~/
echo ".zshrc -> ~/ ...DONE"
# -- Deprecated --
# cp neofetch/* ~/.config/neofetch/
# echo "neofetch/* -> ~/.config/neofetch/ ...DONE"

echo "Changing shell to Zsh"
chsh -s $(which zsh)
