#!/bin/bash
set -euo pipefail

cd ~/Downloads || { echo "Failed to cd to ~/Downloads"; exit 1; }

# Update system
sudo apt update && sudo apt upgrade -y || { echo "System update failed"; exit 1; }

# Install essential tools
sudo apt install -y tmux zip ripgrep nodejs npm gdb python3-pip python3.12-venv ffmpeg obs-studio openshot-qt firefox llvm gnome-tweaks gnome-shell-extensions build-essential wget unzip git gh btop gthumb okular curl stow gnome-browser-connector kitty gdm-settings p7zip-full rclone || { echo "Package install failed"; exit 1; }

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || { echo "Chrome download failed"; exit 1; }
sudo apt install ./google-chrome-stable_current_amd64.deb || true
sudo apt --fix-broken install || { echo "Fixing Chrome dependencies failed"; exit 1; }

# Install Neovim
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y || { echo "Neovim install failed"; exit 1; }

# Install Flatpak apps: Obsidian, ProtonVPN, Bottles (for running Windows softwares)
sudo apt install -y flatpak gnome-software-plugin-flatpak || { echo "Flatpak install failed"; exit 1; }
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
flatpak install -y flathub md.obsidian.Obsidian com.protonvpn.www com.usebottles.bottles || { echo "Flatpak app install failed"; exit 1; }

# Install apps from Snap: OnlyOffice
sudo snap install onlyoffice-desktopeditors

# RQuickShare (Rust implementation of QuickShare)
# Define the GitHub repository
REPO="Martichou/rquickshare"
# Fetch the latest release tag from GitHub API
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r .tag_name)
# Construct the download URL for the latest .deb package
DEB_PACKAGE="r-quick-share-main_${LATEST_RELEASE}_glibc-2.39_amd64.deb"
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/$DEB_PACKAGE"
# Download the .deb package
echo "Downloading $DEB_PACKAGE..."
wget -q --show-progress "$DOWNLOAD_URL"
# Install the downloaded package
echo "Installing $DEB_PACKAGE..."
sudo apt install -y ./"$DEB_PACKAGE"
# Clean up by removing the downloaded .deb package
rm "$DEB_PACKAGE"
echo "RQuickShare version $LATEST_RELEASE has been installed successfully."

# Discord
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install ./discord.deb
rm discord.deb

# MPLAB X IDE
# Download URL (update if version changes)
MPLABXIDE_URL="https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/MPLABX-v6.25-linux-installer.tar"
# Download and extract
# Use direct link b/c the link is protected or redirects.
wget --referer="https://www.microchip.com" --user-agent="Mozilla" "$MPLABXIDE_URL" -O mplabx.tar
tar -xf mplabx.tar
# Run installer (non-GUI, accept defaults)
chmod +x MPLABX-v6.25-linux-installer.sh
sudo ./MPLABX-v6.25-linux-installer.sh -- --mode unattended
#
# XC8 compiler
XC8_URL="https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc8-v3.00-full-install-linux-x64-installer.run"
# Use direct link b/c the link is protected or redirects.
wget --referer="https://www.microchip.com" --user-agent="Mozilla" "$XC8_URL" -O xc8.run
# Run installer (non-GUI, accept defaults)
chmod +x xc8.run
sudo ./xc8.run
#
# Clean up
rm mplabx.tar MPLABX-v6.25-linux-installer.sh xc8.run

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

# Set up macOS theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme
./install.sh -m -c dark -o normal -a all -t default -N glassy --round --shell -i apple -b default -p 45 -h default
sudo ./tweaks.sh -g -i apple -b default -p 45 -h default -sf -nd -nb
sudo ./tweaks.sh -o normal -c dark -t default -s standard -d
# Fix for Flatpak apps
sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
# Don't install "Dash to Dock" (https://extensions.gnome.org/extension/307/dash-to-dock/) b/c it has issue
# And turn off blur for Dock in "Blur my Shell" (https://extensions.gnome.org/extension/3193/blur-my-shell/) b/c it has issue too

git clone https://github.com/vinceliuice/WhiteSur-icon-theme --depth=1
cd WhiteSur-icon-theme
./install.sh -b
# Then use Gnome Tweaks to adjust the appearance settings

# To change the background of the login screen, use gdm-settings

# Set up Data center folder
mkdir ~/Documents/Data
# Set up Syncthing service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
systemctl --user status syncthing.service

# Cleanup
rm -rf ~/Downloads/*
cd ~

# Additional Steps

# Install Windows and run softwares with Bottles
# 1. PDFGear (https://downloadfiles.pdfgear.com/releases/windows/pdfgear_setup_v2.1.12.exe).
# 2. PICkit 3 (https://drive.google.com/file/d/1n2TvjxdgW9LkJmYouvCARYuZuhBnHlKp/view?usp=drive_link).
# 3. Proteus (https://drive.google.com/file/d/1n0qbE-ceSHu-XHStL0oTjrmgvbMjZymp/view?usp=drive_link).

echo "Setup complete! Restart your terminal."
