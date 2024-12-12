# Imports
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

# Functions
Function refreshShell { . $PROFILE }

# Aliases
Set-Alias -Name refsh -Value refreshShell

# Add PATH
$env:EDITOR += "nvim"

