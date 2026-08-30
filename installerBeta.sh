#!/bin/bash

set -e

PACMAN_PACKAGES=(
    flatpak
    kitty
    firefox
    waybar
)

AUR_PACKAGES=(
    waypaper
    awww
    vicinae
    thunar
)

FLATPAK_PACKAGES=(
    spotify
    # add flatpak app IDs here
)

# Resolve the real user even when running under sudo
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

run_as_user() {
    sudo -u "$REAL_USER" "$@"
}


if [ "$EUID" -ne 0 ]; then
    echo "Error: run with sudo."
    exit 1
fi

# ── Step 1: pacman packages ────────────────────────────────────────────────────

echo "=== Updating system ==="
pacman -Syu --noconfirm

echo "=== Installing pacman packages ==="
for pkg in "${PACMAN_PACKAGES[@]}"; do
    if pacman -Q "$pkg" &>/dev/null; then
        echo "--> $pkg already installed, skipping."
    else
        echo "--> Installing $pkg..."
        pacman -S --noconfirm "$pkg"
    fi
done

# ── Step 2: yay / AUR packages ────────────────────────────────────────────────

# Install yay itself if missing
if ! run_as_user bash -c 'command -v yay &>/dev/null'; then
    echo "=== Installing yay ==="
    pacman -S --noconfirm --needed git base-devel
    run_as_user bash -c "
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        rm -rf /tmp/yay
    "
fi

echo "=== Installing AUR packages ==="
for pkg in "${AUR_PACKAGES[@]}"; do
    if run_as_user bash -c "yay -Q '$pkg' &>/dev/null"; then
        echo "--> $pkg already installed, skipping."
    else
        echo "--> Installing $pkg (AUR)..."
        run_as_user yay -S --noconfirm "$pkg"
    fi
done

# ── Step 3: Flatpak packages ───────────────────────────────────────────────────

echo "=== Configuring Flatpak ==="
# Add Flathub if not already present
run_as_user flatpak remote-add --user --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

echo "=== Installing Flatpak packages ==="
for app in "${FLATPAK_PACKAGES[@]}"; do
    if run_as_user flatpak info "$app" &>/dev/null; then
        echo "--> $app already installed, skipping."
    else
        echo "--> Installing $app (Flatpak)..."
        run_as_user flatpak install --user -y flathub "$app"
    fi
done

echo "=== Done ==="
echo "Now you can copy the files from the repo onto your device!"
