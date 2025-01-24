# Setting Up Programming Environments on Windows 11

> Install Powershell on [https://github.com/PowerShell/PowerShell/releases/](https://github.com/PowerShell/PowerShell/releases/).
> Note that Powershell must be run in Administrator mode.

## Installations

First, install Chocolatey package manager for Windows:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

First, install Scoop package manager for Windows:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

Secondly, install these softwares:

- `git`.
- `neovim`.
- `python`.
- `espanso`: text expander.
- `yt-dlp`, `ffmpeg`: for downloading videos from YouTube.
- `z`: z directory jumper for Powershell.
- `lf`.
- `notion`.
- `obs-studio`.
- `openshot`.
- `nodejs` (for insatlling git conventional message utilities).
- `firefox`.
- `flow-launcher`.
- `kicad`.
- `autohotkey`.
- `sharex`.
- Can be installed with installer on the official websites:
  - Microsoft PowerToys.
  - Everything search.

```powershell
scoop install git neovim python espanso yt-dlp ffmpeg lf notion obs-studio openshot nodejs firefox flow-launcher kicad autohotkey sharex
Install-Module -Name z
```

## Startup Apps

Set Espanso as startup app:

```powershell
espansod service register
```

## Add ENV

Set these key-value pairs to ENV:

- EDITOR: "C:\Users\nmdex\AppData\Local\Programs\Microsoft VS Code\Code.exe"
- PATH: C:\Users\nmdex\AppData\Roaming\Python\Python{xxx}\Scripts"
 (xxx is the x.xx version of Python).

## Set Up other Softwares

- Run `espanso edit` to update Espanso config.
- Run `nvim $profile` to update Powershell scripts.
- Other configs can be found in the settings.

## Set Up SSH for GitHub repositories

- Setting up SSH key on your device.

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
Get-Service -Name ssh-agent | Set-Service -StartupType manual
Start-Service ssh-agent
ssh-add c:/Users/YOU/.ssh/id_ed25519
```

- Then add the SSH key to your GitHub account: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>.
- Update the remote URL to SSH: `git remote set-url origin <URL>`.

