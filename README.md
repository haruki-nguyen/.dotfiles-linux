# Haruki Nguyen's Dotfiles

A comprehensive collection of configuration files and setup scripts for a personalized Ubuntu development environment.

## 🚀 Quick Start

```bash
# Clone the repository
git clone git@github.com:haruki-nguyen/.dotfiles.git ~/.dotfiles

# Run the automated installer (Ubuntu)
cd ~/.dotfiles/installers
./ubuntu-installer.sh
```

## 📁 Project Structure

### Core Configuration

- **`.zshrc`** - Zsh shell configuration with Oh My Zsh, custom aliases, and zoxide
- **`.gitconfig`** - Git configuration and aliases
- **`.stylua.toml`** - Lua code formatter configuration

### Application Configs (`.config/`)

- **`alacritty/`** - Terminal emulator configuration
- **`btop/`** - System monitor configuration
- **`espanso/`** - Text expansion tool
- **`ohmyposh/`** - Shell prompt customization
- **`tmux/`** - Terminal multiplexer configuration
- **`ulauncher/`** - Application launcher
- **`warp-terminal/`** - Modern terminal configuration
- **`zsh/`** - Additional Zsh scripts and configurations

### Tools & Scripts

- **`installers/ubuntu-installer.sh`** - Automated Ubuntu system setup
- **`automation-scripts/sale-rate.js`** - Custom automation script
- **`get-platformio.py`** - PlatformIO setup script

### Resources

- **`wallpapers/`** - Desktop wallpapers
- **`wikies/Ubuntu.md`** - Ubuntu-specific documentation
- **`flowlauncher-settings.json`** - Flow Launcher configuration
- **`MBLABXIDE-configs.zip`** - MPLAB X IDE configurations

## 🛠️ Features

### Shell Environment

- **Oh My Zsh** with robbyrussell theme
- **Zoxide** for smart directory navigation
- Custom aliases for common commands
- Git integration with useful shortcuts

### Development Tools

- **Alacritty** and **Warp Terminal** configurations
- **Tmux** setup with plugin manager
- **Ulauncher** for quick app launching
- **Espanso** for text expansion

### System Management

- **Btop** for system monitoring
- Automated package installation
- Flatpak and Snap integration
- Font installation (JetBrains Mono Nerd Font)

## 🔧 Installation

### Automated Setup (Recommended)

The `ubuntu-installer.sh` script handles:

- System package installation
- Terminal emulator setup
- Development tools configuration
- Font installation
- SSH key generation
- Dotfiles deployment via GNU Stow

### Manual Setup

```bash
# Install GNU Stow
sudo apt install stow

# Deploy configurations
cd ~/.dotfiles
stow .
```

## 📝 Usage

### Common Aliases

- `refresh` - Reload shell configuration and redeploy dotfiles
- `gits` - Git status
- `gitl` - Git log with graph
- `gitsync` - Pull, rebase, and push
- `md` - Create directory with parents
- `py` - Python 3 shortcut

### Shell Commands

- `z` - Navigate to frequently used directories (zoxide)
- `btop` - System monitoring
- `tmux` - Terminal multiplexing

## 🔒 Security

- SSH key generation for GitHub
- Secure package installation from official sources
- Proper file permissions and ownership

## 📚 Documentation

- Check `wikies/Ubuntu.md` for Ubuntu-specific setup notes
- Configuration files include inline comments
- Installer script has detailed package descriptions

## 🤝 Contributing

This is a personal dotfiles repository, but suggestions and improvements are welcome through issues or pull requests.

## 📄 License

Personal use - feel free to adapt for your own setup.
