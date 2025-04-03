# INSTALL DEPENDENCIES
# Install Powershell and Windows Terminal from Microsoft Store
# Install JetBrainsMono Nerd Font from https://www.nerdfonts.com/font-downloads
# Open Windows Terminal with Administrator Privileges
# And then set JetBrainsMono Nerd Font as the font for Windows Terminal

# Install Scoop pkg manager
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install softwares
scoop install git
# Add extras bucket
scoop bucket add extras
# `nodejs`, `python`: to install dependencies for Neovim using Lazy package manager
# `ripgrep`, `mingw`: NvChad' dependencies
# `llvm`: get `clang` to installing packages for Treesitter in Neovim
# `ffmpeg`: dependency of `yt-dlp`
# `fzf`: fuzzy finder
# `mactype-np`: get macOS font render

# Add scoop nonportable bucket
scoop add nonportable

scoop install obsidian flow-launcher everything firefox powertoys neovim nodejs ripgrep mingw python espanso llvm yt-dlp ffmpeg notion obs-studio gitleaks discord draw.io gh wget fzf vscode freecad oh-my-posh mactype-np windirstat

# SET UP CONFIGS
# Set location to HOME to clone repositories
Set-Location ~

# Set up SSH for GitHub
$email = "nmd03pvt@gmail.com"
ssh-keygen -t ed25519 -C "$email"
Get-Service -Name ssh-agent | Set-Service -StartupType manual
Start-Service ssh-agent
ssh-add C:\Users\$env:USERNAME\.ssh\id_ed25519
Get-Content ~/.ssh/id_ed25519.pub | clip
Write-Host "Copied the content of ~/.ssh/id_ed25519.pub to the clipboard, please add it to your GitHub account on this page: https://github.com/settings/keys"
Write-Host "Please update the remote URL to SSH: ``git remote set-url origin <URL>``."

# Install Z directory jumper
Install-Module -Name z -Force

# Softwares to install from the official websites/installer that I stored in my Data center
# 1. 7zip
# 2. Google Drive
# 3. Zalo
# 4. Unikey (Place it in ~\Documents\Programs\)
# 5. ProtonVPN
# 6. MBLAB X IDE
# 7. VLC
# 8. Microsoft 365 and Office (https://account.microsoft.com/services)
# 9. Syncthing
# 10. Microsoft PC Manager
# 11. Visual Studio (For editing Espanso with Neovim): Install "Desktop development with C++" in Visual Studio Installer.
# 12. Proteus: installer is on "C:\Users\nmdex\Documents\Data\Large Data\Softwares\Proteus 8.17 SP2 Pro.zip".
# 13. PSIM
# 14. GnuWin32: for Neovim (https://sourceforge.net/projects/gnuwin32/)
# 15. Battery Percentage - Pure Battery add-on (from Microsoft Store)
# 16. CP2102 USB to UART bridge driver for Windows 11: for ESP32 with CP2102 chip development
# 17. PDFgear
# 18. Google Quick Share
# 19. PICkit 2 from Microchip (for programming PIC)

# Set up Git for Data center
Set-Location "C:\Users\nmdex\Documents\Data"
git remote set-url origin git@github.com:haruki-nguyen/Data.git
Set-Location ~

# Set up .dotfiles
git clone git@github.com:haruki-nguyen/.dotfiles.git ~

# Set up Powershell configs
Write-Host "Setting up Powershell configs..."
New-Item -ItemType SymbolicLink -Path "$ENV:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$ENV:USERPROFILE\.dotfiles\powershell-configs.ps1"
Write-Host "Finish setting up NvChad"

# Set up NvChad
Write-Host "Setting up NvChad..."
New-Item -ItemType SymbolicLink -Path "$ENV:USERPROFILE\AppData\Local\nvim" -Target "$ENV:USERPROFILE\.dotfiles\.config\nvim"
Write-Host "Finish setting up NvChad"

# Setup Espanso
Write-Host "Setting up Espanso..."
## Set Espanso as a startup app
espansod service register
## Set up Espanso configs
New-Item -ItemType SymbolicLink -Path "$ENV:USERPROFILE\scoop\persist\espanso\.espanso" -Target "$ENV:USERPROFILE\.dotfiles\.config\espanso"
Write-Host "Finish setting up Espanso"

# Set up email and name for Git
Write-Host "Setting up Git..."
Remove-Item "$ENV:USERPROFILE\.gitconfig"
New-Item -ItemType SymbolicLink -Path  "$ENV:USERPROFILE\.gitconfig" -Target  "$ENV:USERPROFILE\.dotfiles\.gitconfig"
Write-Host "Finish setting up Git"

# Set up PlatformIO for IoT development
Write-Host "Setting up ENV in Path for PlatformIO..."
[System.Environment]::SetEnvironmentVariable("Path", $ENV:Path + ";$ENV:USERPROFILE\.platformio\penv\Scripts\", [System.EnvironmentVariableTarget]::User)
Write-Host "Finish setting up ENV in Path for PlatformIO."

# Add ENV variables for the default text editor
Write-Host "Add ENV variables for the default text editor..."
[System.Environment]::SetEnvironmentVariable("EDITOR", "code", [System.EnvironmentVariableTarget]::User)
Write-Host "Add ENV variables for the default text editor."

# Create Projects folder
Write-Host "Create Projects folder..."
New-Item -ItemType Directory -Path Projects
Write-Host "Finish creating Projects folder."

# ADDITIONAL STEPS
# Enable hibernate the machine through Powershell command: `shutdown.exe /h`
powercfg.exe /hibernate on

# Softwares to update configs manually
# 1. Windows Terminal
# 2. FlowLauncher
# 3. PowerToys
# 4. MBLAB X IDE

# Update power plan in Control Panel > Power Options
# Low level: 20%
# Reserve level: 15%
# Critical level: 10%

# Update Windows settings for developers in System > For developers

# Add additional features: Wireless Display

# You can set the default text editor for any file types with its link: $ENV:USERPROFILE\scoop\apps\<app name>\current\executable-file-path.exe

# Install Banana cursor: https://github.com/ful1e5/banana-cursor and create themes for it

