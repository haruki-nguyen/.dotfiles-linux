# Function for pull updates from git repositories
project_paths=(/home/haruki/.dotfiles)

git_pull_all () {
  for i in "${project_paths[@]}"; do
    echo "Going to $i"
    cd $i
    echo "Pulling..."
    git pull
    echo "Done!"
    echo "Going back..."
    cd -
  done
}

update_system() {
  # Check if the OS is Ubuntu or Arch Linux
  if type "pacman" >/dev/null 2>&1; then
    echo "Updating system with yay..."
    yay -Syu --noconfirm

    echo "Removing unused packages..."
    yay -Yc --noconfirm
  elif type "apt" >/dev/null 2>&1 || type "apt-get" >/dev/null 2>&1; then
    echo "Updating system with apt..."
    sudo apt update && sudo apt upgrade -y

    echo "Removing unused packages..."
    sudo apt autoremove -y
  elif type "dnf" >/dev/null 2>&1; then
    echo "Updating system with dnf..."
    sudo dnf update -y

    echo "Removing unused packages..."
    sudo dnf autoremove -y
  else
    echo "Unknown OS"
  fi

  echo "System update and cleanup complete!"

  echo "Updating packages of npm..."
  sudo npm update -g

  echo "Pulling updates from the repositories"
  git_pull_all
  echo "Done!"
}

