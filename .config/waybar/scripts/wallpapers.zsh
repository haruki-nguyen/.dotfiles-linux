#!/bin/bash

# Wallpapers script for Waybar
# This script provides wallpaper management functionality

WALLPAPER_DIR="$HOME/.dotfiles/wallpapers"

# Function to get wallpaper files
get_wallpapers() {
    if [[ -d "$WALLPAPER_DIR" ]]; then
        find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) 2>/dev/null
    fi
}

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    if [[ -f "$wallpaper" ]]; then
        # Try different wallpaper setters
        if command -v swww >/dev/null 2>&1; then
            swww img "$wallpaper" --transition-type wipe --transition-angle 30 --transition-step 90
        elif command -v feh >/dev/null 2>&1; then
            feh --bg-fill "$wallpaper"
        elif command -v nitrogen >/dev/null 2>&1; then
            nitrogen --set-zoom-fill "$wallpaper"
        elif command -v gsettings >/dev/null 2>&1; then
            gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper"
        else
            notify-send "Wallpaper" "No suitable wallpaper setter found" --icon=dialog-error
            return 1
        fi
        
        # Update the current wallpaper file for hyprlock
        mkdir -p ~/.local/state/theme
        cp "$wallpaper" ~/.local/state/theme/current_wallpaper
        
        notify-send "Wallpaper" "Set to $(basename "$wallpaper")" --icon=preferences-desktop-wallpaper
        return 0
    else
        notify-send "Wallpaper" "File not found: $wallpaper" --icon=dialog-error
        return 1
    fi
}

# Function to launch wallpaper picker
launch_wallpaper_picker() {
    # Use rofi for wallpaper selection if available
    if command -v rofi >/dev/null 2>&1; then
        get_wallpapers | rofi -dmenu -i -p "Select Wallpaper" | while read -r selected_wallpaper; do
            if [[ -n "$selected_wallpaper" ]]; then
                set_wallpaper "$selected_wallpaper"
            fi
        done
    elif command -v wofi >/dev/null 2>&1; then
        get_wallpapers | wofi --dmenu -i -p "Select Wallpaper" | while read -r selected_wallpaper; do
            if [[ -n "$selected_wallpaper" ]]; then
                set_wallpaper "$selected_wallpaper"
            fi
        done
    elif command -v dmenu >/dev/null 2>&1; then
        get_wallpapers | dmenu -i -p "Select Wallpaper" | while read -r selected_wallpaper; do
            if [[ -n "$selected_wallpaper" ]]; then
                set_wallpaper "$selected_wallpaper"
            fi
        done
    else
        # Fallback - open file manager to wallpaper directory
        if [[ -d "$WALLPAPER_DIR" ]]; then
            nautilus "$WALLPAPER_DIR" || thunar "$WALLPAPER_DIR" || dolphin "$WALLPAPER_DIR"
        else
            notify-send "Wallpaper" "No wallpaper directory found" --icon=dialog-error
        fi
    fi
}

# Check if this is a click event
if [[ "$1" == "click" ]]; then
    launch_wallpaper_picker
    exit 0
fi

# Output JSON for Waybar
echo "{\"text\": \"󰉏 Wallpapers\", \"class\": \"custom-wallpapers\"}" 