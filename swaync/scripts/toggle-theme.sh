#!/bin/bash

STATE_FILE="$HOME/.config/swaync/.theme"
SWAYNC_DIR="$HOME/.config/swaync"

# Default to dark if no state file
current=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

if [[ "$SWAYNC_TOGGLE_STATE" == "true" ]]; then
    cp "$SWAYNC_DIR/style-light.css" "$SWAYNC_DIR/style.css"
    echo "light" > "$STATE_FILE"
else
    cp "$SWAYNC_DIR/style-dark.css" "$SWAYNC_DIR/style.css"
    echo "dark" > "$STATE_FILE"
fi

swaync-client -rs

# Put this code in the button-grid in order to use the theme toggle:
                # {
                #     "label": "X",
                #     "type": "toggle",
                #     "active": false,
                #     "command": "sh -c '$HOME/.config/swaync/toggle-theme.sh'",
                #     "update-command": "sh -c '[[ $(cat ~/.config/swaync/.theme 2>/dev/null) == \"light\" ]] && echo true || echo false'"
                # },