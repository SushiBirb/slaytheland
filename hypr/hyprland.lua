-- ==============================================================================
-- slaytheland - Slay the Princess Hyprland Configuration (Lua)
-- Aesthetic: Hand-Drawn Charcoal, Antique Parchment & Pristine Blade Crimson
-- Fully compatible with Hyprland Lua config subsystem
-- ==============================================================================

local mod = "SUPER"

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = 1,
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME",    "SlayThePrincess")
hl.env("XCURSOR_SIZE",     "32")
hl.env("HYPRCURSOR_THEME", "SlayThePrincess")
hl.env("HYPRCURSOR_SIZE",  "32")

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

local home = os.getenv("HOME") or "/home/arch"
local shader_path = home .. "/slaytheland/hypr/shaders/pencil_border.glsl"

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,
        border_size = 3,
        col = {
            active_border = {
                colors = { "rgba(c72c41ee)", "rgba(2d2530ee)" },
                angle = 45,
            },
            inactive_border = {
                colors = { "rgba(2d2530aa)", "rgba(1a171faa)" },
                angle = 45,
            },
        },
        layout = "dwindle",
    },
    decoration = {
        rounding      = 6,
        screen_shader = shader_path,
        blur = {
            enabled           = true,
            size              = 5,
            passes            = 2,
            new_optimizations = true,
        },
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("sharpEase", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("tension",   { type = "bezier", points = { { 0.2, 0.8 }, { 0.2, 1 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 4, bezier = "sharpEase" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4, bezier = "sharpEase", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 4, bezier = "sharpEase" })
hl.animation({ leaf = "fade",        enabled = true, speed = 4, bezier = "tension" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 4, bezier = "sharpEase", style = "slide" })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")
    hl.exec_cmd("quickshell -c slaytheland &")
    hl.exec_cmd("hyprctl setcursor SlayThePrincess 32")
    hl.exec_cmd("slay-wall-cycle &")
end)

----------------------
---- KEY BINDINGS ----
----------------------

-- Applications & Quickshell Surfaces
hl.bind(mod .. " + Return",     hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Space",      hl.dsp.global("slay:launcher"))
hl.bind(mod .. " + Escape",     hl.dsp.global("slay:quicksettings"))
hl.bind(mod .. " + comma",      hl.dsp.global("slay:hub"))
hl.bind(mod .. " + G",          hl.dsp.global("slay:princess"))
hl.bind(mod .. " + P",          hl.dsp.global("slay:vessel"))
hl.bind(mod .. " + SHIFT + P",  hl.dsp.global("slay:princess_quote"))
hl.bind(mod .. " + R",          hl.dsp.global("slay:room"))
hl.bind(mod .. " + X",          hl.dsp.global("slay:dialogue"))
hl.bind(mod .. " + K",          hl.dsp.global("slay:cheatsheet"))
hl.bind(mod .. " + L",          hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + W",          hl.dsp.exec_cmd("slay-wall-cycle"))

-- Window Management
hl.bind(mod .. " + Q",          hl.dsp.window.close())
hl.bind(mod .. " + V",          hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F",          hl.dsp.window.fullscreen())
hl.bind(mod .. " + S",          hl.dsp.workspace.toggle_special("scratch"))
hl.bind(mod .. " + M",          hl.dsp.exit())

-- Focus navigation (Vim keys & Arrows)
hl.bind(mod .. " + left",       hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right",      hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",         hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",       hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + h",          hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l",          hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k",          hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j",          hl.dsp.focus({ direction = "down" }))

-- Workspaces (1 to 5)
for i = 1, 5 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Mouse bindings
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Media, Volume and Brightness Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 5%+"),                            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                            { locked = true, repeating = true })
