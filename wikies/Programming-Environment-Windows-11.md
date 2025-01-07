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
- Can be installed with installer on the official websites:
    - Microsoft PowerToys.
    - Everything search.

```powershell
choco install git neovim python espanso yt-dlp ffmpeg 7zip.install vlc -y
Install-Module -Name z
```

## Set Up other Softwares

- Run `espanso edit` to update Espanso config.
- Run `nvim $profile` to update Powershell scripts.
- Other configs can be found in the settings.

