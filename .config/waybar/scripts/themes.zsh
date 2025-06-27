#!/bin/bash

# Themes script for Waybar
# This script provides theme management functionality

# Function to get available GTK themes
get_gtk_themes() {
    find /usr/share/themes ~/.themes -maxdepth 1 -type d 2>/dev/null | \
    while read -r theme_dir; do
        theme_name=$(basename "$theme_dir")
        if [[ -f "$theme_dir/index.theme" ]] || [[ -f "$theme_dir/gtk-3.0/gtk.css" ]]; then
            echo "$theme_name"
        fi
    done | sort -u
}

# Function to get available icon themes
get_icon_themes() {
    find /usr/share/icons ~/.icons -maxdepth 1 -type d 2>/dev/null | \
    while read -r icon_dir; do
        icon_name=$(basename "$icon_dir")
        if [[ -f "$icon_dir/index.theme" ]]; then
            echo "$icon_name"
        fi
    done | sort -u
}

# Function to set GTK theme
set_gtk_theme() {
    local theme="$1"
    
    if [[ -n "$theme" ]]; then
        # Set GTK theme
        gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null || \
        gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null || \
        echo "export GTK_THEME=$theme" >> ~/.profile
        
        # Set GTK2 theme if possible
        if [[ -f ~/.gtkrc-2.0 ]]; then
            sed -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$theme\"/" ~/.gtkrc-2.0
        fi
        
        notify-send "Theme" "GTK theme set to $theme" --icon=preferences-desktop-theme
    fi
}

# Function to set icon theme
set_icon_theme() {
    local icon_theme="$1"
    
    if [[ -n "$icon_theme" ]]; then
        gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null || \
        echo "export GTK_ICON_THEME=$icon_theme" >> ~/.profile
        
        notify-send "Theme" "Icon theme set to $icon_theme" --icon=preferences-desktop-theme
    fi
}

# Function to launch theme picker
launch_theme_picker() {
    # Create a simple theme selection menu
    local themes
    readarray -t themes < <(get_gtk_themes)
    
    if [[ ${#themes[@]} -eq 0 ]]; then
        notify-send "Themes" "No themes found" --icon=dialog-error
        return 1
    fi
    
    # Use rofi for theme selection if available
    if command -v rofi >/dev/null 2>&1; then
        printf '%s\n' "${themes[@]}" | rofi -dmenu -i -p "Select GTK Theme" | while read -r selected_theme; do
            if [[ -n "$selected_theme" ]]; then
                set_gtk_theme "$selected_theme"
            fi
        done
    elif command -v wofi >/dev/null 2>&1; then
        printf '%s\n' "${themes[@]}" | wofi --dmenu -i -p "Select GTK Theme" | while read -r selected_theme; do
            if [[ -n "$selected_theme" ]]; then
                set_gtk_theme "$selected_theme"
            fi
        done
    elif command -v dmenu >/dev/null 2>&1; then
        printf '%s\n' "${themes[@]}" | dmenu -i -p "Select GTK Theme" | while read -r selected_theme; do
            if [[ -n "$selected_theme" ]]; then
                set_gtk_theme "$selected_theme"
            fi
        done
    else
        # Fallback - show theme list in terminal
        echo "Available GTK themes:"
        printf '%s\n' "${themes[@]}"
        echo
        echo "To set a theme, run: gsettings set org.gnome.desktop.interface gtk-theme 'THEME_NAME'"
    fi
}

# Function to launch icon theme picker
launch_icon_theme_picker() {
    local icon_themes
    readarray -t icon_themes < <(get_icon_themes)
    
    if [[ ${#icon_themes[@]} -eq 0 ]]; then
        notify-send "Themes" "No icon themes found" --icon=dialog-error
        return 1
    fi
    
    # Use rofi for icon theme selection if available
    if command -v rofi >/dev/null 2>&1; then
        printf '%s\n' "${icon_themes[@]}" | rofi -dmenu -i -p "Select Icon Theme" | while read -r selected_icon_theme; do
            if [[ -n "$selected_icon_theme" ]]; then
                set_icon_theme "$selected_icon_theme"
            fi
        done
    elif command -v wofi >/dev/null 2>&1; then
        printf '%s\n' "${icon_themes[@]}" | wofi --dmenu -i -p "Select Icon Theme" | while read -r selected_icon_theme; do
            if [[ -n "$selected_icon_theme" ]]; then
                set_icon_theme "$selected_icon_theme"
            fi
        done
    elif command -v dmenu >/dev/null 2>&1; then
        printf '%s\n' "${icon_themes[@]}" | dmenu -i -p "Select Icon Theme" | while read -r selected_icon_theme; do
            if [[ -n "$selected_icon_theme" ]]; then
                set_icon_theme "$selected_icon_theme"
            fi
        done
    else
        # Fallback - show icon theme list in terminal
        echo "Available icon themes:"
        printf '%s\n' "${icon_themes[@]}"
        echo
        echo "To set an icon theme, run: gsettings set org.gnome.desktop.interface icon-theme 'ICON_THEME_NAME'"
    fi
}

# Check if this is a click event
if [[ "$1" == "click" ]]; then
    # Show theme options
    if command -v rofi >/dev/null 2>&1; then
        echo -e "GTK Theme\nIcon Theme" | rofi -dmenu -i -p "Theme Options" | while read -r option; do
            case "$option" in
                "GTK Theme")
                    launch_theme_picker
                    ;;
                "Icon Theme")
                    launch_icon_theme_picker
                    ;;
            esac
        done
    elif command -v wofi >/dev/null 2>&1; then
        echo -e "GTK Theme\nIcon Theme" | wofi --dmenu -i -p "Theme Options" | while read -r option; do
            case "$option" in
                "GTK Theme")
                    launch_theme_picker
                    ;;
                "Icon Theme")
                    launch_icon_theme_picker
                    ;;
            esac
        done
    else
        # Fallback - just launch GTK theme picker
        launch_theme_picker
    fi
    exit 0
fi

# Output JSON for Waybar
echo "{\"text\": \"󰃭 Themes\", \"class\": \"custom-themes\"}" 