#!/bin/zsh
# Enable strict mode for scripts, not interactive shells
[[ $- != *i* ]] && set -euo pipefail

# Function for pulling updates from git repositories
project_paths=("/home/haruki/.dotfiles", "/home/haruki/Projects/focused-life")

git_pull_all() {
  for i in "${project_paths[@]}"; do
    echo "Going to $i"
    cd "$i" || { echo "Failed to enter $i"; continue; }
    echo "Pulling..."
    git pull || echo "Git pull failed in $i"
    echo "Done!"
    cd - >/dev/null
  done
}

clean_env() {
  echo "Cleaning environment..."

  # Clean pip cache
  pip3 cache purge || true

  # Clean npm cache
  npm cache clean --force || true

  # Clean journal logs if using systemd
  sudo journalctl --vacuum-time=7d || true

  # Remove old snaps
  if command -v snap &>/dev/null; then
    snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
      sudo snap remove "$snapname" --revision="$revision"
    done
  fi

  # Clean Flatpak
  flatpak uninstall --unused -y || true

  echo "Environment cleaned!"
}

update_system() {
  echo "Starting system update..."

  if command -v yay &>/dev/null; then
    echo "Updating with yay..."
    yay -Syu --noconfirm || { echo "yay update failed"; exit 1; }
    yay -Yc --noconfirm || echo "yay cleanup failed"
  elif command -v apt &>/dev/null || command -v apt-get &>/dev/null; then
    echo "Updating with apt..."
    sudo apt update && sudo apt upgrade -y || { echo "apt update/upgrade failed"; exit 1; }
    sudo apt autoremove -y || echo "apt autoremove failed"
  elif command -v dnf &>/dev/null; then
    echo "Updating with dnf..."
    sudo dnf update -y || { echo "dnf update failed"; exit 1; }
    sudo dnf autoremove -y || echo "dnf autoremove failed"
  else
    echo "Unknown OS"; exit 1
  fi

  echo "Updating global npm packages..."
  sudo npm update -g || echo "npm update failed"

  echo "Pulling Git repositories..."
  git_pull_all

  clean_env

  echo "System fully updated and cleaned!"
}
