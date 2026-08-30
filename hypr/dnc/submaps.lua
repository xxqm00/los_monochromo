--------------------------
--       SUBMAPS        --
--------------------------
local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local browser     = "firefox"
local menu        = "vicinae toggle"
local spotify     = "com.spotify.Client"

-- [ALT]
hl.bind("ALT + R", hl.dsp.submap("resize"))


hl.define_submap("resize", function()

    -- Move window
    hl.bind("ALT + A", hl.dsp.window.move({ x = -30, y = 0,  relative = true }), { repeating = true })
    hl.bind("ALT + D", hl.dsp.window.move({ x = 30,  y = 0,  relative = true }), { repeating = true })
    hl.bind("ALT + W", hl.dsp.window.move({ x = 0,   y = -30, relative = true }), { repeating = true })
    hl.bind("ALT + S", hl.dsp.window.move({ x = 0,   y = 30, relative = true }), { repeating = true })

    -- Resize window
    hl.bind("A", hl.dsp.window.resize({ x = -30, y = 0,  relative = true }), { repeating = true })
    hl.bind("D", hl.dsp.window.resize({ x = 30,  y = 0,  relative = true }), { repeating = true })
    hl.bind("S", hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
    hl.bind("W", hl.dsp.window.resize({ x = 0,   y = 30, relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))

end)