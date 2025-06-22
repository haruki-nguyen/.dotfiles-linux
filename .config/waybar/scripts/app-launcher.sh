#!/bin/bash

# App launcher script for Waybar
# This script provides a simple app launcher interface using wofi

# Function to get installed applications
get_apps() {
    # Get desktop files from standard locations
    find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | \
    while read -r desktop_file; do
        # Extract app name and icon
        name=$(grep "^Name=" "$desktop_file" | cut -d'=' -f2 | head -1)
        icon=$(grep "^Icon=" "$desktop_file" | cut -d'=' -f2 | head -1)
        exec_cmd=$(grep "^Exec=" "$desktop_file" | cut -d'=' -f2 | head -1)
        
        if [[ -n "$name" && -n "$exec_cmd" ]]; then
            echo "$name|$icon|$exec_cmd"
        fi
    done | sort -u
}

# Function to launch app launcher
launch_app_launcher() {
    # Use wofi for app launcher (Wayland-native)
    if command -v wofi >/dev/null 2>&1; then
        wofi --show drun --prompt "Launch application..."
    elif command -v dmenu >/dev/null 2>&1; then
        # Fallback to dmenu with app list
        get_apps | cut -d'|' -f1 | dmenu -i | while read -r selected_app; do
            exec_cmd=$(get_apps | grep "^$selected_app|" | cut -d'|' -f3)
            if [[ -n "$exec_cmd" ]]; then
                eval "$exec_cmd" &
            fi
        done
    else
        # Final fallback - open applications menu
        gtk-launch org.gnome.Software || gtk-launch gnome-software || \
        notify-send "App Launcher" "No suitable launcher found" --icon=dialog-error
    fi
}

# Check if this is a click event
if [[ "$1" == "click" ]]; then
    launch_app_launcher
    exit 0
fi

# Output JSON for Waybar
echo "{\"text\": \"󰎚 Apps\", \"class\": \"custom-app-launcher\"}" 