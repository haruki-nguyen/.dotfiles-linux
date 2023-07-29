#!/bin/bash

# Check if the OS is Ubuntu or Arch Linux
if type "pacman" >/dev/null 2>&1; then
  function new-date() {
    echo "Updating system with pacman..."
    yay -Syu --noconfirm

    echo "Removing unused packages..."
    yay -Yc --noconfirm

    echo "System update and cleanup complete!"

    echo "Updating packages of npm..."
    sudo npm update -g
    echo "Updating packages of pnpm..."
    pnpm update -g
  }
elif type "apt" >/dev/null 2>&1 || type "apt-get" >/dev/null 2>&1; then
  function new-date() {
    echo "Updating system with apt..."
    sudo apt update && sudo apt upgrade -y

    echo "Removing unused packages..."
    sudo apt autoremove -y

    echo "System update and cleanup complete!"

    echo "Updating packages of npm..."
    # Not use `sudo npm` because we use `npm` installed by `nvm`
    npm update -g 

    echo "Updating packages of pnpm..."
    pnpm update -g
  }
else
  echo "Unknown OS"
fi

# Prompt theme
eval "$(starship init bash)"

# Z directory jumper
source ~/.dotfiles/configs/bash/z.sh

# Alias
alias gitui="gitui -t mocha.ron"

# Add PATH
export PATH="/home/haruki/.cargo/bin:$PATH"
