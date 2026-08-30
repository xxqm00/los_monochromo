#!/bin/bash

# Waybar switcher with Rofi interface
# Save this as waybar-switch-rofi and make it executable

# Path to your waybar-switch script - UPDATE THIS!
WAYBAR_SWITCH_SCRIPT="$HOME/.config/waybar/scripts/switcher.sh"  # Change this to your actual path

# Log file for debugging
LOG_FILE="/tmp/waybar-switch-rofi.log"

# Function for logging
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to get available configs
get_configs() {
    local configs=()
    
    # Debug: log what we're scanning
    log_message "Scanning for configs in: $HOME/.config/waybar"
    
    # Direct directory parsing
    for dir in "$HOME/.config/waybar"/*/; do
        if [[ -d "$dir" ]]; then
            log_message "Checking directory: $dir"
            
            # Check for config files directly in this directory
            if [[ -f "$dir/config.jsonc" && -f "$dir/style.css" ]]; then
                local name=$(basename "$dir")
                configs+=("$name")
                log_message "Found direct config: $name"
            fi
            
            # Check for themes subdirectory
            if [[ -d "$dir/themes" ]]; then
                for theme_dir in "$dir/themes"/*/; do
                    if [[ -d "$theme_dir" && -f "$theme_dir/config.jsonc" && -f "$theme_dir/style.css" ]]; then
                        local parent=$(basename "$dir")
                        local theme=$(basename "$theme_dir")
                        configs+=("$parent/themes/$theme")
                        log_message "Found theme config: $parent/themes/$theme"
                    fi
                done
            fi
            
            # Check for theme subdirectory (without 's')
            if [[ -d "$dir/theme" ]]; then
                for theme_dir in "$dir/theme"/*/; do
                    if [[ -d "$theme_dir" && -f "$theme_dir/config.jsonc" && -f "$theme_dir/style.css" ]]; then
                        local parent=$(basename "$dir")
                        local theme=$(basename "$theme_dir")
                        configs+=("$parent/theme/$theme")
                        log_message "Found theme config: $parent/theme/$theme"
                    fi
                done
            fi
        fi
    done
    
    # If no configs found, try alternate locations
    if [[ ${#configs[@]} -eq 0 ]]; then
        log_message "No configs found in standard locations, checking alternate paths..."
        
        # Check if themes are in ~/.config/waybar/themes directly
        if [[ -d "$HOME/.config/waybar/themes" ]]; then
            for theme_dir in "$HOME/.config/waybar/themes"/*/; do
                if [[ -d "$theme_dir" && -f "$theme_dir/config.jsonc" && -f "$theme_dir/style.css" ]]; then
                    configs+=("themes/$(basename "$theme_dir")")
                    log_message "Found theme in themes dir: themes/$(basename "$theme_dir")"
                fi
            done
        fi
    fi
    
    printf '%s\n' "${configs[@]}"
}

# Function to switch config with debugging
switch_config() {
    local config_name="$1"
    
    log_message "Attempting to switch to: $config_name"
    log_message "Using script: $WAYBAR_SWITCH_SCRIPT"
    
    # Check if the switch script exists
    if [[ ! -f "$WAYBAR_SWITCH_SCRIPT" ]]; then
        log_message "ERROR: Switch script not found at $WAYBAR_SWITCH_SCRIPT"
        notify-send "Waybar Switch Error" "Switch script not found!" -u critical
        return 1
    fi
    
    # Make sure it's executable
    if [[ ! -x "$WAYBAR_SWITCH_SCRIPT" ]]; then
        log_message "Making script executable: $WAYBAR_SWITCH_SCRIPT"
        chmod +x "$WAYBAR_SWITCH_SCRIPT"
    fi
    
    # Execute the switch script with the selected config
    log_message "Executing: $WAYBAR_SWITCH_SCRIPT \"$config_name\""
    
    # Run the script and capture output
    local output
    output=$("$WAYBAR_SWITCH_SCRIPT" "$config_name" 2>&1)
    local exit_code=$?
    
    log_message "Exit code: $exit_code"
    log_message "Output: $output"
    
    if [[ $exit_code -eq 0 ]]; then
        log_message "Successfully switched to: $config_name"
        notify-send "Waybar Theme" "Switched to: $config_name" -t 2000
        return 0
    else
        log_message "ERROR: Failed to switch to: $config_name"
        log_message "Error output: $output"
        notify-send "Waybar Switch Error" "Failed to switch to: $config_name" -u critical
        return 1
    fi
}

# Select config with Rofi
select_config() {
    # Clear log
    echo "=== Waybar Rofi Switch Log ===" > "$LOG_FILE"
    log_message "Starting Waybar Rofi selector"
    
    # Get configs
    local configs=()
    while IFS= read -r config; do
        [[ -n "$config" ]] && configs+=("$config")
    done < <(get_configs)
    
    log_message "Found ${#configs[@]} configs: ${configs[*]}"
    
    if [[ ${#configs[@]} -eq 0 ]]; then
        log_message "ERROR: No configurations found!"
        notify-send "Waybar Error" "No configurations found in ~/.config/waybar/" -u critical
        exit 1
    fi
    
    # Split into two even halves, then interleave so rofi's row-major
    # 2-column fill puts the first half on the left and second half on the right
    local total=${#configs[@]}
    local half=$(( (total + 1) / 2 ))
    local interleaved=()
    local i
    for (( i = 0; i < half; i++ )); do
        interleaved+=("${configs[$i]}")
        local right_idx=$(( i + half ))
        if (( right_idx < total )); then
            interleaved+=("${configs[$right_idx]}")
        fi
    done
    
    # Show Rofi menu
    log_message "Showing Rofi menu"
    local selected
    selected=$(printf '%s\n' "${interleaved[@]}" | rofi \
        -dmenu \
        -p "Select Waybar Theme" \
        -i \
        -lines "$half" \
        -theme-str 'window {width: 300px;} listview {columns: 1;}')
    
    # Check if user made a selection
    if [[ -z "$selected" ]]; then
        log_message "No selection made (user cancelled)"
        exit 0
    fi
    
    log_message "User selected: $selected"
    
    # Switch to selected config
    switch_config "$selected"
}

# Main
select_config
