# EndeavourOS with GNOME.

First, update the GNOME's settings.

## Dependencies

- `kitty`.
- `nodejs`.
- `npm`.
- `pnpm`.
- `neovim`.
- `tmux`.
- `zip`.
- `starship`.
- `gitui`.

## Installation

```bash
sudo pacman -S kitty nodejs npm neovim tmux zip starship gitui
```

Install `pnpm`:

```bash
sudo npm i -g pnpm
pnpm setup
source ~/.bashrc
```

## Setting up

- Kitty.

  - First, install a Nerd font on <https://www.nerdfonts.com/font-downloads> to `/usr/share/fonts/`. For example: Iosevka.
  - Then, setting up the configs:

    ```bash
    rm -rf ~/.config/kitty/
    ln -s ~/.dotfiles/configs/kitty/ ~/.config/
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

- Firefox (installed by default)

  - Login to sync Bookmarks, Settings, and Add-ons.
  - Setting up add-ons:
    - Dark Reader.
    - Simple Translate.
    - DuckDuckGo Privacy Essentials.
    - React Developer Tools.
  - Themes: [Catppuccin](https://github.com/catppuccin/firefox).

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
