# INSTALL DEPENDENCIES
# Install Powershell and Windows Terminal from Microsoft Store
# Install JetBrainsMono Nerd Font from https://www.nerdfonts.com/font-downloads
# And then set JetBrainsMono Nerd Font as the font for Windows Terminal

# Install Scoop pkg manager
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install softwares
scoop install git
# Add extras bucket
scoop bucket add extras
# `nodejs`, `python`: to install dependencies for Neovim using Lazy package manager
# `ripgrep`, `mingw`: NvChad' dependencies,
# also note that I can use `mingw` as a compiler for C/C++
# `llvm`: get `clang` to installing packages for Treesitter in Neovim
# `ffmpeg`: dependency of `yt-dlp`
# `fzf`: fuzzy finder
scoop install obsidian flow-launcher everything firefox powertoys neovim nodejs ripgrep mingw python espanso llvm yt-dlp ffmpeg notion obs-studio gitleaks discord draw.io gh wget fzf

# SET UP CONFIGS
# Set up SSH for GitHub
$email = "nmd03pvt@gmail.com"
ssh-keygen -t ed25519 -C "$email"
Get-Service -Name ssh-agent | Set-Service -StartupType manual
Start-Service ssh-agent
ssh-add C:\Users\$env:USERNAME\.ssh\id_ed25519
cat ~/.ssh/id_ed25519.pub | clip
Write-Host "Copied the content of ~/.ssh/id_ed25519.pub to the clipboard, please add it to your GitHub account on this page: https://github.com/settings/keys"
Write-Host "Please update the remote URL to SSH: ``git remote set-url origin <URL>``."

# Install Z directory jumper
Install-Module -Name z -Force

# Add ENV variables
[System.Environment]::SetEnvironmentVariable("EDITOR", [System.EnvironmentVariableTarget]::User)

# Softwares to install from the official websites/installer that I stored in my Data center
# 1. 7zip
# 2. Google Drive
# 3. Zalo
# 4. Unikey (Place it in ~\Documents\Programs\)
# 5. ProtonVPN
# 6. MBLAB X IDE
# 7. VLC
# 8. Microsoft 365 and Office (https://account.microsoft.com/services)
# 9. Okular
# 10. Syncthing
# 11. Microsoft PC Manager
# 12. Visual Studio (For editing Espanso with Neovim): Install "Desktop development with C++" in Visual Studio Installer.
# 13. Proteus: installer is on "C:\Users\nmdex\Documents\Data\Large Data\Softwares\Proteus 8.17 SP2 Pro.zip".
# 14. PSIM
# 15. GnuWin32: for Neovim (https://sourceforge.net/projects/gnuwin32/)
# 16. Battery Percentage - Pure Battery add-on (from Microsoft Store)

# Set up Git for Data center
cd ~\Downloads\Data
git remote set-url origin git@github.com:haruki-nguyen/Data.git
cd -

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
Write-Host "Setting up PlatformIO..."
Write-Host "Downloading and installing PlatformIO..."
wget -P "$ENV:USERPROFILE\.dotfiles\" "https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py"
Write-Host "Finish downloading and installing PlatformIO."
Write-Host "Setting up ENV in Path for PlatformIO..."
[System.Environment]::SetEnvironmentVariable("Path", $ENV:Path + ";C:\Users\nmdex\.platformio\penv\Scripts\", [System.EnvironmentVariableTarget]::User)
Write-Host "Finish setting up ENV in Path for PlatformIO."

# Set up C/C++ compiler
Write-Host "Setting mingw to Path..."
[System.Environment]::SetEnvironmentVariable("Path", $ENV:Path + ";C:\Users\nmdex\scoop\apps\mingw\current\bin", [System.EnvironmentVariableTarget]::User)
Write-Host "Finishing setting mingw to Path."

# Create Projects folder
Write-Host "Create Projects folder..."
New-Item -ItemType Directory -Path Projects
Write-Host "Finish creating Projects folder."

# ADDITIONAL STEPS
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

# You can set Neovim as the default text editor for any file types with its link: C:\Users\nmdex\scoop\apps\neovim\current\bin\nvim.exe 

