# Manjaro with KDE Plasma Setup

## Dependencies

- `yay`.
- `google-chrome`.
- `obsidian`.
- `syncthing`.
- `moneymanagerex`.
- `neovim`, with dependencies:
  - `ripgrep`.
  - `fd`.
  - `python3.10-venv`.
- `nodejs` and `npm` (for installing `prettier` in `mason` in `neovim`).
- `tmux`.
- `zip` and `unzip`.
- `kitty`.
- `starship`.
- `gitui` with dependency is `cargo`.
- `signal`.
- `ibus` and `ibus-unikey` for Telex typing method.
- StayFree Desktop.
- Install with Manjaro Hello:
    - LibreOffice.
    - `fcitx`
- `dos2unix`.
- `btop`.

## Basic System Setup

- Global theme: Otto.
- Turn on Night light feature with 3000K of light temperature.
- Remember to set up the touch pad scrolling direction to "Natural scrolling".

## Installation

- Install a Nerd Font from <https://github.com/ryanoasis/nerd-fonts/releases>.

```bash
# Download the font archive
wget https://github.com/ryanoasis/nerd-fonts/releases/download/[vX.X.X]/JetBrainsMono.zip

# Unzip the archive
unzip JetBrainsMono.zip -d JetBrainsMono

# Move the font files to your fonts directory
mkdir ~/.local/share/fonts/
mkdir ~/.local/share/fonts/JetBrainsMono
mv JetBrainsMono/*.ttf ~/.local/share/fonts/JetBrainsMono

# Rebuild the font cache
fc-cache -fv
```

- YAY.

```bash
sudo pacman -S --needed git base-devel yay
```

Then use `yay` to install other packages:

```bash
yay -S google-chrome obsidian syncthing moneymanagerex neovim ripgrep fd python3.10-venv tmux zip unzip nodejs npm signal ibus ibus-unikey dos2unix btop
```

- Install Starship.

```bash
curl -sS https://starship.rs/install.sh | sh
```

## Setup

- GitHub SSH.

  - Setting up SSH key on your device.

    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```

  - Then add the SSH key to your GitHub account: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux>.
  - Update the remote URL: `git remote set-url origin <URL>`.

- Install the repository: `git clone git@github.com:haruki-nguyen/.dotfiles.git`.

- Git: `ln -s ~/.dotfiles/configs/git/.gitconfig ~/`.

- Bash.

  ```bash
  echo -e "\nsource ~/.dotfiles/configs/bash/bashrc_custom.sh" >> ~/.bashrc
  source ~/.bashrc
  ```

- Kitty

```bash
rm -r ~/.config/kitty
ln -s ~/.dotfiles/configs/terminals/kitty/ ~/.config/
```

- Neovim.

  - Install NvChad.

    ```bash
    git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
    ```

    Run `:MasonInstallAll` and `:Lazy sync`, then run:

    ```bash
    rm -rf ~/.config/nvim/.git
    ```

  - Setup my custom NvChad configs:

    ```bash
    rm -rf ~/.config/nvim/lua
    ln -s ~/.dotfiles/configs/nvim/ ~/.config/nvim/lua
    ```

- Tmux.

  - Install Tmux Plugin Manager:

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

    ```bash
    mkdir ~/.config/tmux
    ln -s ~/.dotfiles/configs/tmux/tmux.conf ~/.config/tmux
    ```

  - Then reload Tmux with `tmux source ~/.config/tmux/tmux.conf` and install the plugins with `<prefix> + I`.

- GitUI.

  ```bash
  rm -rf ~/.config/gitui
  ln -s ~/.dotfiles/configs/gitui ~/.config
  ```

- StayFree Desktop.

```bash
#!/bin/bash

# Download StayFree AppImage
wget -O ~/Downloads/stayfree-linux-x86_64.AppImage https://github.com/stayfree-app/desktop-releases/releases/latest/download/stayfree-linux-x86_64.AppImage

# Make the AppImage executable
chmod +x ~/Downloads/stayfree-linux-x86_64.AppImage

# Create a directory for AppImages
mkdir -p ~/AppImages

# Move the AppImage to the AppImages directory
mv ~/Downloads/stayfree-linux-x86_64.AppImage ~/AppImages/

# Create a symbolic link to the AppImage in /usr/local/bin
sudo ln -s ~/AppImages/stayfree-linux-x86_64.AppImage /usr/local/bin/stayfree

# Optionally, create a desktop entry for easy access from the application menu
echo "[Desktop Entry]
Name=StayFree
Exec=/usr/local/bin/stayfree
Icon=utilities-terminal
Type=Application
Categories=Utility;" | tee ~/.local/share/applications/stayfree.desktop

echo "Installation complete. You can now run StayFree by typing 'stayfree' in the terminal or from the application menu."
```

- Ibus

1. Restart your system after installing `ibus` and `ibus-unikey`, this will ensure that ibus starts with the system.
2. Open IBus Preferences: You can do this by running the following command in your terminal:

   ```bash
   ibus-setup
   ```
 
- BTOP

```bash
ln -s ~/.dotfiles/configs/btop/catppuccin-mocha.theme ~/.config/btop/themes
```

Then change the BTOP's configs in the UI.

