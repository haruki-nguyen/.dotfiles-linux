#!/bin/bash

cd ~/Downloads
sudo apt update && sudo apt upgrade -y

# Essential tools
# python3.12-venv: for install Mason packages in NvChad
sudo apt install -y tmux zip ripgrep nodejs npm gdb python3-pip python3.12-venv ffmpeg obs-studio openshot-qt firefox llvm gnome-tweaks gnome-shell-extensions build-essential wget unzip git gh btop gthumb okular curl stow

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
# Fix dependencies issue
sudo apt --fix-broken install

# Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y

# Flatpak => installing Obsidian, ProtonVPN
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub md.obsidian.Obsidian com.protonvpn.www

# AutoHotKey, replacement for Espanso, b/c it will encounter some issues on GNOME that using Wayland
# sudo apt install -y autokey-gtk

# Nerd Font
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
mkdir -p ~/.local/share/fonts
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv
rm JetBrainsMono.zip

# GitHub SSH
EMAIL="nmd03pvt@gmail.com"
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C ${EMAIL}
fi
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
echo "Copied the content of ~/.ssh/id_ed25519.pub to the clipboard"
echo "Add your SSH key to GitHub: https://github.com/settings/keys"

# Dotfiles
git clone git@github.com:haruki-nguyen/.dotfiles.git ~/.dotfiles
mv ~/.bashrc ~/.bashrc.bak
cd ~/.dotfiles
stow . || { echo "Stowing failed"; exit 1; }
cd -
rm ~/.bashrc.bak
 
# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.config/tmux/tmux.conf
echo "Press <prefix> + I to install Tmux plugins."

# Cleanup
rm -rf ~/Downloads/*
cd ~

echo "Setup complete! Restart your terminal."
