# Ubuntu WSL on Windows

## Dependencies

The following dependencies are required for the setup:

- Windows Terminal
- LibreWolf
- `ntpdate`.
- `nvm`.
- `nodejs`
- `npm`
- `pnpm`
- `neovim`
- `tmux`
- `zip`
- `starship`
- `cargo`: for installing `gitui`
- `gitui`
- `btop`
- `software-properties-common`: enable `add-apt-repository` command.

## Installation

Run this before installation

```bash
sudo apt install ntpdate
sudo ntpdate time.windows.com
```

Install `nvm` and `nodejs`:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node # Install the latest version of NodeJS
```

```bash
sudo apt-get update
sudo apt install npm tmux zip cargo btop software-properties-common
```

Install `neovim`:

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt upgrade
sudo apt install neovim
```

Install `starship`:

```bash
curl -sS https://starship.rs/install.sh | sh
```

Install `gitui`:

```bash
cargo install gitui
```

Install `pnpm`:

```bash
sudo npm i -g pnpm
pnpm setup
source ~/.bashrc
```

## Setting Up

Follow the steps below to set up the Ubuntu machine:

### Nerd Font Installation

1. Visit [https://www.nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads) and download a Nerd font of your choice (e.g., Iosevka).
2. Extract the font archive and move the font files to the `C:\Windows\Fonts` directory.

### Tmux

Install Tmux Plugin Manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Create the Tmux configuration directory and symlink the configuration file:

```bash
mkdir ~/.config/tmux
ln -s ~/.dotfiles/configs/tmux.conf ~/.config/tmux
```

Reload Tmux with `tmux source ~/.config/tmux/tmux.conf` and install the plugins with `<prefix> + I`.

### Neovim

Install NvChad:

```bash
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
```

Set up custom NvChad configs:

```bash
rm -rf ~/.config/nvim/lua/custom/
ln -s ~/.dotfiles/configs/neovim ~/.config/nvim/lua/custom
```

### LibreWolf

- Login to sync Bookmarks, Settings, and Add-ons.
- Set up the following add-ons:
  - Dark Reader
  - Simple Translate
  - DuckDuckGo Privacy Essentials
  - React Developer Tools

### Starship

```bash
ln -s ~/.dotfiles/configs/starship.toml ~/.config
```

### Bash

```bash
echo -e "\nsource ~/.dotfiles/configs/bash/bashrc_custom.sh" >> ~/.bashrc
source ~/.bashrc
```

### Git

```bash
ln -s ~/.dotfiles/configs/.gitconfig ~/
```

### GitUI

```bash
rm -rf ~/.config/gitui
ln -s ~/.dotfiles/configs/gitui ~/.config
```

### GitHub SSH

Set up your SSH key on the device:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Follow the instructions provided at [https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to add the SSH key to your GitHub account.

Update the remote URL for your repository with `git remote set-url origin <URL>`.

### Btop

```bash
rm ~/.config/btop
ln -s ~/.dotfiles/configs/btop ~/.config
```
