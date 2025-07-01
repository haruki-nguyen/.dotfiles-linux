#!/bin/zsh
# WSL Path Utilities
# Helper functions to ensure proper path handling between WSL and Windows

# Function to ensure we're working with Linux paths
ensure_linux_path() {
    local path="$1"
    # If path starts with Windows-style paths, reject it
    if [[ "$path" =~ ^[A-Za-z]: ]] || [[ "$path" =~ ^\\\\ ]]; then
        echo "Error: Windows path detected: $path" >&2
        echo "Please use Linux paths like /home/user/..." >&2
        return 1
    fi
    echo "$path"
}

# Function to safely convert Linux path to Windows path when needed
linux_to_windows_path() {
    local linux_path="$1"
    if command -v wslpath >/dev/null 2>&1; then
        wslpath -w "$linux_path" 2>/dev/null || echo "$linux_path"
    else
        echo "$linux_path"
    fi
}

# Function to convert Windows path to Linux path
windows_to_linux_path() {
    local windows_path="$1"
    if command -v wslpath >/dev/null 2>&1; then
        wslpath -u "$windows_path" 2>/dev/null || echo "$windows_path"
    else
        echo "$windows_path"
    fi
}

# Function to validate and clean PATH environment variable
clean_path() {
    # Prioritize Linux paths over Windows paths
    local linux_paths="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/$USER/bin:/home/$USER/.local/bin"
    local cleaned_path="$linux_paths"
    
    # Add Windows paths at the end, but only if they exist
    local windows_paths=""
    IFS=':' read -ra PATH_ARRAY <<< "$PATH"
    for dir in "${PATH_ARRAY[@]}"; do
        if [[ "$dir" =~ ^/mnt/c/ ]] && [[ -d "$dir" ]]; then
            if [[ -n "$windows_paths" ]]; then
                windows_paths="$windows_paths:$dir"
            else
                windows_paths="$dir"
            fi
        fi
    done
    
    if [[ -n "$windows_paths" ]]; then
        cleaned_path="$cleaned_path:$windows_paths"
    fi
    
    echo "$cleaned_path"
}

# Function to safely execute commands that might interact with Windows
safe_windows_command() {
    local cmd="$1"
    shift
    local args=("$@")
    
    # Convert any Linux paths in arguments to Windows paths
    local converted_args=()
    for arg in "${args[@]}"; do
        if [[ "$arg" =~ ^/home/ ]] || [[ "$arg" =~ ^/ ]]; then
            converted_args+=($(linux_to_windows_path "$arg"))
        else
            converted_args+=("$arg")
        fi
    done
    
    # Execute the command with converted arguments
    command "$cmd" "${converted_args[@]}"
}

# Functions are automatically available when this script is sourced
# No need to export functions in zsh as they are available in the current session
