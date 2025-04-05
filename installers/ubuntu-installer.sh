#!/bin/bash
set -euo pipefail

cd ~/Downloads || { echo "Failed to cd to ~/Downloads"; exit 1; }

# Update system
sudo apt update && sudo apt upgrade -y || { echo "System update failed"; exit 1; }

# Install essential tools
sudo apt install -y tmux zip ripgrep nodejs npm gdb python3-pip python3.12-venv ffmpeg obs-studio openshot-qt firefox llvm gnome-tweaks gnome-shell-extensions build-essential wget unzip git gh btop gthumb okular curl stow || { echo "Package install failed"; exit 1; }

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || { echo "Chrome download failed"; exit 1; }
sudo apt install ./google-chrome-stable_current_amd64.deb || true
sudo apt --fix-broken install || { echo "Fixing Chrome dependencies failed"; exit 1; }

# Install Neovim
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y || { echo "Neovim install failed"; exit 1; }

# Install Flatpak apps
sudo apt install -y flatpak gnome-software-plugin-flatpak || { echo "Flatpak install failed"; exit 1; }
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
flatpak install -y flathub md.obsidian.Obsidian com.protonvpn.www || { echo "Flatpak app install failed"; exit 1; }

# Install Nerd Font
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip" || { echo "Font download failed"; exit 1; }
mkdir -p ~/.local/share/fonts
unzip JetBrainsMono.zip -d ~/.local/share/fonts || { echo "Font unzip failed"; exit 1; }
fc-cache -fv
rm JetBrainsMono.zip

# Setup GitHub SSH
EMAIL="nmd03pvt@gmail.com"
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "${EMAIL}" || { echo "SSH keygen failed"; exit 1; }
fi
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519 || { echo "SSH add failed"; exit 1; }
command -v xclip >/dev/null 2>&1 && cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
echo "Copied SSH key to clipboard"
echo "Add your SSH key to GitHub: https://github.com/settings/keys"

# Dotfiles
git clone git@github.com:haruki-nguyen/.dotfiles.git ~/.dotfiles || { echo "Dotfiles clone failed"; exit 1; }
mv ~/.bashrc ~/.bashrc.bak || true
cd ~/.dotfiles
stow . || { echo "Stowing dotfiles failed"; exit 1; }
cd -
rm ~/.bashrc.bak || true

# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || { echo "TMUX plugin manager clone failed"; exit 1; }
tmux source ~/.config/tmux/tmux.conf || { echo "TMUX config reload failed"; exit 1; }
echo "Press <prefix> + I to install Tmux plugins."

# Cleanup
rm -rf ~/Downloads/*
cd ~

echo "Setup complete! Restart your terminal."
