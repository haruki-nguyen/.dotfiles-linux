# Setting up WSL2 on Windows 11

## Dependencies

- Installed by default: `git`.
- `neovim`, with dependencies:
  - `ripgrep`.
  - `fd`.
  - `python3.10-venv`.
- `tmux`.
- `zip`.
- `starship`.
- `gitui` with dependency is `cargo`.
- `ranger`.
- `nodejs` and `npm` (for installing `prettier` in `mason` in `neovim`).
- `poppler-utils`: for using `pdftotext` tool.

## Installation

```bash
# update the repo for neovim latest version
sudo add-apt-repository ppa:neovim-ppa/unstable

# install packages
sudo apt update && sudo apt upgrade && sudo apt install neovim tmux zip ranger ripgrep nodejs npm poppler-utils
```

```bash
# install starship
curl -sS https://starship.rs/install.sh | sh
```

## Setting up

- Install a Nerd font on Windows and set it as default font for the terminal: <https://www.nerdfonts.com/font-downloads>.

- Windows Terminal: copy the [Windows Terminal configs](../configs/windows-terminal/windows-terminal-settings.json) to Windows Terminal configs file.

- GitHub SSH.

  - Setting up SSH key on your device.

    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ```

  - Then on your GitHub account: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>.
  - Update remove URL: `git remote set-url origin <URL>`.

- Install the repository: `git clone git@github.com:haruki-nguyen/.dotfiles.git`.

- Git: `ln -s ~/.dotfiles/configs/git/.gitconfig ~/`.

- Bash.

  ```bash
  echo -e "\nsource ~/.dotfiles/configs/bash/bashrc_custom.sh" >> ~/.bashrc
  source ~/.bashrc
  ```

- Neovim.

  - Install NvChad.

    ```bash
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
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

- Starship

  ```bash
  ln -s ~/.dotfiles/configs/starship/starship.toml ~/.config
  ```

- GitUI.

  ```bash
  rm -rf ~/.config/gitui
  ln -s ~/.dotfiles/configs/gitui ~/.config
  ```

