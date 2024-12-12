# Setting Up Programming Environments on Windows 11

> Install Powershell on [https://github.com/PowerShell/PowerShell/releases/](https://github.com/PowerShell/PowerShell/releases/).
> Note that Powershell must be run in Administrator mode.
> Environment variables to set: `EDITOR="nvim"`

## Installations

First, install Chocolatey package manager for Windows:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Secondly, install these softwares:

- `git`.
- `neovim` and dependencies for NvChad:
    - `ripgrep`.
    - `mingw`.
    - `gnuwin32`: download from <https://sourceforge.net/projects/gnuwin32>.
    - `nodejs`.
- `python`.
- `espanso`: text expander.
- Can be installed with installer on the official websites:
    - Microsoft PowerToys.
    - Everything search.

```powershell
choco install git neovim ripgrep mingw nodejs choco python espanso -y
```

## Set up NvChad

```powershell
git clone https://github.com/NvChad/starter $ENV:USERPROFILE\AppData\Local\nvim && nvim
```

Run `:MasonInstallAll` and `:Lazy sync`, then delete `.git` folder:

```bash
rm -r -Force $ENV:USERPROFILE\AppData\Local\nvim\.git
```

