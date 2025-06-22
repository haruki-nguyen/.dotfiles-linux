#!/bin/bash

# Waybar Setup Script
# This script automates the installation and configuration of Waybar
# to replace AGS sidebar functionality

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if user is root
if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root. Please run as a regular user."
    exit 1
fi

echo -e "${BLUE}Waybar Setup Script${NC}"
echo "This script will install and configure Waybar to replace AGS sidebar functionality"
echo

# Update packages
log "Updating package list..."
sudo apt update

# Install Waybar and dependencies
log "Installing Waybar and dependencies..."
sudo apt install -y waybar rofi wofi dmenu swww feh nitrogen

# Create Waybar configuration directory
log "Creating Waybar configuration..."
mkdir -p ~/.config/waybar/scripts

# Copy configuration files from dotfiles
if [[ -f ~/.dotfiles/.config/waybar/config.jsonc ]]; then
    cp ~/.dotfiles/.config/waybar/config.jsonc ~/.config/waybar/
    success "Copied Waybar config"
else
    error "Waybar config not found in dotfiles"
    exit 1
fi

if [[ -f ~/.dotfiles/.config/waybar/style.css ]]; then
    cp ~/.dotfiles/.config/waybar/style.css ~/.config/waybar/
    success "Copied Waybar style"
else
    error "Waybar style not found in dotfiles"
    exit 1
fi

# Copy scripts
if [[ -d ~/.dotfiles/.config/waybar/scripts ]]; then
    cp ~/.dotfiles/.config/waybar/scripts/*.sh ~/.config/waybar/scripts/
    chmod +x ~/.config/waybar/scripts/*.sh
    success "Copied and made scripts executable"
else
    error "Waybar scripts not found in dotfiles"
    exit 1
fi

# Update Hyprland configuration
log "Updating Hyprland configuration..."
if [[ -f ~/.config/hypr/hyprland.conf ]]; then
    # Replace AGS with Waybar in exec-once
    sed -i 's/exec-once = ~\/.config\/hypr\/scripts\/wallpaperdaemon.sh && ags run/exec-once = ~\/.config\/hypr\/scripts\/wallpaperdaemon.sh\nexec-once = waybar/' ~/.config/hypr/hyprland.conf
    success "Updated hyprland.conf"
else
    warning "Hyprland config not found"
fi

if [[ -f ~/.config/hypr/keybindings.conf ]]; then
    # Replace AGS sidebar keybindings with Waybar keybindings
    sed -i 's/bind = \$mod, Tab, exec, ags request sidebar:toggle:home/bind = \$mod, Tab, exec, ~\/.config\/waybar\/scripts\/sidebar-toggle.sh/' ~/.config/hypr/keybindings.conf
    sed -i 's/bind = \$mod, A, exec, ags request sidebar:toggle:appLauncher/bind = \$mod, A, exec, ~\/.config\/waybar\/scripts\/app-launcher.sh click/' ~/.config/hypr/keybindings.conf
    sed -i 's/bind = \$mod, C, exec, ags request sidebar:toggle:wallpapers/bind = \$mod, C, exec, ~\/.config\/waybar\/scripts\/wallpapers.sh click/' ~/.config/hypr/keybindings.conf
    success "Updated keybindings.conf"
else
    warning "Keybindings config not found"
fi

# Clean up AGS AstalTray references
log "Cleaning up AGS AstalTray references..."
if [[ -d ~/.config/ags ]]; then
    find ~/.config/ags -name "*.tsx" -o -name "*.ts" -o -name "yume" | while read -r file; do
        if [[ -f "$file" ]]; then
            sed -i '/AstalTray/d; /AstalBattery/d' "$file" 2>/dev/null || true
        fi
    done
    success "Cleaned up AGS AstalTray references"
else
    warning "AGS config directory not found"
fi

# Test Waybar configuration
log "Testing Waybar configuration..."
if ~/.config/waybar/scripts/sidebar.sh >/dev/null 2>&1; then
    success "Waybar configuration test passed"
else
    error "Waybar configuration test failed"
fi

echo
success "🎉 Waybar setup finished successfully!"
echo
echo "Next steps:"
echo "1. Restart Hyprland: systemctl --user restart hyprland"
echo "2. Or log out and log back in"
echo "3. Test the sidebar: Super + Tab, Super + A, Super + C"
echo
echo "Your sidebar functionality has been migrated from AGS to Waybar!" 