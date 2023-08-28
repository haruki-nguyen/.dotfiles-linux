# EndeavourOS with Hyprland.

## Dependencies

- Installed by default:
  - `firefox`.
  - `git`.
  - `grub`.
- `hyprland`.
- `sddm` and its dependencies:
  - `qt5-quickcontrols2`.
  - `qt5-svg`.
  - `qt5-graphicaleffects`.
- `kitty`.
- `ranger`.
- `neovim`, with dependencies:
  - `ripgrep`.
  - `fd`.
  - `xclip`: enable the usage of system clipboard.
- `visual-studio-code-bin`.
- `tmux`.
- `zip`.
- `starship`.
- `gitui`.
- `btop`.
- `syncthing`.
- `inkscape`: vector graphic editor.
- `gimp`: GNU Image Manipulation Program.
- `libreoffice-fresh`.
- `nodejs` and `npm` (for installing `prettier` in `mason` in `neovim`).
- `foliate`: ebooks reader.
- `wine`: for running Windows application.
- MetaTraders 5.
- TradingView.
- `noto-fonts-emoji`.

## Installation

```bash
sudo pacman -S hyprland sddm qt5-quickcontrols2 qt5-svg qt5-graphicaleffects kitty ranger neovim ripgrep fd xclip tmux zip starship gitui btop syncthing inkscape gimp libreoffice-fresh nodejs npm foliate wine noto-fonts-emoji
```

```bash
yay -S visual-studio-code-bin tradingview
```

## Setting up

- Install the repository: `git clone https://github.com/haruki-nguyen/.dotfiles.git ~/.dotfiles`.

- First, install a Nerd font on <https://www.nerdfonts.com/font-downloads> to `/usr/share/fonts/` and set it up for the terminal emulator. For example: Iosevka.

  ```bash
  cd ~/Downloads && wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Iosevka.zip" -O Iosevka.zip
  sudo unzip Iosevka.zip -d /usr/share/fonts/Iosevka
  rm Iosevka.zip && cd -
  ```

- Then, setting up emoji font: `fc-cache -fv`, this command will rebuild the font cache.

- Kitty

  ```bash
  rm -rf ~/.config/kitty/
  ln -s ~/.dotfiles/configs/kitty/ ~/.config/
  ```

- Hyprland

  ```bash
  rm -rf ~/.config/hypr/
  ln -s ~/.dotfiles/configs/hypr/ ~/.config/
  ```

- SDDM

  Download the `sugar-dark` theme file from <https://www.opendesktop.org/p/1272122> to `~/Downloads/`.

  ```bash
  sudo systemctl enable sddm.service
  sudo tar -xzvf ~/Downloads/sugar-dark.tar.tar -C /usr/share/sddm/themes
  sudo mkdir /etc/sddm.conf.d
  sudo cp ~/.dotfiles/configs/sddm/sddm.conf /etc/sddm.conf.d/
  rm ~/Downloads/sugar-dark.tar.tar
  ```

- GRUB.

  ```bash
  sudo cp -r ~/.dotfiles/configs/grub/catppuccin-mocha-grub-theme/ /usr/share/grub/themes/
  ```

  Uncomment and edit following line in `/etc/default/grub` to selected theme:

  ```bash
  GRUB_THEME="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
  ```

  Update GRUB:

  ```bash
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  ```

- Ranger

  ```bash
  rm -rf ~/.config/ranger
  ln -s ~/.dotfiles/configs/ranger/ ~/.config/
  ```

- Tmux.

  - Install Tmux Plugin Manager:

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

    ```bash
    mkdir ~/.config/tmux
    ln -s ~/.dotfiles/configs/tmux.conf ~/.config/tmux
    ```

  - Then reload Tmux with `tmux source ~/.config/tmux/tmux.conf` and install the plugins with `<prefix> + I`.

- Neovim.

  - Install NvChad.

    ```bash
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
    ```

  - Setup my custom NvChad configs:

    ```bash
    rm -rf ~/.config/nvim/lua/custom/
    ln -s ~/.dotfiles/configs/neovim ~/.config/nvim/lua/custom
    ```

- Firefox:

  - Login to sync Bookmarks, Settings, and Add-ons.
  - Setting up add-ons:
    - Simple Translate.
    - DuckDuckGo Privacy Essentials.

- Starship

  ```bash
  ln -s ~/.dotfiles/configs/starship.toml ~/.config
  ```

- Bash.

  ```bash
  echo -e "\nsource ~/.dotfiles/configs/bash/bashrc_custom.sh" >> ~/.bashrc
  source ~/.bashrc
  ```

- Git.

  ```bash
  ln -s ~/.dotfiles/configs/.gitconfig ~/
  ```

- GitUI.

  ```bash
  rm -rf ~/.config/gitui
  ln -s ~/.dotfiles/configs/gitui ~/.config
  ```

- GitHub SSH.

  - Setting up SSH key on your device.

    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```

  - Then on your GitHub account: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>.
  - Update remove URL: `git remote set-url origin <URL>`.

- Btop.

  ```bash
  ln -s ~/.dotfiles/configs/btop ~/.config
  ```

- Foliate.

  ```bash
  ln -s ~/.dotfiles/configs/foliate ~/.config/com.github.johnfactotum.Foliate
  ```

- MetaTraders.

  ```bash
  cd ~/Downloads && wget "https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe?utm_source=web.installer&utm_campaign=mql5.welcome.open" -O mt5setup.exe
  wine mt5setup.exe
  ```

  After that, remove the setup file.
