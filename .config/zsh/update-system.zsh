#!/bin/zsh
# Enable strict mode for scripts, not interactive shells

echo "Script started - debugging enabled"

# Function for pulling updates from git repositories
project_paths=("/home/haruki/.dotfiles" "/home/haruki/Projects/focused-life")

git_pull_all() {
  echo "Starting git_pull_all function"
  for i in "${project_paths[@]}"; do
    echo "Going to $i"
    cd "$i" || { echo "Failed to enter $i"; continue; }
    echo "Pulling..."
    git pull || echo "Git pull failed in $i"
    echo "Done!"
    cd - >/dev/null
  done
  echo "git_pull_all function completed"
}

clean_env() {
  echo "Starting clean_env function"
  echo "Cleaning environment..."

  # Clean pip cache
  echo "Cleaning pip cache..."
  pip3 cache purge || true

  # Clean npm cache
  echo "Cleaning npm cache..."
  npm cache clean --force || true

  # Clean journal logs if using systemd
  echo "Cleaning journal logs..."
  sudo journalctl --vacuum-time=7d || true

  # Remove old snaps
  echo "Checking for old snaps..."
  if command -v snap &>/dev/null; then
    snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
      sudo snap remove "$snapname" --revision="$revision"
    done
  fi

  # Clean Flatpak
  echo "Cleaning Flatpak..."
  flatpak uninstall --unused -y || true

  echo "Environment cleaned!"
  echo "clean_env function completed"
}

update_system() {
  echo "Starting update_system function"
  echo "Starting system update..."

  if command -v yay &>/dev/null; then
    echo "Updating with yay..."
    yay -Syu --noconfirm || { echo "yay update failed"; return 1; }
    yay -Yc --noconfirm || echo "yay cleanup failed"
  elif command -v apt &>/dev/null || command -v apt-get &>/dev/null; then
    echo "Updating with apt..."
    echo "Running apt update..."
    sudo apt update || { echo "apt update failed - some repositories may be broken"; }
    echo "Running apt upgrade..."
    sudo apt upgrade -y || { echo "apt upgrade failed"; return 1; }
    echo "Running apt autoremove..."
    sudo apt autoremove -y || echo "apt autoremove failed"
  elif command -v dnf &>/dev/null; then
    echo "Updating with dnf..."
    sudo dnf update -y || { echo "dnf update failed"; return 1; }
    sudo dnf autoremove -y || echo "dnf autoremove failed"
  else
    echo "Unknown OS"; return 1
  fi

  echo "Updating global npm packages..."
  sudo npm update -g || echo "npm update failed"

  echo "Pulling Git repositories..."
  git_pull_all

  clean_env

  echo "System fully updated and cleaned!"
  echo "update_system function completed"
}

echo "Script loaded successfully - functions available: update_system, git_pull_all, clean_env"
