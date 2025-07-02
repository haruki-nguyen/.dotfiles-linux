#!/bin/bash
set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/wsl2-installer-$(date +%Y%m%d_%H%M%S).log"
readonly DOWNLOADS_DIR="$HOME/Downloads"
readonly EMAIL="nmd03pvt@gmail.com"
readonly GITHUB_USER="haruki-nguyen"
readonly DOTFILES_REPO="git@github.com:$GITHUB_USER/.dotfiles.git"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Package lists (CLI only, no GUI)
readonly APT_PACKAGES=(
    tmux zip nodejs npm python3-pip python3-venv ffmpeg
    llvm wget gpg unzip git btop curl stow zsh zoxide
    locales
)

# Logging functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}✗${NC} $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log_error "Error on line $1: Command '$2' failed with exit code $3"
    exit 1
}

trap 'error_exit ${LINENO} "$BASH_COMMAND" $?' ERR

# Utility functions
check_command() {
    command -v "$1" >/dev/null 2>&1
}

run_with_retry() {
    local max_attempts=3
    local attempt=1
    local delay=2
    
    while [ $attempt -le $max_attempts ]; do
        if "$@"; then
            return 0
        else
            log_warning "Command failed (attempt $attempt/$max_attempts): $*"
            if [ $attempt -lt $max_attempts ]; then
                sleep $delay
                delay=$((delay * 2))
            fi
            attempt=$((attempt + 1))
        fi
    done
    
    log_error "Command failed after $max_attempts attempts: $*"
    return 1
}

# System setup functions
setup_system_repositories() {
    log "Setting up system repositories..."
    sudo add-apt-repository -y universe
    run_with_retry sudo apt update
    log_success "System repositories configured"
}

update_system() {
    log "Updating system packages..."
    run_with_retry sudo apt upgrade -y
    log_success "System updated"
}

install_apt_packages() {
    log "Installing APT packages..."
    local batch_size=10
    local total=${#APT_PACKAGES[@]}
    local current=0
    for ((i=0; i<total; i+=batch_size)); do
        local batch=("${APT_PACKAGES[@]:i:batch_size}")
        current=$((current + ${#batch[@]}))
        log "Installing batch $((i/batch_size + 1)) ($current/$total packages)..."
        run_with_retry sudo apt install -y "${batch[@]}"
    done
    log_success "APT packages installed"
}

# Locale setup function
setup_locale() {
    log "Setting up locale configuration..."
    
    # Generate the en_US.UTF-8 locale
    if ! locale -a | grep -q "en_US.utf8"; then
        log "Generating en_US.UTF-8 locale..."
        run_with_retry sudo locale-gen en_US.UTF-8
        log_success "en_US.UTF-8 locale generated"
    else
        log "en_US.UTF-8 locale already exists"
    fi
    
    # Update locale configuration
    log "Updating locale configuration..."
    echo "LANG=en_US.UTF-8" | sudo tee /etc/default/locale > /dev/null
    echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/default/locale > /dev/null
    
    # Set environment variables for current session
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    
    log_success "Locale configuration completed"
}

# Dotfile conflict resolution function
resolve_dotfile_conflicts() {
    log "Resolving dotfile conflicts..."
    
    # Handle .zshrc conflicts
    if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
        log "Backing up existing .zshrc..."
        cp ~/.zshrc ~/.zshrc.backup
        log_success "Existing .zshrc backed up to ~/.zshrc.backup"
        
        log "Removing existing .zshrc to allow symlink creation..."
        rm ~/.zshrc
        log_success "Existing .zshrc removed"
    fi
    
    # Handle other common dotfile conflicts
    local dotfiles=(".bashrc" ".gitconfig" ".stylua.toml")
    for dotfile in "${dotfiles[@]}"; do
        if [ -f ~/"$dotfile" ] && [ ! -L ~/"$dotfile" ]; then
            log "Backing up existing $dotfile..."
            cp ~/"$dotfile" ~/"$dotfile.backup"
            log_success "Existing $dotfile backed up to ~/$dotfile.backup"
            
            log "Removing existing $dotfile to allow symlink creation..."
            rm ~/"$dotfile"
            log_success "Existing $dotfile removed"
        fi
    done
    
    log_success "Dotfile conflicts resolved"
}

# Application installation functions (CLI only)
setup_zsh() {
    log "Setting up ZSH and Oh My Zsh..."
    chsh -s "$(which zsh)" || log_warning "Failed to change default shell"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log "Oh My Zsh already installed"
    fi
}

setup_nvm_and_node() {
    log "Installing NVM (Node Version Manager)..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        log_success "NVM installed"
    else
        log "NVM already installed"
    fi
    # Load nvm for this script session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    # Install and use Node.js 20 (latest LTS as of 2024)
    if ! nvm ls 20 &>/dev/null; then
        log "Installing Node.js v20..."
        nvm install 20
        log_success "Node.js v20 installed"
    else
        log "Node.js v20 already installed"
    fi
    nvm use 20
    nvm alias default 20
    log_success "Node.js v20 set as default"
}

setup_github_ssh() {
    log "Setting up GitHub SSH..."
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N ""
        log_success "SSH key generated"
    else
        log "SSH key already exists"
    fi
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    if check_command xclip; then
        xclip -sel clip < ~/.ssh/id_ed25519.pub
        log "SSH public key copied to clipboard"
    fi
    echo -e "${YELLOW}Add your SSH key to GitHub: https://github.com/settings/keys${NC}"
}

setup_dotfiles() {
    log "Setting up dotfiles..."
    if [ ! -d ~/.dotfiles ]; then
        git clone "$DOTFILES_REPO" ~/.dotfiles || log_warning "Failed to clone dotfiles"
    else
        log "Dotfiles repository already exists"
    fi
    
    # Ensure the repository uses SSH URL
    if [ -d ~/.dotfiles ]; then
        cd ~/.dotfiles
        local current_url=$(git remote get-url origin 2>/dev/null || echo "")
        if [ "$current_url" != "$DOTFILES_REPO" ]; then
            log "Updating dotfiles repository URL to SSH format..."
            git remote set-url origin "$DOTFILES_REPO"
            log_success "Repository URL updated to SSH format"
        else
            log "Repository already using SSH URL"
        fi
        cd ~
    fi
    
    # Resolve conflicts before stowing
    resolve_dotfile_conflicts
    
    if [ -d ~/.dotfiles ]; then
        cd ~/.dotfiles && stow . && cd ~
        log_success "Dotfiles configured"
    fi
}

setup_tmux() {
    log "Setting up Tmux Plugin Manager..."
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$tpm_dir" ]; then
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log_success "Tmux Plugin Manager installed"
    else
        log "Tmux Plugin Manager already installed"
    fi
    if [ -f ~/.config/tmux/tmux.conf ]; then
        tmux source ~/.config/tmux/tmux.conf || true
    fi
    echo -e "${YELLOW}Press <prefix> + I to install Tmux plugins${NC}"
}

create_directories() {
    log "Creating application directories..."
    mkdir -p ~/Applications
    log_success "Directories created"
}

cleanup() {
    log "Cleaning up temporary files..."
    rm -rf "$DOWNLOADS_DIR"/*
    log_success "Cleanup complete"
}

# Main execution
main() {
    echo -e "${BLUE}WSL2 Web Dev Environment Installer${NC}"
    echo -e "${BLUE}Log file: $LOG_FILE${NC}"
    echo
    cd "$DOWNLOADS_DIR"
    setup_system_repositories
    update_system
    install_apt_packages
    setup_locale
    setup_zsh
    setup_nvm_and_node
    setup_github_ssh
    setup_dotfiles
    setup_tmux
    create_directories
    # Create Projects directory after all installations
    log "Creating Projects directory..."
    mkdir -p ~/Projects
    log_success "Projects directory created"
    cleanup
    echo
    log_success "WSL2 environment setup complete!"
    echo -e "${GREEN}Please restart your terminal to apply all changes.${NC}"
    echo -e "${YELLOW}Don't forget to add your SSH key to GitHub if you haven't already.${NC}"
    echo -e "${YELLOW}Note: Any existing dotfiles have been backed up with .backup extension.${NC}"
}

main "$@" 