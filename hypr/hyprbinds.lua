---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "thunar"
local browser = "firefox"
local menu = "vicinae toggle"
local spotify = "com.spotify.Client"

-- [Codes]
hl.bind(
	"CTRL + ALT + code:115",
	hl.dsp.exec_cmd("wlogout"),
	{ description = "(End Key) Shows the Lock, Shutdown and Reboot buttons" }
)
hl.bind(
	mainMod .. " + C",
	hl.dsp.exec_cmd(browser),
	{ description = "(Delete Key) FORCE kills the application on click (good for frozen applications)" }
)
hl.bind(
	"CTRL + ALT + code:119",
	hl.dsp.exec_cmd("kitty -e hyprctl kill"),
	{ description = "(Delete Key) FORCE kills the application on click (good for frozen applications)" }
)
hl.bind(
	mainMod .. " + code:36",
	hl.dsp.exec_cmd("swaync-client -t -sw"),
	{ description = "(Enter Key) Opens notification menu" }
) 
hl.bind(
	mainMod .. " + code:59",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/waybar-switcher.sh"),
	{ description = "(Comma ',' Key) Opens a waybar switcher" }
)
hl.bind(
	mainMod .. " + code:60",
	hl.dsp.exec_cmd("/home/kie/.config/hypr/scripts/KeyBinds.sh"),
	{ description = "(Period '.' Key) Opens keybind view" }
)
hl.bind(
	mainMod .. " + code:61",
	hl.dsp.exec_cmd("waypaper"),
	{ description = " (Forward Slash '/' Key) Opens waypaper, wallpaper manager" }
)

-- [SUPER]
hl.bind(mainMod .. " + Q", hl.dsp.window.close({ description = "Closes / kills the window" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "Opens thunar, the file manager" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen(), { description = "Fullscreens your active window" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({mode=1}), { description = "Fullscreens your active window (mode1)" })
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("kitty"), { description = "Opens kitty, the terminal" })
hl.bind(
	mainMod .. " + S",
	hl.dsp.layout("togglesplit"),
	{ description = "Toggles the splitting on windows (dwindle only)" }
) -- dwindle only
hl.bind(
	mainMod .. " + V",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "Toggles the floating of windows" }
)
hl.bind(
	mainMod .. " + W",
	hl.dsp.exec_cmd("killall -SIGUSR1 waybar"),
	{ description = "Hides the waybar (toggleable)" }
)
hl.bind(
	mainMod .. " + SPACE",
	hl.dsp.exec_cmd("rofi -show drun"),
	-- hl.dsp.exec_cmd("vicinae toggle"),
	{ description = "Toggles vicinae, kinda like wofi and friends" }
)
-- 87 88 89, 83 84 85, 79 80 81
hl.bind(
	mainMod .. " + L",
	hl.dsp.exec_cmd("/home/kie/.local/share/quickshell-lockscreen/lock.sh"),
	{ description = "Logout (not to sddm)" }
)

hl.bind(
	mainMod .. " + PRINT",
	hl.dsp.exec_cmd("flameshot gui"),
	-- hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"),
	{ description = "Takes a screenshot and sends it to ~/Pictures/Screenshots" }
)

-- [SUPER + ALT]
hl.bind(
	mainMod .. " + ALT + C",
	hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"),
	{ description = "Vicinaes clipboard feature" }
)
hl.bind(
	mainMod .. " + ALT + Z",
	hl.dsp.exec_cmd("vicinae vicinae://launch/core/search-emojis"),
	{ description = "Vicinaes emoji selector feature" }
)
hl.bind(
	mainMod .. " + ALT + ESCAPE",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
	{ description = "Logout (to sddm)" }
) -- logout to sddm


-- [SUPER + SHIFT]
hl.bind(
	mainMod .. " + SHIFT + W",
	hl.dsp.exec_cmd("killall -SIGUSR2 waybar"),
	{ description = "Refresh / update waybar" }
)

-- [SUPER + number] Switch workspaces / move window to workspace
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Move to numerical workspace" })
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move selected application to numerical workspace" }
	)
end
