#!/bin/bash

# Sync wallpaper script
# This script syncs the current wallpaper from swww to hyprlock

# Get the current wallpaper from swww
current_wallpaper=$(swww query | grep "currently displaying:" | sed 's/.*currently displaying: image: //')

if [[ -n "$current_wallpaper" && -f "$current_wallpaper" ]]; then
    # Create the theme directory if it doesn't exist
    mkdir -p ~/.local/state/theme
    
    # Remove existing symlink or file
    rm -f ~/.local/state/theme/current_wallpaper
    
    # Copy the current wallpaper to the hyprlock location
    cp "$current_wallpaper" ~/.local/state/theme/current_wallpaper
    
    echo "Synced wallpaper: $(basename "$current_wallpaper")"
    notify-send "Wallpaper Sync" "Synced with hyprlock: $(basename "$current_wallpaper")" --icon=preferences-desktop-wallpaper
else
    echo "No wallpaper found or swww not running"
    notify-send "Wallpaper Sync" "No wallpaper found or swww not running" --icon=dialog-error
fi 