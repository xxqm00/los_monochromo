#!/usr/bin/env bash

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

rofi \
    -show drun \
    -theme ~/.config/rofi/theme.rasi \
    -show-icons \
    -columns 2 \
    -matching fuzzy \
    -no-case-sensitive \
    -drun-match-fields "name,generic,exec,categories,keywords"