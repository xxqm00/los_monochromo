#!/usr/bin/env bash
# show-keybinds.sh — display hyprbinds.lua keybinds in rofi

pkill yad 2>/dev/null || true

# Toggle: if rofi is already open, close it
if pidof rofi > /dev/null; then
    pkill rofi
    exit 0
fi

keybinds_lua="$HOME/.config/hypr/hyprbinds.lua"
msg='Keybinds  —  Escape to close'

[[ ! -f "$keybinds_lua" ]] && {
    notify-send "show-keybinds" "File not found: $keybinds_lua"
    exit 1
}

display_keybinds=$(gawk '
# Skip full-line comments
/^[[:space:]]*--/ { next }

# Capture: local varName = "value"
/^[[:space:]]*local[[:space:]]/ && /=/ && /"/ {
    varline = $0
    sub(/^[[:space:]]*local[[:space:]]+/, "", varline)
    eq = index(varline, "=")
    vname = substr(varline, 1, eq - 1)
    gsub(/[[:space:]]/, "", vname)
    vval = substr(varline, eq + 1)
    if (match(vval, /"[^"]*"/))
        vars[vname] = substr(vval, RSTART + 1, RLENGTH - 2)
    next
}

# Process single-line hl.bind() calls that have a description field
/hl\.bind\(/ && /description[[:space:]]*=/ {
    line = $0

    # Strip trailing inline comments (e.g. "-- code:36 = ENTER key")
    sub(/[[:space:]]*--[[:space:]]*[a-z].*$/, "", line)

    # Extract first argument (key combo) up to first comma
    rest = line
    sub(/.*hl\.bind\(/, "", rest)
    combo = rest
    sub(/,.*/, "", combo)

    # Clean up Lua string syntax: remove quotes and .. concat operators
    gsub(/"/, " ", combo)
    gsub(/\.\.[[:space:]]*/, "", combo)
    gsub(/[[:space:]]+/, " ", combo)
    sub(/^[[:space:]]+/, "", combo)
    sub(/[[:space:]]+$/, "", combo)

    # Resolve variable names (e.g. mainMod -> SUPER)
    n = split(combo, parts, " ")
    resolved = ""
    for (i = 1; i <= n; i++) {
        p = parts[i]
        if (p in vars) p = vars[p]
        resolved = (i > 1) ? resolved " " p : p
    }

    # Extract description string value
    if (match(line, /description[[:space:]]*=[[:space:]]*"/)) {
        desc = substr(line, RSTART + RLENGTH - 1)
        sub(/^"/, "", desc)
        sub(/".*/, "", desc)
    } else {
        next
    }

    # Skip placeholder / empty descriptions
    if (desc == "your description here" || desc == "") next

    printf "%-38s  %s\n", resolved, desc
}
' "$keybinds_lua")

[[ -z "$display_keybinds" ]] && \
    display_keybinds="(no keybinds found — check $keybinds_lua)"

printf '%s\n' "$display_keybinds" | rofi -dmenu -i -mesg "$msg" -p "Keybinds" \
    -theme-str 'window {width: 70%;} listview {columns: 1;}'