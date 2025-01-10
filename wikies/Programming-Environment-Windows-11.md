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
- `neovim`.
- `python`.
- `espanso`: text expander.
- `yt-dlp`, `ffmpeg`: for downloading videos from YouTube.
- `z`: z directory jumper for Powershell.
- `7zip`.
- `vlc`.
- `lf`.
- `notion`.
- `obs-studio`.
- `openshot`.
- `nodejs` (for insatlling git conventional message utilities).
- Doom Emacs dependencies:
  - `emacs`.
  - `ripgrep`.
  - Install GNU finds (aka `findutils`) on <https://sourceforge.net/projects/gnuwin32/files/findutils/>.
  - `fd`.
  - `pandoc`.
  - `cmake` and `make`.

After installing, run `doom sync` again to ensure Doom Emacs recognizes the changes.

- Can be installed with installer on the official websites:
  - Microsoft PowerToys.
  - Everything search.

```powershell
choco install git neovim python espanso yt-dlp ffmpeg 7zip.install vlc lf notion obs-studio openshot nodejs emacs ripgrep fd pandoc cmake make -y
Install-Module -Name z
```

> Follow this guide to install Doom Emacs: <https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org#install>
> Currently, I'm using Spacemacs, because Doom Emacs is getting error while installing it, read this doc for Spacemacs installation: <https://github.com/syl20bnr/spacemacs/blob/master/README.md#windows>.

## Add ENV

Set these key-value pairs to ENV:

- EDITOR: "nvim"
- PATH: C:\Users\nmdex\AppData\Roaming\Python\Python{xxx}\Scripts"
 (xxx is the x.xx version of Python).

## Set Up other Softwares

- Run `espanso edit` to update Espanso config.
- Run `nvim $profile` to update Powershell scripts.
- Other configs can be found in the settings.
