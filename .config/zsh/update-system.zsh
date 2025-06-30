#!/bin/zsh
# System Update Script
# A comprehensive system update and maintenance script for Linux systems
# Supports apt, dnf, and yay package managers

# Configuration
typeset -A CONFIG=(
  # Project paths to update via git
  project_paths "/home/haruki/.dotfiles-linux /home/haruki/Projects/focused-life"
  
  # Logging
  log_level "INFO"  # DEBUG, INFO, WARN, ERROR
  
  # Package manager preferences (order matters)
  package_managers "yay apt dnf"
  
  # Cleanup settings
  journal_retention_days 7
  snap_cleanup_enabled true
  flatpak_cleanup_enabled true
  npm_cleanup_enabled true
  pip_cleanup_enabled true
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
  # More robust command checking
  if (( $+commands[$1] )); then
    return 0
  elif command -v "$1" >/dev/null 2>&1; then
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

# Git repository management
git_pull_all() {
  if ! command_exists git; then
    log ERROR "git is not installed, skipping repository updates"
    return 1
  fi
  log INFO "Starting Git repository updates"
  local success_count=0
  local total_count=0
  
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
    
    # Use subshell to isolate git operations from current shell environment and suppress all errors
    if (
      cd "$path" 2>/dev/null && \
      git pull --quiet 2>/dev/null
    ) 2>/dev/null; then
      log INFO "✓ Successfully updated: $path"
      ((success_count++))
    else
      log WARN "✗ Failed to update: $path"
    fi
  done
  
  log INFO "Git updates completed: $success_count/$total_count repositories updated"
  return $((success_count == total_count ? 0 : 1))
}

# Environment cleanup
clean_env() {
  log INFO "Starting environment cleanup"
  
  # Clean pip cache
  if [[ "$CONFIG[pip_cleanup_enabled]" == "true" ]] && command_exists pip3; then
    log INFO "Cleaning pip cache"
    pip3 cache purge 2>/dev/null || log WARN "Failed to clean pip cache"
  fi
  
  # Clean npm cache
  if [[ "$CONFIG[npm_cleanup_enabled]" == "true" ]] && command_exists npm; then
    log INFO "Cleaning npm cache"
    npm cache clean --force 2>/dev/null || log WARN "Failed to clean npm cache"
  fi
  
  # Clean journal logs
  if command_exists journalctl; then
    log INFO "Cleaning journal logs (keeping last ${CONFIG[journal_retention_days]} days)"
    sudo journalctl --vacuum-time="${CONFIG[journal_retention_days]}d" 2>/dev/null || log WARN "Failed to clean journal logs"
  fi
  
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
  
  log INFO "Environment cleanup completed"
}

# Package manager specific update functions
update_with_yay() {
  log INFO "Updating system with yay"
  yay -Syu --noconfirm || return 1
  yay -Yc --noconfirm || log WARN "yay cleanup failed"
  return 0
}

update_with_apt() {
  log INFO "Updating system with apt"
  
  # Update package lists
  log INFO "Updating package lists"
  sudo apt update || log WARN "apt update failed - some repositories may be broken"
  
  # Upgrade packages
  log INFO "Upgrading packages"
  sudo apt upgrade -y || return 1
  
  # Clean up
  log INFO "Removing unused packages"
  sudo apt autoremove -y || log WARN "apt autoremove failed"
  
  return 0
}

update_with_dnf() {
  log INFO "Updating system with dnf"
  sudo dnf update -y || return 1
  sudo dnf autoremove -y || log WARN "dnf autoremove failed"
  return 0
}

# Update global npm packages
update_npm_packages() {
  if command_exists npm; then
    log INFO "Updating global npm packages"
    sudo npm update -g 2>/dev/null || log WARN "Failed to update npm packages"
  else
    log INFO "npm not found, skipping npm updates"
  fi
}

# Main update function
update_system() {
  log INFO "Starting system update process"
  
  # Check if not running as root
  check_root || log WARN "Continuing despite root user"
  
  # Detect and use appropriate package manager
  local package_manager=$(detect_package_manager)
  if [[ -z "$package_manager" ]]; then
    error_exit "No supported package manager found (yay, apt, dnf)"
    return 1
  fi
  
  log INFO "Using package manager: $package_manager"
  
  # Update system packages
  case "$package_manager" in
    yay) update_with_yay || error_exit "yay update failed" ;;
    apt) update_with_apt || error_exit "apt update failed" ;;
    dnf) update_with_dnf || error_exit "dnf update failed" ;;
    *)   error_exit "Unsupported package manager: $package_manager" ;;
  esac
  
  # Update global npm packages
  update_npm_packages
  
  # Update Git repositories
  git_pull_all
  
  # Clean environment
  clean_env
  
  log INFO "System update completed successfully"
  return 0
}

# Show available functions when script is sourced
if [[ "${ZSH_EVAL_CONTEXT:-}" == "toplevel" ]]; then
  log INFO "System update script loaded"
  log INFO "Available functions: update_system, git_pull_all, clean_env"
  log INFO "Run 'update_system' to start the update process"
fi

# Fallback logging if main logging fails
simple_log() {
  local level="$1"
  shift
  local message="$*"
  echo "[$level] $message"
}
