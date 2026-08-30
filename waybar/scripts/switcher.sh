#!/bin/bash

# Waybar config switcher script
# Place this in your PATH or run directly

# Set the base Waybar config directory
WAYBAR_BASE_DIR="$HOME/.config/waybar"

# Function to display available configs
list_configs() {
    echo "Available Waybar configurations:"
    echo "--------------------------------"
    local i=1
    for dir in "$WAYBAR_BASE_DIR"/*/; do
        if [[ -d "$dir" && -f "$dir/config.jsonc" && -f "$dir/style.css" ]]; then
            echo "$i) $(basename "$dir")"
            ((i++))
        fi
    done
}

# Function to get config directory names with proper indexing
get_config_dirs() {
    local dirs=()
    for dir in "$WAYBAR_BASE_DIR"/*/; do
        if [[ -d "$dir" && -f "$dir/config.jsonc" && -f "$dir/style.css" ]]; then
            dirs+=("$(basename "$dir")")
        fi
    done
    echo "${dirs[@]}"
}

# Function to switch config
switch_config() {
    local config_name="$1"
    local config_path="$WAYBAR_BASE_DIR/$config_name"
    
    # Check if the config directory exists
    if [[ ! -d "$config_path" ]]; then
        echo "Error: Configuration '$config_name' not found!"
        return 1
    fi
    
    # Check if required files exist
    if [[ ! -f "$config_path/config.jsonc" ]] || [[ ! -f "$config_path/style.css" ]]; then
        echo "Error: Missing config.jsonc or style.css in '$config_name'!"
        return 1
    fi
    
    # Kill current waybar instance
    pkill waybar 2>/dev/null
    
    # Wait a moment for the process to die
    sleep 0.5
    
    # Start new waybar with the selected config
    waybar -c "$config_path/config.jsonc" -s "$config_path/style.css" &
    
    echo "✅ Switched to Waybar config: $config_name"
    return 0
}

# Main script logic
main() {
    # Check if waybar is installed
    if ! command -v waybar &> /dev/null; then
        echo "Error: waybar is not installed or not in PATH"
        exit 1
    fi
    
    # Get available configs
    read -ra configs <<< "$(get_config_dirs)"
    
    if [[ ${#configs[@]} -eq 0 ]]; then
        echo "Error: No valid Waybar configurations found in $WAYBAR_BASE_DIR"
        echo "Make sure each config directory contains config.jsonc and style.css"
        exit 1
    fi
    
    # If argument provided, try to switch directly
    if [[ $# -gt 0 ]]; then
        # Check if argument is a number (selection from list)
        if [[ "$1" =~ ^[0-9]+$ ]] && [[ "$1" -le ${#configs[@]} ]] && [[ "$1" -gt 0 ]]; then
            switch_config "${configs[$(( $1 - 1 ))]}"
        else
            # Try as a config name
            for config in "${configs[@]}"; do
                if [[ "$1" == "$config" ]]; then
                    switch_config "$config"
                    exit $?
                fi
            done
            echo "Error: Configuration '$1' not found"
            list_configs
            exit 1
        fi
    else
        # Interactive mode - show list and prompt user
        list_configs
        echo ""
        echo "Current config: $(basename "$(readlink "$WAYBAR_BASE_DIR/current" 2>/dev/null)" 2>/dev/null || echo "Unknown")"
        echo ""
        read -p "Enter the number of the config to switch to (or 'q' to quit): " choice
        
        if [[ "$choice" == "q" ]] || [[ "$choice" == "Q" ]]; then
            echo "Exiting..."
            exit 0
        fi
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -le ${#configs[@]} ]] && [[ "$choice" -gt 0 ]]; then
            switch_config "${configs[$(( $choice - 1 ))]}"
        else
            echo "Invalid selection!"
            exit 1
        fi
    fi
}

# Run the main function with all arguments
main "$@"
