#!/usr/bin/env sh

# Get current brightness percentage
get_brightness() {
    brightnessctl info 2>/dev/null | grep -oP "(?<=\()\d+(?=%)" | cat
}

# Get brightness icon based on level
get_brightness_icon() {
    local brightness=$(get_brightness)
    
    # Handle case where brightnessctl fails
    if [ -z "$brightness" ]; then
        echo "󰃞"  # Default icon
        return
    fi
    
    if [ "$brightness" -ge 80 ]; then
        echo "󰃠"  # Full brightness
    elif [ "$brightness" -ge 60 ]; then
        echo "󰃟"  # High brightness
    elif [ "$brightness" -ge 40 ]; then
        echo "󰃞"  # Medium brightness
    elif [ "$brightness" -ge 20 ]; then
        echo "󰃝"  # Low brightness
    else
        echo "󰃜"  # Very low brightness
    fi
}

# Handle click events
if [ "$1" = "click" ]; then
    # Open brightness control (you can change this to your preferred method)
    # Option 1: Use a GUI brightness control if available
    # Option 2: Open terminal with brightnessctl
    # Option 3: Show a notification with current brightness
    notify-send "Brightness" "Current: $(get_brightness)%" -t 2000
    exit 0
fi

# Output JSON for Waybar
brightness=$(get_brightness)
icon=$(get_brightness_icon)

# Handle case where brightnessctl fails
if [ -z "$brightness" ]; then
    printf '{"text": "%s --", "tooltip": "Brightness: Unavailable", "class": "brightness"}\n' "$icon"
else
    printf '{"text": "%s %s%%", "tooltip": "Brightness: %s%%", "class": "brightness"}\n' "$icon" "$brightness" "$brightness"
fi 