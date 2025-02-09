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
- `gitleaks`.

## Installation

Download the [installer](./ubuntu-installer.sh) and run it.

1. **Save the Script**: Save the script to a file, e.g., `ubuntu-installer.sh`.
2. **Make the Script Executable**: Run `chmod +x ubuntu-installer.sh` to make the script executable.
3. **Run the Script**: Execute the script by running `./ubuntu-installer.sh`.

### Notes

- **Manual Steps**: Some steps, like installing a Nerd font and adding the SSH key to GitHub, require manual intervention. The script will prompt you when these steps are needed.
- **Neovim Setup**: After cloning the NvChad starter config, you will need to manually run `:MasonInstallAll` and `:Lazy sync` within Neovim.
- **Tmux Plugins**: After sourcing the Tmux configuration, you will need to manually install the plugins using `<prefix> + I` (where `<prefix>` is usually `Ctrl + b`).
- Replace `GITLEAKS_VERSION="vx.xx.x"` to the corrected version.
- Open neovim and run `:MasonInstallAll` to finish setting up NvChad.

