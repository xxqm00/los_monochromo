#!/bin/bash
# Check if hypridle is running
if pgrep -x "hypridle" > /dev/null; then
    pkill -x hypridle
    notify-send "Idle Inhibitor" "Idle mode disabled"
else
    hypridle &
    notify-send "Idle Inhibitor" "Idle mode enabled"
fi
