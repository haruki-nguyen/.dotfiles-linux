# EndeavourOS with GNOME.

First, update the GNOME's settings.

## Dependencies

- Installed by default:
  - `firefox`.
  - `git`.
- `gnome-terminal`
- `neovim`, with dependencies:
  - `ripgrep`.
  - `fd`.
  - `xclip`: enable the usage of system clipboard.
- `visual-studio-code-bin`.
- `tmux`.
- `zip`.
- `starship`.
- `gitui`.
- `gnome-browser-connector`: for installing GNOME Shell extensions.
- `sassc`: for installing WhiteSur GTK theme.
- `bibata-cursor-theme`: a cursor theme.
- `btop`.
- `syncthing`.
- `ibus-unikey`: add Telex input method.
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
sudo pacman -S neovim tmux zip starship gitui gnome-browser-connector sassc inkscape gimp gnome-terminal btop syncthing ibus-unikey xclip fd libreoffice-fresh nodejs npm ripgrep noto-fonts-emoji foliate wine
```

```bash
yay -S visual-studio-code-bin bibata-cursor-theme tradingview
```

## Setting up

- Install the repository: `git clone https://github.com/haruki-nguyen/.dotfiles.git ~/.dotfiles`.

- First, install a Nerd font on <https://www.nerdfonts.com/font-downloads> to `/usr/share/fonts/` and set it up for the terminal emulator. For example: Iosevka.

- Then, setting up emoji font: `fc-cache -fv`, this command will rebuild the font cache.

- GNOME Terminal.

  - Install Catppuccin theme:

  ```bash
  curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -
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
    - GNOME Shell integration: for installing GNOME Shell extensions.

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

- WhiteSur GTK theme for GNOME.

  - Required GNOME Shell extensions:
    - [`user-themes`](https://extensions.gnome.org/extension/19/user-themes/).
    - [`dash-to-dock`](https://extensions.gnome.org/extension/307/dash-to-dock/).
    - [`blur-my-shell`](https://extensions.gnome.org/extension/3193/blur-my-shell/).
    - [`rounded-window-cornors`](https://extensions.gnome.org/extension/5237/rounded-window-corners/).
  - Setting up:

    - Setting up window, GDM, and Firefox themes:

    ```bash
    cd ~/Downloads/ && git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
    cd WhiteSur-gtk-theme/
    ./install.sh -c 'Dark' -i 'arch' -b ~/'.dotfiles/configs/wallpapers/waves-dark.jpg' -m -l
    sudo ./tweaks.sh -g -N -b ~/'.dotfiles/configs/wallpapers/waves-dark.jpg'
    ./tweaks.sh -f
    cd .. && rm -rf WhiteSur-gtk-theme
    ```

    - Setting up icon themes:

    ```bash
    cd ~/Downloads/ && git clone https://github.com/vinceliuice/WhiteSur-icon-theme
    cd WhiteSur-icon-theme/
    ./install.sh -b
    cd .. && rm -rf WhiteSur-icon-theme
    ```

    - Then update all themes and fonts in GNOME Tweaks tool.

- Btop.

  ```bash
  rm ~/.config/btop
  ln -s ~/.dotfiles/configs/btop ~/.config
  ```

- Telex input method.

  - First, add these line into `/etc/environment`:

    ```txt
    # ENVs for Ibus to work
    GTK_IM_MODULE=ibus
    QT_IM_MODULE=ibus
    XMODIFIERS=@im=ibus
    ```

  - Then set the Telex input method in the setting after re-login.

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
