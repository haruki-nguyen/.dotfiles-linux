# Function for pull updates from git repositories
project_paths=(/home/haruki/.dotfiles)

function git_pull_all () {
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

# Check if the OS is Ubuntu or Arch Linux
if type "pacman" >/dev/null 2>&1; then
  function new-date() {
    echo "Updating system with yay..."
    yay -Syu --noconfirm

    echo "Removing unused packages..."
    yay -Yc --noconfirm

    echo "System update and cleanup complete!"

    echo "Updating packages of npm..."
    sudo npm update -g
    echo "Updating packages of pnpm..."
    pnpm update -g

    echo "Pulling updates from the repositories"
    git_pull_all
    echo "Done!"
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

    echo "Pulling updates from the repositories"
    git_pull_all
    echo "Done!"
  }
else
  echo "Unknown OS"
fi
