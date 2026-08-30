-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {

		gaps_in = 10,
		gaps_out = 50,
		-- gaps_in = 10,
		-- gaps_out = 15,

		border_size = 0,

		col = {
			active_border = {
				colors = { "rgb(f0f0f0)", "rgba(c0c0c00e)", "rgba(8080800e)", "rgba(2b2b2b0e)", "rgb(fefefe)" },
				angle = 105,
			},
			inactive_border = {
				colors = { "rgba(808080ee)", "rgba(2b2b2b0e)", "rgba(2b2b2b0e)", "rgba(808080ee)" },
				angle = 105,
			},
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {

		blur = {
			enabled = true,
			new_optimizations = true,
			size = 2,
			passes = 5,
			vibrancy = 0.9,
			special = true,
			xray = false,
		},

		rounding = 10,
		rounding_power = 10,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
			range = 3,
			render_power = 1,
			color = 0xee0e0e0e,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	-- name  = "float-kitty",
	match = { title = "nmtui" },
	float = true,
	pin = false,
	move = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" },

	-- move = { 380, 200 },
	focus_on_activate = true,
})

hl.window_rule({
	-- name  = "float-kitty",
	match = { title = "kitty" },
	float = true,
	pin = false,
	focus_on_activate = true,
	--   move  = {"cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)"},

	move = { 380, 200 },
	focus_on_activate = true,
})

hl.window_rule({
	match = { class = "pomatez" }, -- formerly de.manuel_kehl.go-for-it
	float = true,
	-- move = { 1010, 135 },
	persistent_size = true,
})

hl.window_rule({
	match = { class = "rencal" }, -- formerly de.manuel_kehl.go-for-it
	float = true,
	move = { 1010, 175 },
	persistent_size = true,
	size = "330 430", -- width height in pixels
})

hl.window_rule({
	match = { class = "de.manuel_kehl.go-for-it" },
	float = true,
	move = { 25, 175 },
	persistent_size = true,
	size = "330 430", -- width height in pixels
})

hl.window_rule({
	match = { class = "com.belmoussaoui.Authenticator" },
	float = true,
	size = "330 430", -- width height in pixels
})

hl.window_rule({
	match = { class = "waypaper" },
	float = true,
	size = "330 430", -- width height in pixels
})

hl.window_rule({ match = { title = "^(.*Network Manager.*)$" }, float = true })

hl.window_rule({
	match = { class = "blueman-manager" },
	float = true,
	-- size = "660 450",
})

hl.window_rule({
	match = { class = "nvim.desktop" },
	float = false,
	-- size = "660 450",
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
--
-- hl.window_rule({
-- 	match = { fullscreen = true },
-- 	opacity = "1",
-- 	--   border_size = 0

-- })

hl.window_rule({
	match = { fullscreen = false },
	opacity = "0.85",
})

hl.window_rule({
	match = { class = "kitty" },
	opacity = "0.75",
	-- xray = true,
	border_size = 1,
})

hl.layer_rule({ match = { namespace = "hyprshot" }, blur = false, ignore_alpha = false })

hl.layer_rule({ match = { namespace = "kitty" }, blur = true, ignore_alpha = false })
hl.layer_rule({ match = { title = "^(.*swaync*)$" }, blur = true, ignore_alpha = false })

-- hl.layer_rule({ match = { namespace = "nmgui" }, float})
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = false })
hl.layer_rule({ match = { namespace = "wlogout" }, blur = true, ignore_alpha = false })
hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = false, xray = false })
hl.layer_rule({ match = { namespace = "wofi" }, blur = true, ignore_alpha = false })
hl.layer_rule({ match = { namespace = "firefox" }, blur = false, ignore_alpha = false })

-----------------------
----- ANIMATIONS ------
-----------------------

-- Curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 300, dampening = 40 })
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 300, dampening = 20 })
hl.curve("menu", { type = "spring", mass = 1, stiffness = 300, dampening = 28 })
hl.curve("window", { type = "spring", mass = 1, stiffness = 300, dampening = 30 })
hl.curve("open", { type = "spring", mass = 1, stiffness = 300, dampening = 10 })
hl.curve("workspace", { type = "spring", mass = 1, stiffness = 300, dampening = 10 })
hl.curve("special", { type = "spring", mass = 1, stiffness = 300, dampening = 30 })

hl.animation({ leaf = "global", enabled = true, speed = 10, spring = "open" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "rubber" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, spring = "window" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, spring = "open" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, spring = "open" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })

hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, spring = "easy", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, spring = "easy", style = "slide bottom" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, spring = "window" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, spring = "window" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 1.79, spring = "easy", style = "slide left" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 10, spring = "easy", style = "slidefade bottom" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 6, spring = "easy", style = "slidefade top" })

hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "quick" })

hl.animation({ leaf = "borderangle", enabled = true, speed = 35, bezier = "linear", style = "loop" })
