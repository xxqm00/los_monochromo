-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	-------------------
	----- Needed ------
	-------------------
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY DBUS_SESSION_BUS_ADDRESS"
	)
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland DISPLAY")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("fcitx5")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	-------------------------
	----- Applications ------
	-------------------------
	hl.exec_cmd("waybar")
	hl.exec_cmd("flameshot")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("waypaper --restore")
	hl.exec_cmd("vicinae server")
	hl.exec_cmd("swaync -c ~/.config/swaync/config.json")
	hl.exec_cmd("legcord")
	hl.exec_cmd("com.spotify.Client")
	hl.exec_cmd("hypridle")

	hl.exec_cmd("systemctl --user enable --now veilad.service")
	hl.exec_cmd("hyprctl reload")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("hyprctl reload")
end)
