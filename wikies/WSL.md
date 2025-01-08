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
- `nodejs` and `npm` (for installing `prettier` in `mason` in `neovim`).
- `nvm`: node version manager.
- `poppler-utils`: for using `pdftotext` tool.
- `gdb`: for C debugging.
- `gitui`.
- `cz-git` and `commitizen`: for conventional commit messages.
- `ranger`.

## Installation

```bash
# update the repo for neovim latest version
sudo add-apt-repository ppa:neovim-ppa/unstable

# install packages
sudo apt update && sudo apt upgrade && sudo apt install neovim tmux zip ripgrep nodejs npm poppler-utils gdb ranger

# install gitui
sudo apt install cargo && cargo install gitui --locked

# install cz-git and commitizen
npm i -g cz-git commitizen

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

  - Then add the SSH key to your GitHub account: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=linux>.
  - Update the remote URL: `git remote set-url origin <URL>`.

- Install the repository: `git clone git@github.com:haruki-nguyen/.dotfiles.git`.

- Git: `ln -s ~/.dotfiles/configs/git/.gitconfig ~/`.

- Bash.

  ```bash
  echo -e "\nsource ~/.dotfiles/configs/bash/bashrc_custom.sh" >> ~/.bashrc
  source ~/.bashrc
  ```

- Neovim: Install NvChad.

    ```bash
    git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
    ```

    Run `:MasonInstallAll` and `:Lazy sync`, then delete `.git` folder:

    ```bash
    rm -rf ~/.config/nvim/.git
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

- GitUI

  ```bash
  ln -s ~/.dotfiles/configs/gitui/ ~/.config/
  ```

- cz-git:

  ```bash
  ln -s ~/.dotfiles/configs/cz-git/.czrc ~/
  ```
