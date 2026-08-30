#!/usr/bin/env bash
#
# wofi-launcher.sh
# ---------------------------------------------------------------------
# Application launcher for wofi (drun mode = shows installed apps,
# same idea as rofi's drun mode).
#
# INSTALL
#   1. Put this file and style.css together in ~/.config/wofi/
#   2. chmod +x ~/.config/wofi/wofi-launcher.sh
#   3. Bind it to a key in your compositor config, e.g.:
#        Hyprland:  bind = SUPER, D, exec, ~/.config/wofi/wofi-launcher.sh
#        Sway:      bindsym $mod+d exec ~/.config/wofi/wofi-launcher.sh
#
# The script finds style.css next to itself, so it works no matter
# where it's called from (keybind, terminal, another script, etc.)
# ---------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
STYLE="$SCRIPT_DIR/style.css"

# Pressing the keybind again while wofi is already open closes it
# instead of stacking a second instance on top.
if pgrep -x wofi >/dev/null 2>&1; then
    pkill -x wofi
    exit 0
fi

wofi \
    --show drun \
    --style "$STYLE" \
    --width 600 \
    --height 300 \
    --location center \
    --prompt "" \
    --hide-promt \
    --matching fuzzy \
    --insensitive \
    --allow-images \
    --allow-markup \
    --hide-scroll \
    --no-actions \
    --columns 2
    # ^ add more flags above this line, each followed by " \"

# Optional extras — uncomment the line(s) you want, and add a
# trailing " \" to the line above it in the command block:
#
#   --normal-window   # needed if your compositor doesn't support
#                      # wlr-layer-shell — wofi crashes without it
#                      # in that case (rare on Sway/Hyprland/etc.)
#
#   --term "kitty"     # force a specific terminal for terminal-based
#                      # apps (default auto-detects kitty, alacritty,
#                      # wezterm, foot, termite, gnome-terminal, ...)