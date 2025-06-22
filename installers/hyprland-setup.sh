#!/bin/bash

# Hyprland Setup Script
# This script automates the complete setup of AGS, Astal, and yume configuration
# Includes all dependencies and configuration installation

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if user is root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root. Please run as a regular user."
        exit 1
    fi
}

# Function to check internet connectivity
check_internet() {
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        error "No internet connection detected. Please check your network."
        exit 1
    fi
}

# Function to update package list
update_packages() {
    log "Updating package list..."
    if ! sudo apt update; then
        error "Failed to update package list"
        exit 1
    fi
    success "Package list updated successfully"
}

# Function to install dependencies
install_dependencies() {
    local deps=("$@")
    log "Installing dependencies: ${deps[*]}"
    
    for dep in "${deps[@]}"; do
        if ! dpkg -l | grep -q "^ii  $dep "; then
            log "Installing $dep..."
            if ! sudo apt install -y "$dep"; then
                error "Failed to install $dep"
                exit 1
            fi
            success "Installed $dep"
        else
            log "Package $dep is already installed"
        fi
    done
}

# Function to install Node.js and npm if not present
install_nodejs() {
    if ! command_exists node; then
        log "Installing Node.js and npm..."
        if ! curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -; then
            error "Failed to add NodeSource repository"
            exit 1
        fi
        if ! sudo apt install -y nodejs; then
            error "Failed to install Node.js"
            exit 1
        fi
        success "Node.js and npm installed successfully"
    else
        log "Node.js is already installed: $(node --version)"
    fi
}

# Function to install TypeScript
install_typescript() {
    log "Installing TypeScript globally..."
    if ! sudo npm install -g typescript; then
        error "Failed to install TypeScript"
        exit 1
    fi
    success "TypeScript installed successfully: $(tsc --version)"
}

# Function to install applications (apps)
install_apps() {
    log "Installing application dependencies..."
    
    local apps=(
        "kitty"      # terminal emulator
        "nautilus"   # file explorer
    )
    
    for app in "${apps[@]}"; do
        if ! command_exists "$app"; then
            log "Installing $app..."
            if ! sudo apt install -y "$app"; then
                warning "Failed to install $app, but continuing..."
            else
                success "Installed $app"
            fi
        else
            log "Application $app is already installed"
        fi
    done
    
    # Handle Spotify separately (install via snap if apt fails)
    if ! command_exists spotify; then
        log "Installing spotify..."
        if ! sudo apt install -y spotify; then
            log "Trying to install spotify via snap..."
            if ! sudo snap install spotify; then
                warning "Failed to install spotify via both apt and snap, you may need to install manually"
            else
                success "Installed spotify via snap"
            fi
        else
            success "Installed spotify"
        fi
    else
        log "Application spotify is already installed"
    fi
}

# Function to install screenshot tools
install_screenshot_tools() {
    log "Installing screenshot tools..."
    
    # Install grim (Wayland screenshot tool)
    if ! command_exists grim; then
        log "Installing grim..."
        if ! sudo apt install -y grim; then
            error "Failed to install grim"
            exit 1
        fi
        success "Installed grim"
    else
        log "grim is already installed"
    fi
    
    # Install grimblast (grim wrapper)
    if ! command_exists grimblast; then
        log "Installing grimblast..."
        if ! sudo apt install -y grimblast; then
            # Try alternative installation method
            log "Trying alternative grimblast installation..."
            if ! sudo apt install -y grimblast-git; then
                warning "grimblast not available in repositories, you may need to install manually"
            else
                success "Installed grimblast"
            fi
        else
            success "Installed grimblast"
        fi
    else
        log "grimblast is already installed"
    fi

    # Install slurp (area selection for screenshots)
    if ! command_exists slurp; then
        log "Installing slurp..."
        if ! sudo apt install -y slurp; then
            error "Failed to install slurp"
            exit 1
        fi
        success "Installed slurp"
    else
        log "slurp is already installed"
    fi

    # Install swappy (image editor)
    if ! command_exists swappy; then
        log "Installing swappy..."
        if ! sudo apt install -y swappy; then
            error "Failed to install swappy"
            exit 1
        fi
        success "Installed swappy"
    else
        log "swappy is already installed"
    fi

    # Install notify-send (for notifications)
    if ! command_exists notify-send; then
        log "Installing libnotify-bin (notify-send)..."
        if ! sudo apt install -y libnotify-bin; then
            error "Failed to install libnotify-bin"
            exit 1
        fi
        success "Installed libnotify-bin (notify-send)"
    else
        log "notify-send is already installed"
    fi
}

# Function to install rice components
install_rice_components() {
    log "Installing rice components..."
    
    # Install swww (wallpaper daemon)
    if ! command_exists swww; then
        log "Installing swww..."
        if ! sudo apt install -y swww; then
            # Try alternative installation
            if ! sudo apt install -y swww-git; then
                warning "swww not available in repositories, you may need to install manually"
            else
                success "Installed swww"
            fi
        else
            success "Installed swww"
        fi
    else
        log "swww is already installed"
    fi
    
    # Install hyprlock (screen locker)
    if ! command_exists hyprlock; then
        log "Installing hyprlock..."
        if ! sudo apt install -y hyprlock; then
            warning "hyprlock not available in repositories, you may need to install manually"
        else
            success "Installed hyprlock"
        fi
    else
        log "hyprlock is already installed"
    fi
    
    # Install libastal-meta (ags widget library)
    if ! pkg-config --exists astal-3.0; then
        log "Installing libastal-meta..."
        if ! sudo apt install -y libastal-meta; then
            warning "libastal-meta not available in repositories, will be built from source"
        else
            success "Installed libastal-meta"
        fi
    else
        log "libastal-meta is already installed"
    fi
}

# Function to install themes
install_themes() {
    log "Installing themes..."
    
    local themes=(
        "gruvbox-dark-gtk"           # Gruvbox GTK Theme
        "bibata-cursor-theme"        # Cursor theme
    )
    
    for theme in "${themes[@]}"; do
        if ! dpkg -l | grep -q "^ii  $theme "; then
            log "Installing $theme..."
            if ! sudo apt install -y "$theme"; then
                warning "Failed to install $theme, but continuing..."
            else
                success "Installed $theme"
            fi
        else
            log "Theme $theme is already installed"
        fi
    done
    
    # Install git-based themes
    local git_themes=(
        "phocus-gtk-theme-git"       # Oxocarbon like GTK Theme
        "everforest-gtk-theme-git"   # Everforest GTK Theme
        "nordic-darker-theme"        # Nord GTK Theme
    )
    
    for theme in "${git_themes[@]}"; do
        if ! dpkg -l | grep -q "^ii  $theme "; then
            log "Installing $theme..."
            if ! sudo apt install -y "$theme"; then
                warning "Failed to install $theme, you may need to install manually"
            else
                success "Installed $theme"
            fi
        else
            log "Theme $theme is already installed"
        fi
    done
}

# Function to install shell tools
install_shell_tools() {
    log "Installing shell tools..."
    
    local shell_tools=(
        "zsh"        # main shell
        "neovim"     # text editor
        "fastfetch"  # system info fetcher
    )
    
    for tool in "${shell_tools[@]}"; do
        if ! command_exists "$tool"; then
            log "Installing $tool..."
            if ! sudo apt install -y "$tool"; then
                warning "Failed to install $tool, but continuing..."
            else
                success "Installed $tool"
            fi
        else
            log "Shell tool $tool is already installed"
        fi
    done
}

# Function to install system utilities
install_system_utils() {
    log "Installing system utilities..."
    
    local system_utils=(
        "brightnessctl"      # controlling the brightness
        "wl-clipboard"       # for copy & paste
        "gjs"               # for running the bundled ags widget
        "gvfs"              # mpris cover art caching
        "pipewire-pulse"    # For audio
        "network-manager"   # manages network
    )
    
    for util in "${system_utils[@]}"; do
        if ! dpkg -l | grep -q "^ii  $util "; then
            log "Installing $util..."
            if ! sudo apt install -y "$util"; then
                warning "Failed to install $util, but continuing..."
            else
                success "Installed $util"
            fi
        else
            log "System utility $util is already installed"
        fi
    done
}

# Function to clone and build AGS
install_ags() {
    local build_dir="/tmp/ags-build"
    
    log "Installing AGS (Aylur's GTK Shell)..."
    
    # Clean up any existing build directory
    if [[ -d "$build_dir" ]]; then
        log "Cleaning up existing build directory..."
        rm -rf "$build_dir"
    fi
    
    # Clone AGS repository
    log "Cloning AGS repository..."
    if ! git clone --recursive https://github.com/Aylur/ags.git "$build_dir"; then
        error "Failed to clone AGS repository"
        exit 1
    fi
    
    # Build AGS
    cd "$build_dir"
    log "Building AGS..."
    if ! go build -o ags .; then
        error "Failed to build AGS"
        cd - > /dev/null
        rm -rf "$build_dir"
        exit 1
    fi
    
    # Install AGS
    log "Installing AGS to /usr/local/bin/..."
    if ! sudo cp ags /usr/local/bin/; then
        error "Failed to copy AGS binary"
        cd - > /dev/null
        rm -rf "$build_dir"
        exit 1
    fi
    
    if ! sudo chmod +x /usr/local/bin/ags; then
        error "Failed to make AGS executable"
        cd - > /dev/null
        rm -rf "$build_dir"
        exit 1
    fi
    
    # Verify installation
    if ags --version >/dev/null 2>&1; then
        success "AGS installed successfully: $(ags --version)"
    else
        error "AGS installation verification failed"
        cd - > /dev/null
        rm -rf "$build_dir"
        exit 1
    fi
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$build_dir"
    success "AGS installation completed"
}

# Function to check Astal build environment
check_astal_environment() {
    log "Checking Astal build environment..."
    
    # Check if we're in the correct directory
    if [[ ! -f "meson.build" ]]; then
        error "meson.build file not found. Please run this script from the Astal source directory."
        exit 1
    fi
    
    # Check if build directory exists, create if not
    if [[ ! -d "build" ]]; then
        log "Creating build directory..."
        mkdir -p build
    fi
    
    # Check if meson is installed
    if ! command_exists meson; then
        error "meson is not installed. Please install it first: sudo apt install meson"
        exit 1
    fi
    
    # Check if ninja is installed
    if ! command_exists ninja; then
        error "ninja is not installed. Please install it first: sudo apt install ninja-build"
        exit 1
    fi
    
    success "Astal build environment is ready"
}

# Function to build and install Astal
install_astal() {
    log "🚀 Starting Astal library installation..."
    
    # Configure the build if not already configured
    if [[ ! -f "build/build.ninja" ]]; then
        log "⚙️  Configuring build with meson..."
        if ! meson setup build; then
            error "Failed to configure build with meson"
            exit 1
        fi
    else
        log "Build already configured, skipping meson setup"
    fi
    
    # Build and install
    log "🔨 Building and installing Astal library..."
    if ! sudo meson install -C build; then
        error "Failed to build and install Astal library"
        exit 1
    fi
    
    # Update library cache
    log "🔄 Updating library cache..."
    if ! sudo ldconfig; then
        warning "Failed to update library cache, but installation may still be successful"
    fi
    
    success "Astal library installation completed successfully!"
    log "📦 The library has been installed to:"
    echo "   - Library: /usr/lib/x86_64-linux-gnu/libastal.so"
    echo "   - Headers: /usr/include/astal.h"
    echo "   - VAPI: /usr/share/vala/vapi/astal-3.0.vapi"
    echo "   - GIR: /usr/share/gir-1.0/Astal-3.0.gir"
    echo "   - pkg-config: /usr/lib/x86_64-linux-gnu/pkgconfig/astal-3.0.pc"
}

# Function to create directories if they don't exist
create_directories() {
    log "Creating necessary directories..."
    
    local dirs=(
        "$HOME/.local/share/fonts"
        "$HOME/.config"
        "$HOME/.scripts"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log "Creating directory: $dir"
            mkdir -p "$dir"
        else
            log "Directory already exists: $dir"
        fi
    done
}

# Function to clone the configuration repository
clone_config() {
    local temp_dir="/tmp/yume-config"
    
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} Cloning yume configuration repository..." >&2
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} Cleaning up existing temp directory..." >&2
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone --depth=1 --single-branch --branch yume https://github.com/qxb3/conf "$temp_dir" >/dev/null 2>&1; then
        echo -e "${RED}[ERROR]${NC} Failed to clone the configuration repository" >&2
        exit 1
    fi
    
    echo -e "${GREEN}[SUCCESS]${NC} Configuration repository cloned successfully" >&2
    echo "$temp_dir"
}

# Function to copy fonts
copy_fonts() {
    local config_dir="$1"
    local fonts_source="$config_dir/font"
    local fonts_dest="$HOME/.local/share/fonts"
    
    log "Checking for font directory: $fonts_source"
    
    if [[ ! -d "$fonts_source" ]]; then
        warning "Font directory not found: $fonts_source"
        log "Available directories in $config_dir:"
        ls -la "$config_dir" || true
        return 0
    fi
    
    # Check if fonts directory is empty
    if [[ ! "$(ls -A "$fonts_source" 2>/dev/null)" ]]; then
        warning "Font directory is empty, skipping font installation"
        return 0
    fi
    
    log "Font directory found with contents:"
    ls -la "$fonts_source" || true
    
    log "Copying fonts to $fonts_dest..."
    if ! cp -r "$fonts_source"/* "$fonts_dest"/; then
        error "Failed to copy fonts"
        return 1
    fi
    
    success "Fonts copied successfully"
    
    # Update font cache
    log "Updating font cache..."
    if command_exists fc-cache; then
        if ! fc-cache -fv; then
            warning "Failed to update font cache, but fonts may still work"
        else
            success "Font cache updated successfully"
        fi
    else
        warning "fc-cache not found, font cache not updated"
    fi
}

# Function to copy configuration files
copy_config() {
    local config_dir="$1"
    local config_source="$config_dir/.config"
    local config_dest="$HOME/.config"
    
    log "Checking for configuration directory: $config_source"
    
    if [[ ! -d "$config_source" ]]; then
        error "Configuration directory not found: $config_source"
        log "Available directories in $config_dir:"
        ls -la "$config_dir" || true
        return 1
    fi
    
    # Check if config directory is empty
    if [[ ! "$(ls -A "$config_source" 2>/dev/null)" ]]; then
        warning "Configuration directory is empty, skipping config installation"
        return 0
    fi
    
    log "Configuration directory found with contents:"
    ls -la "$config_source" || true
    
    log "Copying configuration files to $config_dest..."
    if ! cp -r "$config_source"/* "$config_dest"/; then
        error "Failed to copy configuration files"
        return 1
    fi
    
    success "Configuration files copied successfully"
}

# Function to copy scripts (optional)
copy_scripts() {
    local config_dir="$1"
    local scripts_source="$config_dir/.scripts"
    local scripts_dest="$HOME/.scripts"
    
    log "Checking for scripts directory: $scripts_source"
    
    if [[ ! -d "$scripts_source" ]]; then
        warning "Scripts directory not found: $scripts_source"
        log "Available directories in $config_dir:"
        ls -la "$config_dir" || true
        return 0
    fi
    
    log "Scripts directory found with contents:"
    ls -la "$scripts_source" || true
    
    log "Copying scripts to $scripts_dest..."
    if ! cp -r "$scripts_source"/* "$scripts_dest"/; then
        error "Failed to copy scripts"
        return 1
    fi
    
    # Make scripts executable
    log "Making scripts executable..."
    find "$scripts_dest" -type f -name "*.sh" -exec chmod +x {} \;
    
    success "Scripts copied and made executable successfully"
}

# Function to build AGS configuration
build_ags_config() {
    local ags_config_dir="$HOME/.config/ags"
    
    if [[ ! -d "$ags_config_dir" ]]; then
        error "AGS configuration directory not found: $ags_config_dir"
        log "Please ensure the configuration files were copied correctly"
        return 1
    fi
    
    if ! command_exists ags; then
        error "AGS is not installed. Please install AGS first."
        return 1
    fi
    
    cd "$ags_config_dir"
    log "Building AGS configuration..."
    
    if ! ags bundle app.ts yume; then
        error "Failed to build AGS configuration"
        cd - > /dev/null
        return 1
    fi
    
    success "AGS configuration built successfully"
    cd - > /dev/null
}

# Function to verify all installations
verify_installations() {
    log "Verifying all installations..."
    
    # Verify AGS
    if command_exists ags; then
        success "AGS is available: $(ags --version)"
    else
        error "AGS is not available in PATH"
    fi
    
    # Verify TypeScript
    if command_exists tsc; then
        success "TypeScript is available: $(tsc --version)"
    else
        error "TypeScript is not available in PATH"
    fi
    
    # Verify Astal library files
    local astal_files=(
        "/usr/lib/x86_64-linux-gnu/libastal.so"
        "/usr/include/astal.h"
        "/usr/share/vala/vapi/astal-3.0.vapi"
        "/usr/share/gir-1.0/Astal-3.0.gir"
        "/usr/lib/x86_64-linux-gnu/pkgconfig/astal-3.0.pc"
    )
    
    for file in "${astal_files[@]}"; do
        if [[ -f "$file" ]]; then
            success "Astal file exists: $file"
        else
            warning "Astal file missing: $file"
        fi
    done
}

# Function to verify all dependencies
verify_dependencies() {
    log "Verifying all dependencies..."
    
    local required_deps=(
        "grim" "swappy" "swww" "hyprlock" "ags" "brightnessctl" 
        "wl-clipboard" "gjs" "gvfs" "pipewire-pulse" "network-manager"
    )
    
    local optional_deps=(
        "kitty" "nautilus" "spotify" "grimblast" "zsh" "neovim" "fastfetch"
    )
    
    echo "Checking required dependencies:"
    for dep in "${required_deps[@]}"; do
        if command_exists "$dep"; then
            success "✓ $dep is available"
        else
            error "✗ $dep is missing"
        fi
    done
    
    echo "Checking optional dependencies:"
    for dep in "${optional_deps[@]}"; do
        if command_exists "$dep"; then
            success "✓ $dep is available"
        else
            warning "⚠ $dep is missing (optional)"
        fi
    done
    
    # Check for themes
    echo "Checking themes:"
    local themes=("gruvbox-dark-gtk" "bibata-cursor-theme" "phocus-gtk-theme-git" "everforest-gtk-theme-git" "nordic-darker-theme")
    for theme in "${themes[@]}"; do
        if dpkg -l | grep -q "^ii  $theme "; then
            success "✓ $theme is installed"
        else
            warning "⚠ $theme is missing"
        fi
    done
}

# Function to verify configuration installation
verify_config_installation() {
    log "Verifying configuration installation..."
    
    # Check if fonts were copied
    if [[ -d "$HOME/.local/share/fonts" ]] && [[ "$(ls -A "$HOME/.local/share/fonts" 2>/dev/null)" ]]; then
        success "Fonts are installed"
    else
        warning "No fonts found in ~/.local/share/fonts"
    fi
    
    # Check if AGS config exists
    if [[ -d "$HOME/.config/ags" ]]; then
        success "AGS configuration directory exists"
        
        # Check for app.ts file
        if [[ -f "$HOME/.config/ags/app.ts" ]]; then
            success "AGS app.ts file found"
        else
            warning "AGS app.ts file not found"
        fi
    else
        error "AGS configuration directory not found"
    fi
    
    # Check if scripts were copied
    if [[ -d "$HOME/.scripts" ]] && [[ "$(ls -A "$HOME/.scripts" 2>/dev/null)" ]]; then
        success "Scripts are installed"
    else
        warning "No scripts found in ~/.scripts"
    fi
}

# Function to provide manual installation instructions
show_manual_install_instructions() {
    echo
    log "📋 Manual Installation Instructions for Missing Packages:"
    echo
    echo "The following packages are now automatically installed by the script:"
    echo "✓ grimblast (screenshot tool) - Installed from source"
    echo "✓ swww (wallpaper daemon) - Installed from source"
    echo "✓ hyprlock (screen locker) - Installed from source"
    echo "✓ Themes - Installed from source repositories"
    echo
    echo "If any of these failed to install automatically, you can install them manually:"
    echo
    echo "1. grimblast (screenshot tool):"
    echo "   git clone https://github.com/hyprwm/contrib.git"
    echo "   cd contrib"
    echo "   sudo cp grimblast /usr/local/bin/"
    echo "   sudo chmod +x /usr/local/bin/grimblast"
    echo
    echo "2. swww (wallpaper daemon):"
    echo "   git clone https://github.com/Horus645/swww.git"
    echo "   cd swww"
    echo "   cargo build --release"
    echo "   sudo cp target/release/swww /usr/local/bin/"
    echo "   sudo cp target/release/swww-daemon /usr/local/bin/"
    echo
    echo "3. hyprlock (screen locker):"
    echo "   git clone https://github.com/hyprwm/hyprlock.git"
    echo "   cd hyprlock"
    echo "   make all"
    echo "   sudo make install"
    echo
    echo "4. Themes (install via your package manager or manually):"
    echo "   - gruvbox-dark-gtk"
    echo "   - phocus-gtk-theme-git"
    echo "   - everforest-gtk-theme-git"
    echo "   - nordic-darker-theme"
    echo
    echo "You can install these manually or use alternative themes."
}

# Function to provide next steps
show_next_steps() {
    echo
    log "🎉 Complete setup finished! Next steps:"
    echo
    echo "1. Restart your system to ensure all changes take effect:"
    echo "   sudo reboot"
    echo
    echo "2. After restart, you can start AGS with:"
    echo "   ags"
    echo
    echo "3. To stop AGS, use:"
    echo "   ags --quit"
    echo
    echo "4. To reload AGS configuration:"
    echo "   ags --reload"
    echo
    echo "5. To enable AGS on startup, add to your session:"
    echo "   ags &"
    echo
    echo "6. Useful AGS commands:"
    echo "   ags --dev           # Development mode"
    echo "   ags --version       # Check version"
    echo
    warning "Note: You may need to log out and log back in for some changes to take effect."
    info "All dependencies and configurations have been installed successfully!"
    
    # Show manual installation instructions if needed
    show_manual_install_instructions
}

# Function to install hyprlang
install_hyprlang() {
    if pkg-config --exists hyprlang; then
        log "hyprlang is already installed"
        return 0
    fi
    
    log "Installing hyprlang..."
    local temp_dir="/tmp/hyprlang-install"
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/hyprwm/hyprlang.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone hyprlang repository"
        return 1
    fi
    
    # Build and install hyprlang
    cd "$temp_dir"
    if ! cmake -B build; then
        warning "Failed to configure hyprlang with cmake"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! cmake --build build; then
        warning "Failed to build hyprlang"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! sudo cmake --install build; then
        warning "Failed to install hyprlang"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    success "Installed hyprlang successfully"
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 0
}

# Function to install hyprutils
install_hyprutils() {
    if pkg-config --exists hyprutils; then
        log "hyprutils is already installed"
        return 0
    fi
    
    log "Installing hyprutils..."
    local temp_dir="/tmp/hyprutils-install"
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/hyprwm/hyprutils.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone hyprutils repository"
        return 1
    fi
    
    # Build and install hyprutils
    cd "$temp_dir"
    if ! cmake -B build; then
        warning "Failed to configure hyprutils with cmake"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! cmake --build build; then
        warning "Failed to build hyprutils"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! sudo cmake --install build; then
        warning "Failed to install hyprutils"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    success "Installed hyprutils successfully"
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 0
}

# Function to install hyprgraphics
install_hyprgraphics() {
    if pkg-config --exists hyprgraphics; then
        log "hyprgraphics is already installed"
        return 0
    fi
    
    log "Installing hyprgraphics..."
    local temp_dir="/tmp/hyprgraphics-install"
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/hyprwm/hyprgraphics.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone hyprgraphics repository"
        return 1
    fi
    
    # Build and install hyprgraphics
    cd "$temp_dir"
    if ! cmake -B build; then
        warning "Failed to configure hyprgraphics with cmake"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! cmake --build build; then
        warning "Failed to build hyprgraphics"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! sudo cmake --install build; then
        warning "Failed to install hyprgraphics"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    success "Installed hyprgraphics successfully"
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 0
}

# Function to install hyprwayland-scanner
install_hyprwayland_scanner() {
    if pkg-config --exists hyprwayland-scanner; then
        log "hyprwayland-scanner is already installed"
        return 0
    fi
    
    log "Installing hyprwayland-scanner..."
    local temp_dir="/tmp/hyprwayland-scanner-install"
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/hyprwm/hyprwayland-scanner.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone hyprwayland-scanner repository"
        return 1
    fi
    
    # Build and install hyprwayland-scanner
    cd "$temp_dir"
    if ! cmake -B build; then
        warning "Failed to configure hyprwayland-scanner with cmake"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! cmake --build build; then
        warning "Failed to build hyprwayland-scanner"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! sudo cmake --install build; then
        warning "Failed to install hyprwayland-scanner"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    success "Installed hyprwayland-scanner successfully"
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 0
}

# Function to install grimblast manually
install_grimblast() {
    if command_exists grimblast; then
        log "grimblast is already installed"
        return 0
    fi
    
    log "Installing grimblast manually..."
    local temp_dir="/tmp/grimblast-install"
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/hyprwm/contrib.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone grimblast repository"
        return 1
    fi
    
    # Copy grimblast script from the grimblast subdirectory
    if [[ -f "$temp_dir/grimblast/grimblast" ]]; then
        if ! sudo cp "$temp_dir/grimblast/grimblast" /usr/local/bin/; then
            warning "Failed to copy grimblast to /usr/local/bin/"
            rm -rf "$temp_dir"
            return 1
        fi
        
        if ! sudo chmod +x /usr/local/bin/grimblast; then
            warning "Failed to make grimblast executable"
            rm -rf "$temp_dir"
            return 1
        fi
        
        success "Installed grimblast successfully"
        rm -rf "$temp_dir"
        return 0
    else
        warning "grimblast script not found in repository"
        rm -rf "$temp_dir"
        return 1
    fi
}

# Function to install swww manually
install_swww() {
    if command_exists swww; then
        log "swww is already installed"
        return 0
    fi
    
    log "Installing swww manually..."
    local temp_dir="/tmp/swww-install"
    
    # Check if cargo is available
    if ! command_exists cargo; then
        log "Installing Rust and Cargo..."
        if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
            warning "Failed to install Rust"
            return 1
        fi
        # Source cargo environment
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/Horus645/swww.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone swww repository"
        return 1
    fi
    
    # Build swww
    cd "$temp_dir"
    if ! cargo build --release; then
        warning "Failed to build swww"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Install swww binaries
    if [[ -f "target/release/swww" ]] && [[ -f "target/release/swww-daemon" ]]; then
        if ! sudo cp target/release/swww /usr/local/bin/; then
            warning "Failed to copy swww to /usr/local/bin/"
            cd - > /dev/null
            rm -rf "$temp_dir"
            return 1
        fi
        
        if ! sudo cp target/release/swww-daemon /usr/local/bin/; then
            warning "Failed to copy swww-daemon to /usr/local/bin/"
            cd - > /dev/null
            rm -rf "$temp_dir"
            return 1
        fi
        
        success "Installed swww successfully"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 0
    else
        warning "swww binaries not found after build"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
}

# Function to install hyprlock manually
install_hyprlock() {
    if command_exists hyprlock; then
        log "hyprlock is already installed"
        return 0
    fi
    
    log "Installing hyprlock manually..."
    
    # Install dependencies in order - hyprutils must come before hyprlang
    if ! install_hyprutils; then
        warning "Failed to install hyprutils, skipping hyprlock"
        return 1
    fi
    
    if ! install_hyprlang; then
        warning "Failed to install hyprlang, skipping hyprlock"
        return 1
    fi
    
    if ! install_hyprgraphics; then
        warning "Failed to install hyprgraphics, skipping hyprlock"
        return 1
    fi
    
    if ! install_hyprwayland_scanner; then
        warning "Failed to install hyprwayland-scanner, skipping hyprlock"
        return 1
    fi
    
    local temp_dir="/tmp/hyprlock-install"
    
    # Clean up any existing temp directory
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
    
    # Clone the repository
    if ! git clone https://github.com/hyprwm/hyprlock.git "$temp_dir" >/dev/null 2>&1; then
        warning "Failed to clone hyprlock repository"
        return 1
    fi
    
    # Build and install hyprlock using CMake
    cd "$temp_dir"
    if ! cmake -B build; then
        warning "Failed to configure hyprlock with cmake"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! cmake --build build; then
        warning "Failed to build hyprlock"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    if ! sudo cmake --install build; then
        warning "Failed to install hyprlock"
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    success "Installed hyprlock successfully"
    cd - > /dev/null
    rm -rf "$temp_dir"
    return 0
}

# Function to install themes manually
install_themes_manual() {
    log "Installing themes manually..."

    # Install gruvbox-dark-gtk theme
    if ! dpkg -l | grep -q "^ii  gruvbox-dark-gtk "; then
        log "Installing gruvbox-dark-gtk theme..."
        local temp_dir="/tmp/gruvbox-theme"
        if [[ -d "$temp_dir" ]]; then rm -rf "$temp_dir"; fi
        if git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git "$temp_dir" >/dev/null 2>&1; then
            cd "$temp_dir"
            if [[ -f "install.sh" ]]; then
                if sudo ./install.sh; then
                    success "Installed gruvbox-dark-gtk theme"
                else
                    warning "Failed to install gruvbox-dark-gtk theme"
                fi
            elif [[ -d "themes" ]]; then
                sudo cp -r themes/* /usr/share/themes/ 2>/dev/null || true
                success "Installed gruvbox-dark-gtk theme manually"
            else
                warning "No themes directory found in gruvbox repository"
            fi
            cd - > /dev/null
            rm -rf "$temp_dir"
        else
            warning "Failed to clone gruvbox theme repository"
        fi
    fi

    # Install phocus theme
    if ! dpkg -l | grep -q "^ii  phocus-gtk-theme-git "; then
        log "Installing phocus theme..."
        local temp_dir="/tmp/phocus-theme"
        if [[ -d "$temp_dir" ]]; then rm -rf "$temp_dir"; fi
        if git clone https://github.com/phocus/gtk.git "$temp_dir" >/dev/null 2>&1; then
            cd "$temp_dir"
            if [[ -f "install.sh" ]]; then
                if sudo ./install.sh; then
                    success "Installed phocus theme"
                else
                    warning "Failed to install phocus theme"
                fi
            elif [[ -d "themes" ]]; then
                sudo cp -r themes/* /usr/share/themes/ 2>/dev/null || true
                success "Installed phocus theme manually"
            elif [[ -d "Phocus" ]]; then
                sudo cp -r Phocus /usr/share/themes/ 2>/dev/null || true
                success "Installed Phocus theme manually"
            else
                warning "No installable theme directory found in phocus repository"
            fi
            cd - > /dev/null
            rm -rf "$temp_dir"
        else
            warning "Failed to clone phocus theme repository"
        fi
    fi

    # Install everforest theme
    if ! dpkg -l | grep -q "^ii  everforest-gtk-theme-git "; then
        log "Installing everforest theme..."
        local temp_dir="/tmp/everforest-theme"
        if [[ -d "$temp_dir" ]]; then rm -rf "$temp_dir"; fi
        if git clone https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme.git "$temp_dir" >/dev/null 2>&1; then
            cd "$temp_dir"
            if [[ -f "install.sh" ]]; then
                if sudo ./install.sh; then
                    success "Installed everforest theme"
                else
                    warning "Failed to install everforest theme"
                fi
            elif [[ -d "themes" ]]; then
                sudo cp -r themes/* /usr/share/themes/ 2>/dev/null || true
                success "Installed everforest theme manually"
            elif [[ -d "Everforest-Dark" ]]; then
                sudo cp -r Everforest-Dark /usr/share/themes/ 2>/dev/null || true
                success "Installed Everforest-Dark theme manually"
            else
                warning "No installable theme directory found in everforest repository"
            fi
            cd - > /dev/null
            rm -rf "$temp_dir"
        else
            warning "Failed to clone everforest theme repository"
        fi
    fi

    # Install nordic theme
    if ! dpkg -l | grep -q "^ii  nordic-darker-theme "; then
        log "Installing nordic theme..."
        local temp_dir="/tmp/nordic-theme"
        if [[ -d "$temp_dir" ]]; then rm -rf "$temp_dir"; fi
        if git clone https://github.com/EliverLara/Nordic.git "$temp_dir" >/dev/null 2>&1; then
            cd "$temp_dir"
            if [[ -f "install.sh" ]]; then
                if sudo ./install.sh; then
                    success "Installed nordic theme"
                else
                    warning "Failed to install nordic theme"
                fi
            elif [[ -d "themes" ]]; then
                sudo cp -r themes/* /usr/share/themes/ 2>/dev/null || true
                success "Installed nordic theme manually"
            elif [[ -d "Nordic-darker" ]]; then
                sudo cp -r Nordic-darker /usr/share/themes/ 2>/dev/null || true
                success "Installed Nordic-darker theme manually"
            else
                warning "No installable theme directory found in nordic repository"
            fi
            cd - > /dev/null
            rm -rf "$temp_dir"
        else
            warning "Failed to clone nordic theme repository"
        fi
    fi
}

# Function to install optional tools
install_optional_tools() {
    log "Installing optional tools..."
    local optional_tools=("neovim" "wl-clipboard" "gvfs" "network-manager")
    for tool in "${optional_tools[@]}"; do
        if ! command_exists "$tool"; then
            log "Installing $tool..."
            if ! sudo apt install -y "$tool"; then
                warning "Failed to install $tool, you may need to install manually."
            else
                success "Installed $tool"
            fi
        else
            log "$tool is already installed"
        fi
    done
}

# Function to install/copy screenshot script
install_screenshot_script() {
    log "Setting up Hyprland screenshot script..."
    local script_dir="$HOME/.config/hypr/scripts"
    local script_path="$script_dir/screenshot.sh"
    mkdir -p "$script_dir"
    cat > "$script_path" <<'EOF'
#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

ScrDir=`dirname "$(realpath "$0")"`
swpy_dir="${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config

print_error() {
cat << "EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p : print all screens
        s : snip current screen
        sf : snip current screen (frozen)
        m : print focused monitor
EOF
}

case $1 in
p)  # print all outputs
    grimblast copysave screen $temp_screenshot && swappy -f $temp_screenshot ;;
s)  # drag to manually snip an area / click on a window to print it
    grimblast copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
sf)  # frozen screen, drag to manually snip an area / click on a window to print it
    grimblast --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
m)  # print focused monitor
    grimblast copysave output $temp_screenshot && swappy -f $temp_screenshot ;;
*)  # invalid option
    print_error ;;
esac

# Clean up temp file if it exists
if [ -f "$temp_screenshot" ]; then
    rm "$temp_screenshot"
fi

# Send notification if screenshot was saved
if [ -f "$save_dir/$save_file" ] ; then
  notify-send -a "Screenshot" -i "${save_dir}/${save_file}" -t 2200 "Screenshot saved" "saved at ${save_dir}/${save_file}"
fi
EOF
    chmod +x "$script_path"
    success "Screenshot script installed to $script_path and made executable."
    info "You can bind it in Hyprland with: bind = \$mod, P, exec, ~/.config/hypr/scripts/screenshot.sh s"
}

# Main installation function
main() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Hyprland Setup Script                     ║"
    echo "║              AGS + Astal + Yume Configuration                ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log "Starting complete Hyprland setup process..."
    
    # Pre-flight checks
    step "1/8: Pre-flight checks"
    check_root
    check_internet
    
    # Update packages
    step "2/8: Updating system packages"
    update_packages
    
    # Install AGS dependencies
    step "3/8: Installing AGS and system dependencies"
    local ags_deps=(
        meson ninja-build pkg-config libgtk-3-dev libgtk-layer-shell-dev
        libpulse-dev libglib2.0-dev libgee-0.8-dev libjson-glib-dev
        libpam0g-dev libgirepository1.0-dev libgjs-dev gjs golang-go
        build-essential git curl wget liblz4-dev cmake
        libwayland-dev libxkbcommon-dev libpango1.0-dev libcairo2-dev
        libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev
        libpugixml-dev libsdbus-c++-dev libmagic-dev
    )
    install_dependencies "${ags_deps[@]}"
    
    # Install Node.js and TypeScript
    install_nodejs
    install_typescript
    
    # Install all yume dependencies
    step "4/8: Installing yume dependencies"
    install_apps
    install_screenshot_tools
    install_rice_components
    install_themes
    install_shell_tools
    install_system_utils
    
    # Install missing packages manually
    step "4.5/8: Installing missing packages manually"
    install_grimblast
    install_swww
    install_hyprlock
    install_themes_manual
    install_optional_tools
    
    # Install AGS
    step "5/8: Installing AGS"
    install_ags
    
    # Install Astal (if in correct directory)
    step "6/8: Installing Astal library"
    if [[ -f "meson.build" ]]; then
        check_astal_environment
        install_astal
    else
        warning "Not in Astal source directory. Skipping Astal installation."
        log "To install Astal, run this script from the Astal source directory."
    fi
    
    # Install yume configuration
    step "7/8: Installing yume configuration"
    create_directories
    local config_dir
    config_dir=$(clone_config)
    copy_fonts "$config_dir"
    copy_config "$config_dir"
    copy_scripts "$config_dir"
    build_ags_config
    
    # Cleanup
    log "Cleaning up temporary files..."
    rm -rf "$config_dir"
    
    # Verify all installations
    step "8/8: Verifying installations"
    verify_installations
    verify_dependencies
    verify_config_installation
    
    # Install screenshot script
    install_screenshot_script
    
    # Show next steps
    show_next_steps
    
    success "🎉 Complete Hyprland setup finished successfully!"
    log "Your system is now ready with AGS, Astal, and yume configuration!"
}

# Run main function
main "$@" 