# UPDATE SYSTEM
# Define paths to git repositories
$projectPaths = @("C:\Users\nmdex\Documents\Projects\IoT-irrigation-system")

function Get-RepoUpdates {
    foreach ($path in $projectPaths) {
        Write-Host "Going to $path"
        Set-Location -Path $path
        Write-Host "Pulling..."
        git pull
        Write-Host "Done!"
        Write-Host "Going back..."
        Set-Location -Path -
    }
}

function Update-System {
    # Check if Chocolatey and npm are available
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Updating system with Scoop..."
        scoop update *

        Write-Host "Updating PowerShell modules from Gallery..."
        Get-InstalledModule | Update-Module

        Write-Host "Pulling updates from the repositories"
        Get-RepoUpdates
        Write-Host "Done!"
    }
    else {
        Write-Host "Scoop isn't installed."
    }
}

# ALIASES
Set-Alias -Name open -Value explorer
Set-Alias -Name py -Value python
Set-Alias -Name t -Value New-Item

function Update-Profile {
    . $profile
}

Set-Alias -Name refresh -Value Update-Profile

# Git alias
function Invoke-GitStatus {
    git status
}

function Invoke-GitLog {
    git log --graph --oneline --decorate
}

function Invoke-GitAddAll {
    git add .
}

function Invoke-GitAdd {
    param(
        [string[]]$Paths
    )
    git add $Paths
}

function Invoke-GitCommit {
    git commit
}

function Invoke-GitPullRebase {
    git pull --rebase
}

function Invoke-GitSync {
    git pull --rebase
    git push
}
function Invoke-GitCommitizen {
    git cz
}

Set-Alias -Name gits -Value Invoke-GitStatus
Set-Alias -Name gitl -Value Invoke-GitLog
Set-Alias -Name gitaa -Value Invoke-GitAddAll
Set-Alias -Name gita -Value Invoke-GitAdd
Set-Alias -Name gitc -Value Invoke-GitCommit
Set-Alias -Name gitpr -Value Invoke-GitPullRebase
Set-Alias -Name gitsync -Value Invoke-GitSync
Set-Alias -Name gitcz -Value Invoke-GitCommitizen
