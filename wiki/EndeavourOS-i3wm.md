# EndeavourOS with i3wm Setup

## Dependencies

- `yay`.
- `google-chrome`.
- `obsidian`.
- `syncthing`.
- `neovim`, with dependencies:
  - `ripgrep`.
  - `fd`.
  - `python3.10-venv`.
- `nodejs` and `npm` (for installing `prettier` in `mason` in `neovim`).
- `tmux`.
- `zip` and `unzip`.
- `kitty`.
- `starship`.
- `gitui` with dependency: `cargo`.
- `signal`.
- `ibus` and `ibus-unikey` for Telex typing method.
- `dos2unix`.
- `btop`.

## Basic System Setup

Update the system as needed for your workflow using `eos-welcome` command.

## Installation

- Install a Nerd Font:

  ```bash
  # Download the font archive
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
  
  # Unzip the archive
  unzip JetBrainsMono.zip -d JetBrainsMono
  
  # Move the font files to your fonts directory
  mkdir -p ~/.local/share/fonts/JetBrainsMono
  mv JetBrainsMono/*.ttf ~/.local/share/fonts/JetBrainsMono
  
  # Rebuild the font cache
  fc-cache -fv
  ```

- Install `yay` if it isn't installed:

  ```bash
  sudo pacman -S --needed git base-devel yay
  ```

  Then use `yay` to install other packages:

  ```bash
  yay -S google-chrome obsidian syncthing neovim ripgrep fd python3.10-venv tmux zip unzip kitty nodejs npm signal ibus ibus-unikey dos2unix btop
  ```

- Install Starship:

  ```bash
  curl -sS https://starship.rs/install.sh | sh
  ```

## Setup

- **GitHub SSH**:

  - Setting up SSH key:

    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```

  - Add SSH key to GitHub: [GitHub SSH Key Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux).
  - Clone your dotfiles: `git clone git@github.com:haruki-nguyen/.dotfiles.git`.

- **Git**: `ln -s ~/.dotfiles/configs/git/.gitconfig ~/`.

- **Bash**:

  ```bash
  echo -e "\nsource ~/.dotfiles/configs/bash/bashrc_custom.sh" >> ~/.bashrc
  source ~/.bashrc
  ```

- **Kitty**:

  ```bash
  rm -r ~/.config/kitty
  ln -s ~/.dotfiles/configs/terminals/kitty/ ~/.config/
  ```

- **Neovim**:

  - Install NvChad:

    ```bash
    git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
    ```

    Run `:MasonInstallAll` and `:Lazy sync`, then:

    ```bash
    rm -rf ~/.config/nvim/.git
    ```

  - Setup custom NvChad configs:

    ```bash
    rm -rf ~/.config/nvim/lua
    ln -s ~/.dotfiles/configs/nvim/ ~/.config/nvim/lua
    ```

- **Tmux**:

  - Install Tmux Plugin Manager:

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

  - Link custom config:

    ```bash
    mkdir -p ~/.config/tmux
    ln -s ~/.dotfiles/configs/tmux/tmux.conf ~/.config/tmux
    ```

  - Reload Tmux: `tmux source ~/.config/tmux/tmux.conf` and install plugins with `<prefix> + I`.

- **GitUI**:

  ```bash
  rm -rf ~/.config/gitui
  ln -s ~/.dotfiles/configs/gitui ~/.config
  ```

- **i3wm Config**:

  Link your custom i3 config file:

  ```bash
  ln -s ~/.dotfiles/configs/i3/config ~/.config/i3/config
  ```

- **Ibus**:

1. Restart your system after installing `ibus` and `ibus-unikey` to ensure ibus starts with the system.
2. Open IBus Preferences:

   ```bash
   ibus-setup
   ```

- **BTOP**:

  ```bash
  ln -s ~/.dotfiles/configs/btop/catppuccin-mocha.theme ~/.config/btop/themes
  ```

  Then change BTOP's configs in the UI.

---

This should now be aligned with your new setup on EndeavourOS with i3wm!
