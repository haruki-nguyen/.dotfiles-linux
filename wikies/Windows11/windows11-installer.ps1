# Install Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install software via Scoop
scoop install git neovim python espanso yt-dlp ffmpeg lf notion obs-studio openshot nodejs firefox flow-launcher kicad autohotkey super-productivity gitleaks session discord draw.io

# Install Z directory jumper
Install-Module -Name z -Force

# Set Espanso as a startup app
espansod service register

# Add ENV variables
[System.Environment]::SetEnvironmentVariable("EDITOR", "C:\Users\nmdex\AppData\Local\Programs\Microsoft VS Code\Code.exe", [System.EnvironmentVariableTarget]::User)
$pythonScriptsPath = "C:\Users\nmdex\AppData\Roaming\Python\Python{xxx}\Scripts"
$platformioPath = "C:\Users\nmdex\.platformio\penv\Scripts"
$envPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("PATH", "$envPath;$pythonScriptsPath;$platformioPath", [System.EnvironmentVariableTarget]::User)

# Set up SSH for GitHub
$email = "nmd03pvt@gmail.com"
ssh-keygen -t ed25519 -C "$email"
Get-Service -Name ssh-agent | Set-Service -StartupType manual
Start-Service ssh-agent
ssh-add C:\Users\$env:USERNAME\.ssh\id_ed25519
Write-Host "Please update the remote URL to SSH: ``git remote set-url origin <URL>``."

Write-Host "Setup complete! Please add your SSH key to GitHub and configure Espanso, Neovim, and other tools manually."
