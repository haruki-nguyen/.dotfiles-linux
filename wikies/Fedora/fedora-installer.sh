#!/bin/bash

# Move to ~/Downloads/ to ensure consistency during installing process
cd ~/Downloads/

# Update the system
sudo dnf update -y || { echo "System update failed"; exit 1; }

# Install necessary packages
# `fuse` and `fuse-libs`: run `espanso` AppImage.
# `rofi`: program launcher replacement for the default `dmenu`.
# `lxappearance`: for modifying GTK themes.
# `gtk-murrine-engine`: GTK Gruvbox theme dependencies.
# `btop`: task manager.
# `flatpak`: use to install packages that are not available with dnf method
sudo dnf install -y neovim tmux zip ripgrep nodejs npm gdb python3 yt-dlp ffmpeg obs-studio openshot firefox gitleaks gh llvm fuse fuse-libs rofi lxappearance gtk-murrine-engine btop flatpak syncthing || { echo "Package installation failed"; exit 1; }

# Install ProtonVPN
echo "Installing ProtonVPN"
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.2-1.noarch.rpm" || { echo "Failed to install ProtonVPN"; exit 1; }
sudo dnf install ./protonvpn-stable-release-1.0.2-1.noarch.rpm || { echo "Failed to install the ProtonVPN repository package from the local RPM file"; exit 1; }
sudo dnf check-update --refresh
sudo dnf install proton-vpn-gnome-desktop || { echo "Failed to install ProtonVPN Gnome Desktop package"; exit 1; }
echo "Sucessfully install ProtonVPN"

# Install Obsidian
flatpak install flathub md.obsidian.Obsidian

# Install Espanso
# Create the $HOME/opt destination folder
mkdir -p ~/opt
# Download the AppImage inside it
wget -O ~/opt/Espanso.AppImage 'https://github.com/espanso/espanso/releases/download/v2.2.1/Espanso-X11.AppImage'
# Make it executable
chmod u+x ~/opt/Espanso.AppImage
# Create the "espanso" command alias
sudo ~/opt/Espanso.AppImage env-path register
# Register espanso as a systemd service (required only once)
espanso service register
# Start espanso
espanso start

# Install gitleaks
GITLEAKS_VERSION="8.23.3"
wget https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz || { echo "Gitleaks download failed"; exit 1; }
tar -xvzf gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz || { echo "Gitleaks extraction failed"; exit 1; }
sudo mv gitleaks /usr/local/bin/ || { echo "Gitleaks move failed"; exit 1; }
rm gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz

# Install Nerd font (optional, manual step)
echo "Installing JetBrainsMono Nerd font from https://www.nerdfonts.com/font-downloads"
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip" || { echo "Font download failed"; exit 1; }
mkdir -p ~/.local/share/fonts
unzip JetBrainsMono.zip -d ~/.local/share/fonts || { echo "Font extraction failed"; exit 1; }
fc-cache -fv
rm JetBrainsMono.zip
echo "JetBrainsMono Nerd font installed."

# Set up GitHub SSH
EMAIL="nmd03pvt@gmail.com"
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "SSH key already exists."
else
  echo "Setting up GitHub SSH..."
  ssh-keygen -t ed25519 -C ${EMAIL} || { echo "SSH key generation failed"; exit 1; }
fi
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "Please add the SSH key to your GitHub account: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux"

# Clone the dotfiles repository
git clone git@github.com:haruki-nguyen/.dotfiles.git ~/.dotfiles || { echo "Dotfiles clone failed"; exit 1; }

# Set up Tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || { echo "Tmux plugin manager clone failed"; exit 1; }
tmux source ~/.config/tmux/tmux.conf || { echo "Tmux source failed"; exit 1; }
echo "Please install Tmux plugins with <prefix> + I."

echo "Remove all clutter files and folders after installing process."
rm -rf ~/Downloads/*
echo "Moving to the home directory."
cd ~

echo "Setup complete! Please restart your terminal."

