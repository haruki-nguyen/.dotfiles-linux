#!/bin/zsh
# Prevent sourcing: only allow running as a script
if [[ "${ZSH_EVAL_CONTEXT:-}" != "toplevel" ]]; then
  echo "[ERROR] This script should not be sourced. Please run it as a standalone script (e.g., zsh update-system.zsh)."
  return 1
fi
# Nix-like System Update Script for WSL2 Environment
# A comprehensive system update and maintenance script that mimics Nix package manager behavior
# Specifically designed for packages installed by WSL2-installer.sh

# Configuration
typeset -A CONFIG=(
  # Project paths to update via git
  project_paths "/home/haruki/.dotfiles-linux /home/haruki/Projects/FocusedLife"
  
  # Logging
  log_level "INFO"  # DEBUG, INFO, WARN, ERROR
  
  # Package manager preferences (order matters)
  package_managers "apt"
  
  # WSL2-installer specific packages (from the installer script)
  wsl2_packages "tmux zip nodejs npm python3-pip python3-venv ffmpeg llvm wget gpg unzip git btop curl stow zsh zoxide locales"
  
  # Cleanup settings - more aggressive for Nix-like experience
  journal_retention_days 3
  snap_cleanup_enabled true
  flatpak_cleanup_enabled true
  npm_cleanup_enabled true
  pip_cleanup_enabled true
  apt_cache_cleanup_enabled true
  temp_cleanup_enabled true
  log_cleanup_enabled true
  docker_cleanup_enabled true
  
  # Nix-like isolation settings
  isolate_packages true
  track_dependencies true
  cleanup_orphans true
  remove_unused_configs true
)

# Colors for output
typeset -A COLORS=(
  reset "\033[0m"
  red "\033[31m"
  green "\033[32m"
  yellow "\033[33m"
  blue "\033[34m"
  magenta "\033[35m"
  cyan "\033[36m"
  bold "\033[1m"
  dim "\033[2m"
)

# Logging functions
log() {
  local level="$1"
  shift
  local message="$*"
  local timestamp
  
  # Use /bin/date if available for robust timestamp
  if [ -x /bin/date ]; then
    timestamp=$(/bin/date '+%Y-%m-%d %H:%M:%S')
  else
    timestamp="unknown"
  fi
  
  case "$level" in
    DEBUG) [[ "$CONFIG[log_level]" == "DEBUG" ]] && echo "${COLORS[cyan]}[DEBUG]${COLORS[reset]} $timestamp: $message" ;;
    INFO)  echo "${COLORS[green]}[INFO]${COLORS[reset]} $timestamp: $message" ;;
    WARN)  echo "${COLORS[yellow]}[WARN]${COLORS[reset]} $timestamp: $message" ;;
    ERROR) echo "${COLORS[red]}[ERROR]${COLORS[reset]} $timestamp: $message" >&2 ;;
  esac
}

# Error handling
error_exit() {
  log ERROR "$1"
  return 1
}

# Command validation
command_exists() {
  local cmd="$1"
  local original_pwd="$PWD"
  local original_path="$PATH"
  
  # Ensure we're in a safe directory and have the full PATH
  cd /tmp 2>/dev/null || cd / 2>/dev/null || true
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$original_path"
  
  # Debug output for command_exists
  echo "[DEBUG] Checking command: $cmd, PATH: $PATH" >&2
  local cmd_path
  cmd_path=$(command -v "$cmd" 2>/dev/null)
  echo "[DEBUG] command -v $cmd: $cmd_path" >&2
  
  # Restore original directory and PATH
  cd "$original_pwd" 2>/dev/null || true
  export PATH="$original_path"
  
  if (( $+commands[$cmd] )); then
    return 0
  elif [[ -n "$cmd_path" ]]; then
    return 0
  else
    return 1
  fi
}

# Check if running as root
check_root() {
  if [[ $EUID -eq 0 ]]; then
    log WARN "This script should not be run as root"
    return 1
  fi
}

# Detect package manager
detect_package_manager() {
  for pm in ${=CONFIG[package_managers]}; do
    if command_exists "$pm"; then
      echo "$pm"
      return 0
    fi
  done
  return 1
}

# Nix-like package tracking
track_installed_packages() {
  log INFO "Tracking installed packages for Nix-like management"
  
  # Create package tracking directory
  local track_dir="$HOME/.local/share/package-tracker"
  mkdir -p "$track_dir"
  
  # Track currently installed packages
  if command_exists dpkg; then
    dpkg --get-selections | grep -v deinstall > "$track_dir/current-packages.txt"
    log INFO "Package list saved to $track_dir/current-packages.txt"
  fi
  
  # Track manually installed packages (excluding dependencies)
  if command_exists apt-mark; then
    apt-mark showmanual > "$track_dir/manual-packages.txt" 2>/dev/null || log WARN "Could not track manual packages"
  fi
}

# Find orphaned packages (Nix-like cleanup)
find_orphaned_packages() {
  local original_pwd="$PWD"
  local original_path="$PATH"
  
  # Ensure we're in a safe directory and have the full PATH
  cd "$HOME" 2>/dev/null || cd / 2>/dev/null || true
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$original_path"
  
  log INFO "Finding orphaned packages for removal"
  
  if ! command_exists apt; then
    log WARN "apt not available, skipping orphan detection"
    cd "$original_pwd" 2>/dev/null || true
    export PATH="$original_path"
    return 0
  fi
  
  # Find packages that are no longer needed
  local orphans=$(/usr/bin/apt-mark showauto | xargs /usr/bin/apt-mark showmanual 2>/dev/null | /usr/bin/grep -v "^$" || true)
  
  if [[ -n "$orphans" ]]; then
    log INFO "Found potentially orphaned packages:"
    echo "$orphans" | while read -r pkg; do
      if [[ -n "$pkg" ]]; then
        log INFO "  - $pkg"
      fi
    done
    
    # Ask user if they want to remove orphans
    echo -n "${COLORS[yellow]}Remove orphaned packages? (y/N): ${COLORS[reset]}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      log INFO "Removing orphaned packages..."
      echo "$orphans" | sudo xargs apt remove -y 2>/dev/null || log WARN "Failed to remove some orphaned packages"
    fi
  else
    log INFO "No orphaned packages found"
  fi
}

# Comprehensive cache cleanup (Nix-like)
clean_all_caches() {
  log INFO "Performing comprehensive cache cleanup"
  
  # APT cache cleanup
  if [[ "$CONFIG[apt_cache_cleanup_enabled]" == "true" ]] && command_exists apt; then
    log INFO "Cleaning APT cache"
    sudo apt clean 2>/dev/null || log WARN "Failed to clean APT cache"
    sudo apt autoclean 2>/dev/null || log WARN "Failed to autoclean APT cache"
  fi
  
  # Pip cache cleanup
  if [[ "$CONFIG[pip_cleanup_enabled]" == "true" ]] && command_exists pip3; then
    log INFO "Cleaning pip cache"
    pip3 cache purge 2>/dev/null || log WARN "Failed to clean pip cache"
  fi
  
  # NPM cache cleanup
  if [[ "$CONFIG[npm_cleanup_enabled]" == "true" ]] && command_exists npm; then
    log INFO "Cleaning npm cache"
    npm cache clean --force 2>/dev/null || log WARN "Failed to clean npm cache"
  fi
  
  # Node modules cleanup (remove unused global packages)
  if command_exists npm; then
    log INFO "Cleaning unused global npm packages"
    npm list -g --depth=0 2>/dev/null | grep -E "^(├|└)── " | cut -d' ' -f2 | grep -v npm | xargs -r npm uninstall -g 2>/dev/null || true
  fi
  
  # Python virtual environments cleanup
  if command_exists python3 && [[ -d ~/.virtualenvs ]]; then
    log INFO "Cleaning unused Python virtual environments"
    find ~/.virtualenvs -maxdepth 1 -type d -name "venv*" -mtime +30 -exec rm -rf {} + 2>/dev/null || true
  fi
}

# Temporary files cleanup
clean_temp_files() {
  if [[ "$CONFIG[temp_cleanup_enabled]" == "true" ]]; then
    log INFO "Cleaning temporary files"
    
    # Clean system temp
    if [[ -d /tmp ]]; then
      sudo find /tmp -type f -atime +7 -delete 2>/dev/null || true
    fi
    if [[ -d /var/tmp ]]; then
      sudo find /var/tmp -type f -atime +7 -delete 2>/dev/null || true
    fi
    
    # Clean user temp
    if [[ -d ~/.cache ]]; then
      find ~/.cache -type f -atime +7 -delete 2>/dev/null || true
    fi
    if [[ -d ~/.local/share/Trash ]]; then
      find ~/.local/share/Trash -type f -atime +30 -delete 2>/dev/null || true
    fi
  fi
}

# Log cleanup
clean_logs() {
  if [[ "$CONFIG[log_cleanup_enabled]" == "true" ]]; then
    log INFO "Cleaning old log files"
    
    # Clean journal logs
    if command_exists journalctl; then
      log INFO "Cleaning journal logs (keeping last ${CONFIG[journal_retention_days]} days)"
      sudo journalctl --vacuum-time="${CONFIG[journal_retention_days]}d" 2>/dev/null || true
    fi
    
    # Clean old log files
    if [[ -d /var/log ]]; then
      sudo find /var/log -name "*.log" -type f -mtime +7 -delete 2>/dev/null || true
      sudo find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null || true
    fi
  fi
}

# Docker cleanup
clean_docker() {
  if [[ "$CONFIG[docker_cleanup_enabled]" == "true" ]] && command_exists docker; then
    log INFO "Cleaning Docker resources"
    
    # Remove unused containers
    docker container prune -f 2>/dev/null || log WARN "Failed to clean Docker containers"
    
    # Remove unused images
    docker image prune -f 2>/dev/null || log WARN "Failed to clean Docker images"
    
    # Remove unused volumes
    docker volume prune -f 2>/dev/null || log WARN "Failed to clean Docker volumes"
    
    # Remove unused networks
    docker network prune -f 2>/dev/null || log WARN "Failed to clean Docker networks"
  fi
}

# Remove unused configurations (Nix-like)
clean_unused_configs() {
  if [[ "$CONFIG[remove_unused_configs]" == "true" ]]; then
    log INFO "Cleaning unused configuration files"
    
    # Find and remove empty config directories
    if [[ -d ~/.config ]]; then
      find ~/.config -type d -empty -delete 2>/dev/null || true
    fi
    
    # Remove backup files
    find ~ -name "*.backup" -type f -mtime +30 -delete 2>/dev/null || true
    find ~ -name "*.old" -type f -mtime +30 -delete 2>/dev/null || true
  fi
}

# Git repository management
git_pull_all() {
  if ! command_exists git; then
    log ERROR "git is not installed, skipping repository updates"
    return 1
  fi
  log INFO "Starting Git repository updates"
  local success_count=0
  local total_count=0
  local original_dir="$PWD"
  
  for path in ${=CONFIG[project_paths]}; do
    ((total_count++))
    log INFO "Updating repository: $path"
    
    if [[ ! -d "$path" ]]; then
      log WARN "Directory does not exist: $path"
      continue
    fi
    
    if [[ ! -d "$path/.git" ]]; then
      log WARN "Not a git repository: $path"
      continue
    fi
    
    if cd "$path"; then
      SSH_AUTH_SOCK="$SSH_AUTH_SOCK" SSH_AGENT_PID="$SSH_AGENT_PID" /usr/bin/git fetch --quiet 2>git_error.log
      local fetch_status=$?
      if [[ $fetch_status -eq 0 ]]; then
        SSH_AUTH_SOCK="$SSH_AUTH_SOCK" SSH_AGENT_PID="$SSH_AGENT_PID" /usr/bin/git pull --quiet 2>>git_error.log
        local pull_status=$?
        local git_status=$pull_status
      else
        local git_status=$fetch_status
      fi
    else
      local git_status=1
      echo "Failed to change directory to $path" > git_error.log
    fi
    if [[ $git_status -eq 0 ]]; then
      log INFO "✓ Successfully updated: $path"
      ((success_count++))
    else
      log WARN "✗ Failed to update: $path (exit code: $git_status)"
      if [[ -s "$path/git_error.log" ]]; then
        log WARN "Git error log for $path:"
        /bin/cat "$path/git_error.log" | while read -r line; do log WARN "$line"; done
        /bin/rm -f "$path/git_error.log"
      else
        log WARN "No git_error.log found for $path"
      fi
    fi
    cd "$original_dir"
  done
  
  log INFO "Git updates completed: $success_count/$total_count repositories updated"
  return $((success_count == total_count ? 0 : 1))
}

# Update WSL2-installer specific packages
update_wsl2_packages() {
  log INFO "Updating WSL2-installer specific packages"
  
  if ! command_exists apt; then
    log ERROR "apt not available, cannot update WSL2 packages"
    return 1
  fi
  
  # Update package lists
  log INFO "Updating package lists"
  sudo apt update || log WARN "apt update failed - some repositories may be broken"
  
  # Upgrade specific WSL2 packages
  local packages=(${=CONFIG[wsl2_packages]})
  log INFO "Upgrading WSL2 packages: ${packages[*]}"
  
  for pkg in "${packages[@]}"; do
    if dpkg -l | grep -q "^ii.*$pkg"; then
      log INFO "Upgrading $pkg"
      sudo apt install --only-upgrade -y "$pkg" 2>/dev/null || log WARN "Failed to upgrade $pkg"
    fi
  done
  
  # General system upgrade
  log INFO "Performing general system upgrade"
  sudo apt upgrade -y || log WARN "General upgrade failed"
  
  # Remove unused packages
  log INFO "Removing unused packages"
  sudo apt autoremove -y || log WARN "autoremove failed"
  
  return 0
}

# Update NVM and Node.js version 20
update_nvm_and_node() {
  log INFO "Updating NVM (Node Version Manager) and Node.js v20"
  if [ ! -d "$HOME/.nvm" ]; then
    log INFO "NVM not found, installing..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    log INFO "NVM installed"
  else
    log INFO "NVM already installed"
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  if ! nvm ls 20 &>/dev/null; then
    log INFO "Node.js v20 not found, installing..."
    nvm install 20
    log INFO "Node.js v20 installed"
  else
    log INFO "Node.js v20 already installed"
  fi
  nvm use 20
  nvm alias default 20
  log INFO "Node.js v20 set as default"
}

# Update global npm packages
update_npm_packages() {
  if ! command_exists npm; then
    log INFO "npm not found, skipping npm updates"
    return
  fi
  if ! command_exists jq; then
    log WARN "jq not found, skipping npm updates (required for parsing npm list output)"
    return
  fi
  log INFO "Updating global npm packages"
  
  # Get list of global packages
  local global_packages=$(npm list -g --depth=0 --json 2>/dev/null | jq -r '.dependencies | keys[]' 2>/dev/null || echo "")
  
  if [[ -n "$global_packages" ]]; then
    echo "$global_packages" | while read -r pkg; do
      if [[ -n "$pkg" && "$pkg" != "npm" ]]; then
        log INFO "Updating npm package: $pkg"
        sudo npm update -g "$pkg" 2>/dev/null || log WARN "Failed to update npm package: $pkg"
      fi
    done
  fi
}

# Update Python packages
update_python_packages() {
  if command_exists pip3; then
    log INFO "Updating global Python packages"
    
    # Get list of installed packages
    local packages=$(pip3 list --user --format=freeze | cut -d'=' -f1 2>/dev/null || echo "")
    
    if [[ -n "$packages" ]]; then
      echo "$packages" | while read -r pkg; do
        if [[ -n "$pkg" ]]; then
          log INFO "Updating Python package: $pkg"
          pip3 install --user --upgrade "$pkg" 2>/dev/null || log WARN "Failed to update Python package: $pkg"
        fi
      done
    fi
  else
    log INFO "pip3 not found, skipping Python updates"
  fi
}

# Update shell tools
update_shell_tools() {
  log INFO "Updating shell tools"
  
  # Update Oh My Zsh
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log INFO "Updating Oh My Zsh"
    (cd "$HOME/.oh-my-zsh" && git pull --quiet 2>/dev/null) || log WARN "Failed to update Oh My Zsh"
  fi
  
  # Update tmux plugins only if tmux is running and config exists
  if command_exists tmux && [[ -f "$HOME/.config/tmux/tmux.conf" ]]; then
    if tmux info &>/dev/null; then
      log INFO "Updating tmux plugins"
      tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || log WARN "Failed to source tmux config"
    else
      log INFO "tmux is not running; skipping tmux config reload"
    fi
  fi
}

# Comprehensive environment cleanup
clean_env() {
  log INFO "Starting comprehensive environment cleanup"
  
  # Clean all caches
  clean_all_caches
  
  # Clean temporary files
  clean_temp_files
  
  # Clean logs
  clean_logs
  
  # Clean Docker
  clean_docker
  
  # Clean unused configurations
  clean_unused_configs
  
  # Remove old snaps
  if [[ "$CONFIG[snap_cleanup_enabled]" == "true" ]] && command_exists snap; then
    log INFO "Cleaning old snap packages"
    snap list --all 2>/dev/null | awk '/disabled/{print $1, $3}' | while read -r snapname revision; do
      if [[ -n "$snapname" && -n "$revision" ]]; then
        sudo snap remove "$snapname" --revision="$revision" 2>/dev/null || log WARN "Failed to remove snap: $snapname"
      fi
    done
  fi
  
  # Clean Flatpak
  if [[ "$CONFIG[flatpak_cleanup_enabled]" == "true" ]] && command_exists flatpak; then
    log INFO "Cleaning unused Flatpak packages"
    flatpak uninstall --unused -y 2>/dev/null || log WARN "Failed to clean Flatpak packages"
  fi
  
  log INFO "Comprehensive environment cleanup completed"
}

# Main update function with Nix-like behavior
update_system() {
  log INFO "Starting Nix-like system update process"
  
  # Check if not running as root
  check_root || log WARN "Continuing despite root user"
  
  # Track packages before update
  track_installed_packages
  
  # Update WSL2-specific packages
  update_wsl2_packages
  
  # Update NVM and Node.js
  update_nvm_and_node
  
  # Update language-specific packages
  update_npm_packages
  update_python_packages
  
  # Update shell tools
  update_shell_tools
  
  # Update Git repositories
  git_pull_all
  
  # Find and optionally remove orphaned packages
  if [[ "$CONFIG[cleanup_orphans]" == "true" ]]; then
    find_orphaned_packages
  fi
  
  # Comprehensive cleanup
  clean_env
  
  log INFO "Nix-like system update completed successfully"
  log INFO "System is now clean and minimal, similar to Nix package manager"
  return 0
}

# Quick cleanup function
quick_cleanup() {
  log INFO "Performing quick cleanup"
  clean_all_caches
  clean_temp_files
  log INFO "Quick cleanup completed"
}

# Show system status
show_status() {
  log INFO "System Status Report"
  echo "===================="
  
  # Package counts
  if command_exists dpkg; then
    local total_packages=$(dpkg -l | grep -c "^ii" || echo "0")
    log INFO "Total installed packages: $total_packages"
  fi
  
  # Disk usage
  if command_exists df; then
    log INFO "Disk usage:"
    df -h ~ 2>/dev/null || log WARN "Could not get disk usage"
  fi
  
  # Memory usage
  if command_exists free; then
    log INFO "Memory usage:"
    free -h 2>/dev/null || log WARN "Could not get memory usage"
  fi
  
  # Cache sizes
  if [[ -d ~/.cache ]]; then
    local cache_size=$(du -sh ~/.cache 2>/dev/null | cut -f1 || echo "unknown")
    log INFO "Cache size: $cache_size"
  fi
}

# Automatically run update_system if script is executed directly
if [[ "${ZSH_EVAL_CONTEXT:-}" == "toplevel" ]]; then
  log INFO "Nix-like system update script loaded"
  log INFO "Starting update process..."
  update_system
fi

# Show available functions when script is sourced
if [[ "${ZSH_EVAL_CONTEXT:-}" == "toplevel" ]]; then
  log INFO "Nix-like system update script loaded"
  log INFO "Available functions:"
  log INFO "  - update_system: Full Nix-like update and cleanup"
  log INFO "  - quick_cleanup: Quick cache and temp cleanup"
  log INFO "  - show_status: Show system status"
  log INFO "  - clean_env: Comprehensive environment cleanup"
  log INFO "  - git_pull_all: Update git repositories"
  log INFO "Run 'update_system' to start the Nix-like update process"
fi

# Fallback logging if main logging fails
simple_log() {
  local level="$1"
  shift
  local message="$*"
  echo "[$level] $message"
}
