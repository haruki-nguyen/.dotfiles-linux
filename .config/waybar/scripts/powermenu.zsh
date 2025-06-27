#!/bin/bash

# Powermenu script for Waybar/Hyprland
# Provides a simple power menu using wofi

# Check if hibernation is supported
if grep -q 'disk' /sys/power/state; then
    # Define powermenu options with sleep
    options=(
        "Lock"
        "Logout"
        "Reboot"
        "Shutdown"
        "Sleep"
    )
else
    # Define powermenu options without sleep
    options=(
        "Lock"
        "Logout"
        "Reboot"
        "Shutdown"
    )
fi

# Show powermenu with wofi
action=$(printf "%s\n" "${options[@]}" | wofi --dmenu -i -p "Power Menu")

case "$action" in
    "Lock")
        hyprlock
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Sleep")
        # Only execute if hibernation is supported
        if grep -q 'disk' /sys/power/state; then
            hyprlock &
            sleep 0.5
            systemctl suspend
        else
            notify-send "Powermenu" "Sleep not supported" --icon=dialog-error
        fi
        ;;
    "")
        # Cancelled
        ;;
    *)
        notify-send "Powermenu" "Unknown option: $action" --icon=dialog-error
        ;;
esac 