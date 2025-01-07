# IMPORTS
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

# UPDATE SYSTEM
# Define paths to git repositories
$projectPaths = @("C:\Users\nmdex\Documents\IoT-irrigation-system")

function Git-PullAll {
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
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Updating system with Chocolatey..."
        choco upgrade all -y

        Write-Host "Updating PowerShell modules from Gallery..."
        Get-InstalledModule | Update-Module

        Write-Host "Pulling updates from the repositories"
        Git-PullAll
        Write-Host "Done!"
    } else {
        Write-Host "Chocolatey not installed. Install it first: https://chocolatey.org/install"
    }
}

# ALIASES
Set-Alias -Name py -Value python

# ADD ENV
$env:EDITOR = "nvim"
$env:PATH += ";C:\Users\nmdex\AppData\Roaming\Python\Python313\Scripts"
