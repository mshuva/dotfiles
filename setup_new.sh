#!/bin/bash
set -e # Exit if any command fails

# 1. Improved OS Detection (ID is more stable than NAME)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
else
    echo "Cannot detect OS. Exiting."
    exit 1
fi

# 2. Package Consolidation
export PKGS="zsh fastfetch btop neovim curl wget git codium"

# OS-Specific unique packages
export DEBIAN_PKGS="chsh python3-venv power-profiles-daemon xserver-xorg-input-synaptics"
export UBUNTU_PKGS="python3-venv vlc"
export FEDORA_PKGS="util-linux-user gvfs-mtp simple-mtpfs"

# 3. Installation Logic
if [ "$OS_ID" = "debian" ] || [ "$OS_ID" = "ubuntu" ]; then
    echo "Setting up VSCodium repo..."
    wget -qO - gitlab.com | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] download.vscodium.com vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
    
    sudo apt-get update
    # Installs PKGS + OS-specific packages
    if [ "$OS_ID" = "debian" ]; then
        sudo apt-get install -y "$PKGS" "$DEBIAN_PKGS"
    else
        sudo apt-get install -y "$PKGS" "$UBUNTU_PKGS"
    fi

elif [ "$OS_ID" = "fedora" ]; then
    echo "Setting up VSCodium repo..."
    sudo rpmkeys --import gitlab.com
    printf "[vscodium]\nname=vscodium\nbaseurl=download.vscodium.com\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=gitlab.com" | sudo tee /etc/yum.repos.d/vscodium.repo
    
    # Installs PKGS + Fedora-specific packages
    sudo dnf install -y "$PKGS" "$FEDORA_PKGS"
fi

# 4. Post-Install Tools (Unattended)
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL raw.githubusercontent.com)" "" --unattended

# 5. Shell Configuration
[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.backup
[ -f .zshrc ] && cp .zshrc ~/

echo "Changing shell to Zsh..."
sudo chsh -s "$(which zsh)" "$USER"

echo "Post-install complete! Run 'fastfetch' to see system info."
