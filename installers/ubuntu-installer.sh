#!/bin/bash
set -euo pipefail

cd ~/Downloads

# System update
sudo apt update && sudo apt upgrade -y

# Install apt packages
PACKAGES=(
  tmux zip ripgrep nodejs npm gdb python3-pip python3.12-venv ffmpeg obs-studio
  openshot-qt llvm build-essential wget unzip git gh btop gthumb okular curl stow
  gdm-settings p7zip-full alacritty ibus-unikey keepassxc
  gnome-browser-connector gnome-tweaks gnome-shell-extension-manager zsh zoxide
)
sudo apt install -y "${PACKAGES[@]}"

ibus restart
echo 'GTK_IM_MODULE=ibus' >> ~/.profile

# Install Hyprland
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y hyprland

# Chrome install
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb || sudo apt --fix-broken install -y

# Set Alacritty default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec alacritty

# ZSH & Oh My Zsh
chsh -s "$(which zsh)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ulauncher
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:agornostal/ulauncher
sudo apt update && sudo apt install -y ulauncher

# Flatpak setup & install
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.protonvpn.www md.obsidian.Obsidian io.github.realmazharhussain.GdmSettings

# Snap apps
sudo snap install --classic code
sudo snap install postman libreoffice

# RQuickShare
REPO="Martichou/rquickshare"
LATEST=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r .tag_name)
DEB="r-quick-share-main_${LATEST}_glibc-2.39_amd64.deb"
wget -q --show-progress "https://github.com/$REPO/releases/download/$LATEST/$DEB"
sudo apt install -y "./$DEB" && rm "$DEB"

# Discord
wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb && rm discord.deb

# MPLAB + XC8
# wget --referer="https://www.microchip.com" -O mplabx.tar "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/MPLABX-v6.25-linux-installer.tar"
# tar -xf mplabx.tar && chmod +x MPLABX-*.sh && sudo ./MPLABX-*.sh -- --mode unattended
# wget --referer="https://www.microchip.com" -O xc8.run "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v3.00-full-install-linux-x64-installer.run"
# chmod +x xc8.run && sudo ./xc8.run
# rm -rf mplabx.tar MPLABX-*.sh xc8.run

# Nerd Font
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
mkdir -p ~/.local/share/fonts && unzip JetBrainsMono.zip -d ~/.local/share/fonts && fc-cache -fv && rm JetBrainsMono.zip

# GitHub SSH
EMAIL="nmd03pvt@gmail.com"
[[ -f ~/.ssh/id_ed25519 ]] || ssh-keygen -t ed25519 -C "$EMAIL"
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
command -v xclip >/dev/null && xclip -sel clip < ~/.ssh/id_ed25519.pub
echo "Add your SSH key to GitHub: https://github.com/settings/keys"

# Dotfiles
git clone git@github.com:haruki-nguyen/.dotfiles.git ~/.dotfiles || true
mv ~/.bashrc ~/.bashrc.bak || true
cd ~/.dotfiles && stow . && cd ~ && rm ~/.bashrc.bak || true

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true
tmux source ~/.config/tmux/tmux.conf || true
echo "Press <prefix> + I to install Tmux plugins."

# Syncthing & Data
mkdir -p ~/Documents/"My Data"
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

# Cleanup
rm -rf ~/Downloads/*
echo "Setup complete! Restart your terminal."

# Create ~/Applications folder
mkdir -p ~/Applications