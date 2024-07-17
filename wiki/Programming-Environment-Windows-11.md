# Setting Up Programming Environments on Windows 11

> Install Powershell on [https://github.com/PowerShell/PowerShell/releases/](https://github.com/PowerShell/PowerShell/releases/).
> Note that Powershell must be run in Administrator mode.

## Installations

First, install Chocolatey package manager for Windows:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Secondly, install these packages with Chocolatey:

- `arduino-cli`.
- `kate`: a text editor. 
- `git`.
- `pandoc`: for using with Obsidian.
- `python`: for using some scripts with Python on Windows.

```powershell
choco install arduino-cli kate git pandoc python --pre
```

## Set Up SSH Key for Using GitHub

Enter this script into the Powershell:

```powershell
ssh-keygen -t ed25519 -C "your_email@example.com"

# start the ssh-agent in the background
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent

ssh-add c:/Users/YOU/.ssh/id_ed25519
```

Then add the SSH key into your GitHub account: <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?platform=windows>.

Finally, update the remote URL: `git remote set-url origin <URL>`.
