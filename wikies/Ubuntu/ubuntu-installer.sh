#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Add Neovim PPA for the latest version
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update

# Install necessary packages
sudo apt install -y neovim tmux zip ripgrep nodejs npm poppler-utils gdb ranger cargo

# Install gitui
cargo install gitui --locked

# Install cz-git and commitizen
npm i -g cz-git commitizen

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install gitleaks
GITLEAKS_VERSION="vx.xx.x"
wget https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
tar -xvzf gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
sudo mv gitleaks /usr/local/bin/
rm gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz

# Install a Nerd font (optional, manual step)
echo "Please install a Nerd font from https://www.nerdfonts.com/font-downloads and set it as the default font for your terminal."

# Set up GitHub SSH
EMAIL="nmd03pvt@gmail.com"
echo "Setting up GitHub SSH..."
ssh-keygen -t ed25519 -C ${EMAIL}
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "Please add the SSH key to your GitHub account: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux"
echo "Please update the remote URL to SSH: \`git remote set-url origin <URL>\`."

# Clone the dotfiles repository
git clone git@github.com:haruki-nguyen/.dotfiles.git ~/.dotfiles

# Set up Git configuration
ln -s ~/.dotfiles/configs/common-softwares/git/.gitconfig ~/

# Set up Bash configuration
echo -e "\nsource ~/.dotfiles/configs/linux-softwares/bash/bashrc_custom.sh" >> ~/.bashrc
source ~/.bashrc

# Set up Neovim (NvChad)
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
# Run `:MasonInstallAll` and `:Lazy sync` manually, then delete the .git folder
rm -rf ~/.config/nvim/.git

# Set up Tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config/tmux
ln -s ~/.dotfiles/configs/linux-softwares/tmux/tmux.conf ~/.config/tmux/tmux.conf
tmux source ~/.config/tmux/tmux.conf
echo "Please install Tmux plugins with <prefix> + I"

# Set up Starship
ln -s ~/.dotfiles/configs/linux-softwares/starship/starship.toml ~/.config/

# Set up GitUI
ln -s ~/.dotfiles/configs/linux-softwares/gitui/ ~/.config/

# Set up cz-git
ln -s ~/.dotfiles/configs/common-softwares/cz-git/.czrc ~/
#
# Set up NvChad
echo "Setting up NvChad..."
ln -s ~/.dotfiles/configs/common-softwares/nvim ~/.config/nvim
echo "Finish setting up NvChad"

echo "Setup complete! Please restart your terminal and WSL environment."
