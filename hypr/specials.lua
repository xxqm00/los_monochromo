local mainMod = "SUPER"

hl.bind(
	mainMod .. " + TAB",
	hl.dsp.workspace.toggle_special("minimize"),
	{ description = "Opens the magic workspace for pomodoro, quick notes, etc." }
)
hl.bind(
	mainMod .. " + SHIFT + TAB",
	hl.dsp.window.move({ workspace = "special:minimize" }),
	{ description = "ADDS to magic workspace for pomodoro, quick notes, etc." }
)
hl.bind(
	mainMod .. " + code:87",
	hl.dsp.workspace.toggle_special("numpadOne"),
	{ description = "Opens the magic workspace" }
)
hl.bind(
	"SHIFT + code:87",
	hl.dsp.window.move({ workspace = "special:numpadOne" }),
	{ description = "ADDS to magic workspace" }
)
hl.bind(
	mainMod .. " + code:88",
	hl.dsp.workspace.toggle_special("numpadTwo"),
	{ description = "Opens the magic workspace" }
)
hl.bind(
	"SHIFT + code:88",
	hl.dsp.window.move({ workspace = "special:numpadTwo" }),
	{ description = "ADDS to magic workspace" }
)
hl.bind(
	mainMod .. " + code:89",
	hl.dsp.workspace.toggle_special("numpadThree"),
	{ description = "Opens the magic workspace" }
)
hl.bind(
	"SHIFT + code:89",
	hl.dsp.window.move({ workspace = "special:numpadThree" }),
	{ description = "ADDS to magic workspace" }
)
