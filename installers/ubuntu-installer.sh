#!/bin/bash
set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/ubuntu-installer-$(date +%Y%m%d_%H%M%S).log"
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

# Package lists
readonly APT_PACKAGES=(
    tmux zip ripgrep nodejs npm gdb python3-pip python3.12-venv ffmpeg obs-studio
    openshot-qt llvm build-essential wget gpg unzip git gh btop gthumb okular curl stow
    gdm-settings p7zip-full alacritty ibus-unikey keepassxc
    gnome-browser-connector gnome-tweaks gnome-shell-extension-manager zsh zoxide
)

readonly FLATPAK_APPS=(
    com.protonvpn.www
    md.obsidian.Obsidian
    io.github.realmazharhussain.GdmSettings
)

readonly SNAP_APPS=(
    "code --classic"
    "postman"
    "libreoffice"
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

download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    
    log "Downloading $description..."
    if wget -q --show-progress -O "$output" "$url"; then
        log_success "Downloaded $description"
    else
        log_error "Failed to download $description"
        return 1
    fi
}

# System setup functions
setup_system_repositories() {
    log "Setting up system repositories..."
    
    # Add universe repository
    sudo add-apt-repository -y universe
    
    # Update package lists
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
    
    # Install packages in batches to avoid command line length issues
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

setup_ibus() {
    log "Configuring IBus..."
    ibus restart || log_warning "IBus restart failed"
    
    if ! grep -q 'GTK_IM_MODULE=ibus' ~/.profile; then
        echo 'GTK_IM_MODULE=ibus' >> ~/.profile
        log_success "IBus configured"
    else
        log "IBus already configured"
    fi
}

# Application installation functions
install_chrome() {
    log "Installing Google Chrome..."
    
    local chrome_deb="google-chrome-stable_current_amd64.deb"
    local chrome_url="https://dl.google.com/linux/direct/$chrome_deb"
    
    download_file "$chrome_url" "$chrome_deb" "Google Chrome"
    run_with_retry sudo apt install -y "./$chrome_deb"
    rm -f "$chrome_deb"
    
    log_success "Google Chrome installed"
}

install_warp_terminal() {
    log "Installing Warp Terminal..."
    
    # Download and setup GPG key
    wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
    sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
    
    # Add repository
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
    
    # Cleanup and install
    rm -f warpdotdev.gpg
    run_with_retry sudo apt update
    run_with_retry sudo apt install -y warp-terminal
    
    log_success "Warp Terminal installed"
}

setup_zsh() {
    log "Setting up ZSH and Oh My Zsh..."
    
    # Change default shell
    chsh -s "$(which zsh)" || log_warning "Failed to change default shell"
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log "Oh My Zsh already installed"
    fi
}

install_ulauncher() {
    log "Installing Ulauncher..."
    
    sudo add-apt-repository -y ppa:agornostal/ulauncher
    run_with_retry sudo apt update
    run_with_retry sudo apt install -y ulauncher
    
    log_success "Ulauncher installed"
}

setup_flatpak() {
    log "Setting up Flatpak..."
    
    run_with_retry sudo apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Install Flatpak apps
    for app in "${FLATPAK_APPS[@]}"; do
        log "Installing Flatpak app: $app"
        flatpak install -y flathub "$app" || log_warning "Failed to install $app"
    done
    
    log_success "Flatpak setup complete"
}

install_snap_apps() {
    log "Installing Snap applications..."
    
    for app in "${SNAP_APPS[@]}"; do
        log "Installing Snap app: $app"
        sudo snap install $app || log_warning "Failed to install $app"
    done
    
    log_success "Snap applications installed"
}

install_rquickshare() {
    log "Installing RQuickShare..."
    
    local repo="Martichou/rquickshare"
    local latest
    local deb_file
    
    latest=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | jq -r .tag_name)
    deb_file="r-quick-share-main_${latest}_glibc-2.39_amd64.deb"
    
    download_file "https://github.com/$repo/releases/download/$latest/$deb_file" "$deb_file" "RQuickShare"
    run_with_retry sudo apt install -y "./$deb_file"
    rm -f "$deb_file"
    
    log_success "RQuickShare installed"
}

install_discord() {
    log "Installing Discord..."
    
    local discord_url="https://discord.com/api/download?platform=linux&format=deb"
    
    download_file "$discord_url" "discord.deb" "Discord"
    run_with_retry sudo apt install -y ./discord.deb
    rm -f discord.deb
    
    log_success "Discord installed"
}

install_nerd_fonts() {
    log "Installing Nerd Fonts..."
    
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
    local font_dir="$HOME/.local/share/fonts"
    
    download_file "$font_url" "JetBrainsMono.zip" "JetBrains Mono Nerd Font"
    
    mkdir -p "$font_dir"
    unzip -q JetBrainsMono.zip -d "$font_dir"
    fc-cache -fv
    rm -f JetBrainsMono.zip
    
    log_success "Nerd Fonts installed"
}

setup_github_ssh() {
    log "Setting up GitHub SSH..."
    
    # Generate SSH key if it doesn't exist
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N ""
        log_success "SSH key generated"
    else
        log "SSH key already exists"
    fi
    
    # Start ssh-agent and add key
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    
    # Copy public key to clipboard if xclip is available
    if check_command xclip; then
        xclip -sel clip < ~/.ssh/id_ed25519.pub
        log "SSH public key copied to clipboard"
    fi
    
    echo -e "${YELLOW}Add your SSH key to GitHub: https://github.com/settings/keys${NC}"
}

setup_dotfiles() {
    log "Setting up dotfiles..."
    
    # Clone dotfiles repository
    if [ ! -d ~/.dotfiles ]; then
        git clone "$DOTFILES_REPO" ~/.dotfiles || log_warning "Failed to clone dotfiles"
    fi
    
    # Backup existing bashrc
    if [ -f ~/.bashrc ] && [ ! -f ~/.bashrc.bak ]; then
        mv ~/.bashrc ~/.bashrc.bak
    fi
    
    # Stow dotfiles
    if [ -d ~/.dotfiles ]; then
        cd ~/.dotfiles && stow . && cd ~
        [ -f ~/.bashrc.bak ] && rm ~/.bashrc.bak
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
    
    # Source tmux config if it exists
    if [ -f ~/.config/tmux/tmux.conf ]; then
        tmux source ~/.config/tmux/tmux.conf || true
    fi
    
    echo -e "${YELLOW}Press <prefix> + I to install Tmux plugins${NC}"
}

setup_syncthing() {
    log "Setting up Syncthing..."
    
    mkdir -p ~/Documents/"My Data"
    
    # Enable and start Syncthing service
    systemctl --user enable syncthing.service || log_warning "Failed to enable Syncthing"
    systemctl --user start syncthing.service || log_warning "Failed to start Syncthing"
    
    log_success "Syncthing configured"
}

setup_alacritty() {
    log "Setting Alacritty as default terminal..."
    gsettings set org.gnome.desktop.default-applications.terminal exec alacritty
    log_success "Alacritty set as default terminal"
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
    echo -e "${BLUE}Ubuntu System Installer${NC}"
    echo -e "${BLUE}Log file: $LOG_FILE${NC}"
    echo
    
    # Change to downloads directory
    cd "$DOWNLOADS_DIR"
    
    # System setup
    setup_system_repositories
    update_system
    install_apt_packages
    setup_ibus
    setup_alacritty
    
    # Application installations
    install_chrome
    install_warp_terminal
    setup_zsh
    install_ulauncher
    setup_flatpak
    install_snap_apps
    install_rquickshare
    install_discord
    install_nerd_fonts
    
    # Development setup
    setup_github_ssh
    setup_dotfiles
    setup_tmux
    
    # Additional setup
    setup_syncthing
    create_directories
    cleanup
    
    echo
    log_success "Installation complete!"
    echo -e "${GREEN}Please restart your terminal to apply all changes.${NC}"
    echo -e "${YELLOW}Don't forget to add your SSH key to GitHub if you haven't already.${NC}"
}

# Run main function
main "$@"