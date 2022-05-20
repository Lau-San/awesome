-- =================================================== --
-- ----------- MY AWESOME WM CONFIGURATION ----------- --
-- =================================================== --
--
-- This is my configuration for Awesome WM. I took Derek Taylor's
-- configuration (gitlab.com/dwt1/dotfiles) as a starting point
-- since this was my first tiling window manager and his videos
-- and dotfiles repo really helped me get started.
--
-- RECOMMENDED PROGRAMS
-- --------------------
--
-- -> firefox (for webaps like notion, excalidraw, etc.)
-- -> dmenu with the following patches:
--      -> lineheight
-- -> custom scripts in my dotfiles repository (github.com/Lau-San/dotfiles/tree/master/scripts)
-- -> taskwarrior (for managing tasks with dmenu scripts)
-- -> rofi
-- -> lxsession
-- -> feh
-- -> picom
--
-- DEFAULT PROGRAMS
-- ----------------
--
-- -> qutebrowser
-- -> alacritty
-- -> bpytop
-- -> emacs
-- -> cfiles


-- =================================================== --
-- IMPORTS
-- =================================================== --

pcall(require, "luarocks.loader")

local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- STANDARD AWESOME LIBRARY
---------------------------

local gears     = require("gears")
local awful     = require("awful")
local my_table  = awful.util.table or my_table
require("awful.autofocus")

-- WIDGET AND LAYOUT LIBRARY
----------------------------

local wibox = require("wibox")

-- THEME HANDLING LIBRARY
-------------------------

local beautiful = require("beautiful")

-- NOTIFICATION LIBRARY
-----------------------

local naughty = require("naughty")

-- HOTKEY HELP WIDGET FOR DIFFERENT APPS
----------------------------------------

local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")


-- =================================================== --
-- ERROR HANDLING
-- =================================================== --

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- RUNTIME ERRORS
-----------------

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end


-- =================================================== --
-- PATHS
-- =================================================== --

local awesome_path      = string.format("%s/.config/awesome", os.getenv("HOME"))
local dmscripts_path    = string.format("%s/dmscripts/", os.getenv("HOME"))

local dmrun     = dmscripts_path .. "dmrun"
local dmconf    = dmscripts_path .. "dmconf"
local dmpass    = dmscripts_path .. "dmpass"
local dmtask    = dmscripts_path .. "dmtask"


-- =================================================== --
-- THEME
-- =================================================== --

-- SELECT THEME
---------------------------------------------------------

-- -> dracula

local selected_theme = "dracula"

-- LOAD THEME
beautiful.init(awesome_path .. "/themes/" .. selected_theme .. "/theme.lua")

-- BLING
---------------------------------------------------------

local bling = require("bling")

-- WALLPAPER
---------------------------------------------------------

local wallpaper = "~/Pictures/Wallpapers/dracula-soft-waves-6272a4.png"


-- =================================================== --
-- DEFAULT PROGRAMS
-- =================================================== --

local terminal          = "alacritty"
local browser           = "qutebrowser"
local editor            = "emacsclient -c -a 'emacs'"
local filemanager       = terminal .. " -e cfiles ~"
-- local mediaplayer       = "celluloid"
local system_monitor    = "bpytop"

awful.util.terminal = terminal
awful.util.shell    = "bash"



-- =================================================== --
-- SCRATCHPADS
-- =================================================== --

local notion_scratch = bling.module.scratchpad {
    command = "notion", -- This is a script in my bin folder in my repo
    rule = { class = "notion" },
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = {
        x = 0,
        y = 0,
        height = 900,
        width = 1600
    },
    reapply = true,
    dont_focus_before_close = false
}

local excalidraw_scratch = bling.module.scratchpad {
    command = "excalidraw",
    rule = { class = "excalidraw" },
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = {
        x = 0,
        y = 0,
        height = 900,
        width = 1600
    },
    reapply = true,
    dont_focus_before_close = false
}

local mindmeister_scratch = bling.module.scratchpad {
    command = "mindmeister",
    rule = { class = "mindmeister" },
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = {
        x = 0,
        y = 0,
        height = 900,
        width = 1600
    },
    reapply = true,
    dont_focus_before_close = false
}

-- This is here to make connecting signals to scratchpads easier.
local scratchpads = {
    notion_scratch,
    excalidraw_scratch
}


-- =================================================== --
-- TAGS
-- =================================================== --

awful.util.tagnames = {
    " DEV ",
    " WWW ",
    " SYS ",
    " VRT ",
    " DOC ",
    " CHT ",
    " MUS ",
    " VID ",
    " ART "
}


-- =================================================== --
-- LAYOUTS
-- =================================================== --

-- LAYOUT PREVIEW LEGEND
--
-- "#" ............ Status bar
--
-- "|", "-", "*" .. Window borders and corners
--
-- "M" ............ Master Area (If Layout has no M mark, then
--                  that modify Master Area won't have effect)
--
-- "1...9" ........ Order in which the client spawns, 1 being the
--                  first window opened
--
-- NOTE: The first layout of the list will be set as the default.

awful.layout.layouts = {

    -- #########################
    -- +-----------+-----------+
    -- | M         |         3 |
    -- |           |-----------+
    -- |           |         2 |
    -- |           |-----------+
    -- |         4 |         1 |
    -- +-----------+-----------+
    awful.layout.suit.tile,

    -- #########################
    -- +-----------+-----------+
    -- |         3 | M         |
    -- +-----------|           |
    -- |         2 |           |
    -- +-----------|           |
    -- |         1 |         4 |
    -- +-----------+-----------+
    awful.layout.suit.tile.left,

    -- #########################
    -- +-----------------------+
    -- | M                     |
    -- |                     5 |
    -- +-----+-----+-----+-----+
    -- |     |     |     |     |
    -- |   4 |   3 |   2 |   1 |
    -- +-----+-----+-----+-----+
    awful.layout.suit.tile.bottom,

    -- #########################
    -- +-----+-----+-----+-----+
    -- |     |     |     |     |
    -- |   4 |   3 |   2 |   1 |
    -- +-----+-----+-----+-----+
    -- | M                     |
    -- |                     5 |
    -- +-----------------------+
    awful.layout.suit.tile.top,

    -- #########################   #########################   #########################
    -- +-----------+-----------+   +-----------+-----------+   +-----------+-----------+
    -- |           |           |   |           |           |   |           |           |
    -- |           |           |   |         2 |           |   |        4  |         2 |
    -- |           |           | > +-----------+           | > +-----------+-----------+
    -- |           |           |   |           |           |   |           |           |
    -- |         2 |         1 |   |         3 |         1 |   |        3  |         1 |
    -- +-----------+-----------+   +-----------+-----------+   +-----------+-----------+
    awful.layout.suit.fair,

    -- #########################
    -- +-----------+-----------+
    -- |           |           |
    -- |           |         3 |
    -- |           +-----+-----+
    -- |           |     |     |
    -- |         4 |   2 |   1 |
    -- +-----------+-----+-----+
    awful.layout.suit.spiral.dwindle,

    -- ##########+--------+#####
    --           |        |
    --      +--------+    |
    --      |        |    |
    --      |        |----+
    --      |        |
    --      +--------+
    awful.layout.suit.floating,

    -- #########################
    -- +-----------------------+
    -- |    +-------------+ 3  |
    -- +----| M           |----+
    -- |    |             | 2  |
    -- +----|           4 |----+
    -- |    +-------------+ 1  |
    -- +-----------------------+
    awful.layout.suit.magnifier,

    -- #########################
    -- |                       |
    -- |                       |
    -- |                       |
    -- |                       |
    -- |                       |
    -- |                       |
    -- +-----------------------+
    awful.layout.suit.max,

    -- +-----------------------+
    -- |                       |
    -- |                       |
    -- |                       |
    -- |                       |
    -- |                       |
    -- |                       |
    -- +-----------------------+
    awful.layout.suit.max.fullscreen,

    -- #########################   #########################   #########################
    -- +-----------------------+   +-----------+-----------+   +-----------+-----------+
    -- |                       |   |           |           |   |           |           |
    -- |                     2 |   |         3 |         2 |   |         4 |         3 |
    -- +-----------------------+ > +-----------+-----------+ > +-----------+-----------+
    -- |                       |   |                       |   |           |           |
    -- |                     1 |   |                     1 |   |         2 |         1 |
    -- +-----------------------+   +-----------------------+   +-----------+-----------+
    -- awful.layout.suit.fair.horizontal,

    -- #########################
    -- +-----------+-----------+
    -- |           |           |
    -- |           |         3 |
    -- |           +-----+-----+
    -- |           |     |     |
    -- |         4 |   1 |   2 |
    -- +-----------+-----+-----+
    -- awful.layout.suit.spiral,


    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


-- =================================================== --
-- STATUS BAR
-- =================================================== --

-- Create status bar (wibar) for each screen
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)


-- =================================================== --
-- KEY BINDINGS
-- =================================================== --

-- MOD KEYS
---------------------------------------------------------

local supkey    = "Mod4"
local altkey    = "Mod1"
local ctrkey    = "Control"
local shftkey   = "Shift"

-- GLOBAL KEYS
---------------------------------------------------------

local globalkeys = my_table.join (

    -- AWESOME
    ----------

    -- CHEATSHEET
    awful.key({ supkey,         }, "c",
        hotkeys_popup.show_help,
        { description = "show awesome hotkeys cheatsheet", group = "awesome" }),

    -- RESTART AWESOME
    awful.key({ supkey, shftkey }, "r",
        awesome.restart,
        { description = "restart awesome", group = "awesome" }),

    -- QUIT AWESOME
    awful.key({ supkey, shftkey }, "q",
        awesome.quit,
        { description = "log out", group = "awesome" }),

    -- PROMPTS
    ----------

    -- DMENU
    awful.key({ supkey,         }, "p",
        function()
            awful.util.spawn_with_shell(string.format(
                "dmenu_run -l 25 -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
                beautiful.prompt_bg,
                beautiful.prompt_fg,
                beautiful.prompt_focus_bg,
                beautiful.prompt_focus_fg
            ))
        end,
        { description = "dmenu prompt", group = "prompts" }),

    -- ROFI
    awful.key({ supkey,         }, "r",
        function() awful.util.spawn_with_shell("rofi -show drun") end,
        { description = "rofi program menu", group = "prompts" }),

    -- DMENU SCRIPTS
    ----------------

    -- DMCONF
    awful.key({ supkey, altkey }, "c",
        function() awful.util.spawn_with_shell(dmconf) end,
        { description = "open configuration", group = "dmenu scripts" }),

    -- DMPASS
    awful.key({ supkey, altkey }, "p",
        function() awful.util.spawn_with_shell(dmpass) end,
        { description = "password manager", group = "dmenu scripts" }),

    -- DMTASK
    awful.key({ supkey, altkey }, "t",
        function() awful.util.spawn_with_shell(dmtask) end,
        { description = "tasks", group = "dmenu scripts" }),

    -- APPLICATIONS
    ---------------

    -- TERMINAL
    awful.key({ supkey,         }, "Return",
        function() awful.util.spawn(terminal) end,
        { description = "open terminal", group = "applications" }),

    -- SYSTEM MONITOR
    awful.key({ supkey,         }, ".",
        function()
            awful.spawn(terminal .. " -e " .. system_monitor, {
            })
        end,
        { description = "open system monitor", group = "applications" }),

    -- BROWSER
    awful.key({ supkey,         }, "b",
        function() awful.util.spawn(browser) end,
        { description = "open browser", group = "applications" }),

    -- FILE MANAGER
    awful.key({ supkey,         }, "f",
        function() awful.spawn.with_shell(filemanager) end,
        { description = "open file manager", group = "applications" }),

    -- EDITOR
    awful.key({ supkey,         }, "e",
        function() awful.util.spawn_with_shell(editor) end,
        { description = "open editor", group = "applications" }),

    -- TICKTICK
    awful.key({ supkey,          }, "t",
        function() awful.util.spawn_with_shell("ticktick") end,
        { description = "open ticktick", group = "applecations" }),

    -- SCRATCHPADS
    --------------

    -- NOTION
    awful.key({ supkey, altkey }, "n",
        function() notion_scratch:toggle() end,
        { description = "open notion", group = "scratchpads" }),

    -- EXCALIDRAW
    awful.key({ supkey, altkey }, "e",
        function() excalidraw_scratch:toggle() end,
        { description = "open excalidraw", group = "scratchpads" }),

    -- MINDMEISTER
    awful.key({ supkey, altkey }, "m",
        function() mindmeister_scratch:toggle() end,
        { description = "open mindmeister", group = "scratchpads" }),

    -- NAVIGATION
    -------------

    -- GO TO NEXT TAG
    awful.key({ supkey,         }, "i",
        awful.tag.viewnext,
        { description = "go to next tag", group = "navigation" }),

    -- GO TO PREVIOUS TAG
    awful.key({ supkey,         }, "u",
        awful.tag.viewprev,
        { description = "go to previous tag", group = "navigation" }),

    -- FOCUS NEXT SCREEN
    awful.key({ supkey,         }, "l",
        function() awful.screen.focus_relative(1) end,
        { description = "focus next screen", group = "navigation" }),

    -- FOCUS PREVIOUS SCREEN
    awful.key({ supkey,         }, "h",
        function() awful.screen.focus_relative(-1) end,
        { description = "focus previous screen" }),

    -- FOCUS NEXT WINDOW
    awful.key({ supkey,         }, "j",
        function() awful.client.focus.byidx(1) end,
        { description = "focus next window", group = "navigation" }),

    -- FOCUS PREVIOUS WINDOW
    awful.key({ supkey,         }, "k",
        function() awful.client.focus.byidx(-1) end,
        { description = "focus previous window", group = "navigation" }),

    -- WINDOW AND LAYOUT CONTROL
    ----------------------------

    -- SWAP WINDOW WITH NEXT WINDOW
    awful.key({ supkey, ctrkey }, "j",
        function() awful.client.swap.byidx(1) end,
        { description = "swap window with next window", group = "window" }),

    -- SWAP WINDOW WITH PREVIOUS WINDOW
    awful.key({ supkey, ctrkey }, "k",
        function() awful.client.swap.byidx(-1) end,
        { description = "swap window with previous window", group = "window" }),

    -- RESTORE MINIMIZED
    awful.key({ supkey, ctrkey }, "r",
        function ()
            local c = awful.client.restore()
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized windows", group = "window" }),

    -- INCREASE MASTER WINDOW SIZE
    awful.key({ supkey, ctrkey }, "+",
        function() awful.tag.incmwfact(0.05) end,
        { description = "increase master window size", group = "layout" }),

    -- DECREASE MASTER WINDOW SIZE
    awful.key({ supkey,    ctrkey }, "-",
        function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master window size", group = "layout" }),

    -- INCREASE NUMBER OF MASTER WINDDOWS
    awful.key({ supkey, shftkey }, "+",
        function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase number of master windows", group = "layout" }),

    -- DECREASE NUMBER OF MASTER WINDOWS
    awful.key({ supkey, shftkey }, "-",
        function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease number of master windows", group = "layout" }),

    -- SELECT NEXT LAYOUT
    awful.key({ supkey, shftkey }, "j",
        function() awful.layout.inc(1) end,
        { description = "select next layout", group = "layout" }),

    -- SELECT PREVIOUS LAYOUT
    awful.key({ supkey, shftkey }, "k",
        function() awful.layout.inc(-1) end,
        { description = "select previous layout", group = "layout" }),

    -- SYSTEM
    ---------

    -- INCREASE VOLUME
    awful.key({        }, "XF86AudioRaiseVolume",
        function()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),

    -- DECREASE VOLUME
    awful.key({        }, "XF86AudioLowerVolume",
        function()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end)

    -- TOGGLE MUTE
    -- I commented this since it seem like I can unmute after muting for some reason without logging out an then
    -- logging in on Cinnamon (or any DE that the distro ships with), so I'll save myself the pain accidentally
    -- muting and having to logout to unmute. It's not like a ever need to mute my volume anyways.
    -- awful.key({        }, "XF86AudioMute",
    --     function()
    --         os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    --         beautiful.volume.update()
    --     end)
)

-- TAGS
-------

for i = 1, 9 do
    local descr_goto, descr_toggle, descr_move, descr_add
    if i == 1 or i == 9 then
        descr_goto = { description = "go to tag #", group = "tag" }
        descr_toggle = { description = "toggle tag #", group = "tag" }
        descr_move = { description = "move focused window to tag #", group = "tag" }
        descr_add = { description = "add focused window to tag #", group = "tag" }
    end

    globalkeys = my_table.join(
        globalkeys,

        -- VIEW TAG ONLY
        awful.key({ supkey,         }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_goto),

        -- TOGGLE TAG
        awful.key({ supkey, shftkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle),

        -- MOVE WINDOW TO TAG
        awful.key({ supkey, ctrkey }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move),

        -- ADD WINDOW TO TAG
        awful.key({ supkey, ctrkey, shftkey }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_add)
    )
end

root.keys(globalkeys)

-- CLIENT KEYS
---------------------------------------------------------

local clientkeys = my_table.join(

    -- TOGGLE FULLSCREEN
    awful.key({ supkey, ctrkey }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "window" }),

    -- CLOSE  WINDOW
    awful.key({ supkey, ctrkey }, "c",
        function(c) c:kill() end,
        { description = "close window", group = "window" }),

    -- TOGGLE FLOATING
    awful.key({ supkey, ctrkey }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "window" }),

    -- MOVE TO MASTER AREA
    awful.key({ supkey, ctrkey }, "Return",
        function(c) c:swap(awful.client.getmaster()) end,
        { description = "move window to master", group = "window" }),

    -- MOVE TO OTHER SCREEN
    awful.key({ supkey, ctrkey }, "o",
        function(c) c:move_to_screen() end,
        { description = "move window to other screen", group = "window" }),

    -- MINIMIZE WINDOW
    awful.key({ supkey, ctrkey }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize window", group = "window" }),

    -- (UN)MAXIMIZE WINDOW
    awful.key({ supkey, ctrkey }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize window", group = "window" })
)

-- =================================================== --
-- MOUSE BUTTONS
-- =================================================== --

 awful.util.taglist_buttons = my_table.join(

    -- GO TO TAG
    awful.button({ }, 1,
        function(t) t:view_only() end),

    -- MOVE FOCUSED WINDOW TO TAG
    awful.button({ supkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),

    -- TOGGLE TAG VIEW
    awful.button({ }, 3,
        awful.tag.viewtoggle),

    -- ADD/REMOVE WINDOW TO TAG
    awful.button({ supkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end)
)

local clientbuttons = my_table.join(

    -- FOCUS WINDOW AND RAISE
    awful.button({        }, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),

    -- MOVE WINDOW
    awful.button({ supkey }, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),

    -- RESIZE WINDOW
    awful.button({ supkey }, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
)


-- =================================================== --
-- RULES
-- =================================================== --

awful.rules.rules = {

    -- DEFAULT
    -----------------------------------------------------
    {
        rule = {  },
        properties = {
            border_width        = beautiful.border_width,
            border_color        = beautiful.border_normal,
            focus               = awful.client.focus.filter,
            raise               = true,
            keys                = clientkeys,
            buttons             = clientbuttons,
            screen              = awful.screen.preferred,
            placement           = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor    = false
        }
    },

    -- NO TITLEBARS
    -----------------------------------------------------
    {
        rule_any = { type = { "dialog", "normal" } },
        properties = {
            titlebars_enabled = false
        }
    },

    -- FLOATING AND CENTERED
    -----------------------------------------------------
    {
        rule_any = {
            -- name = {
            --     "DMPass",   -- Window opened by dmenu script when adding a password to pass
            --     "DMTask"    -- Window opened by dmenu script when viewing a task list
            -- },
            type = {
                "dialog"
            },
            instance = {
                "DTA",
                "copyq"
            },
            class = {
                "Galculator",
                "Gnome-font-viewer",
                "Font-manager",
                "Gcr-prompter",
                "pcloud",
                "Godot",
                "DMScript"
            },
            role = {
                "AlarmWindow",
                "pop-up",
                "Preferences",
                "setup"
            }
        },
        properties = {
            floating    = true,
            placement    = awful.placement.centered
        },
        callback = function(c)
            awful.placement.centered(c)
        end
    },

    -- MAXIMIZED
    -----------------------------------------------------
    {
        rule_any = {
            class = {
                "mpv"
            }
        },
        properties = {
            maximized = true
        }
    },

    -- TAGS
    -----------------------------------------------------

    -- CHAT
    -------
    {
        rule = { class = "discord" },
        properties = {
            tag = " CHT "
        }
    },

    -- BROWSER
    ----------
    {
        rule_any = {
            class = {
                "firefox",
                "qutebrowser"
            }
        },
        properties = {
            tag             = " WWW ",
            switch_to_tags  = true
        }
    },

    -- VIRTUAL MACHINES
    -------------------
    {
        rule_any = {
            class = {
                "Virt-manager"
            }
        },
        properties = {
            tag                = " VRT ",
            switch_to_tags    = true
        }
    },

    -- DOCUMENTS
    ------------
    {
        rule_any = {
            class = {
                "Xreader",
            }
        },
        properties = {
            tag             = " DOC ",
            switch_to_tags  = true
        }
    },

    -- DMSCRIPT CLIENTS
    -----------------------------------------------------

    -- CLIENTS OPENED BY DMPASS SCRIPTS
    -----------------------------------
    {
        rule = { name = "PassAdd" },
        properties = {
            height = 120
        }
    },
    {
        rule = { class = "TaskList" },
        properties = {
            height = 800
        }
    },
}


-- =================================================== --
-- SIGNALS
-- =================================================== --

-- WINDOWS
---------------------------------------------------------

-- NEW WINDOW
-------------

local function new_window(c)

    -- Ensure window is accessible
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_posiion then
        awful.placement.no_offscreen(c)
    end

end

client.connect_signal("manage", new_window)

-- FOCUS WINDOW
---------------

local function focus_window(c)

    -- Change border color
    c.border_color = beautiful.border_focus

end

client.connect_signal("focus", focus_window)

-- UNFOCUS WINDOW
-----------------

local function unfocus_window(c)

    -- Change border color
    c.border_color = beautiful.border_normal

end

client.connect_signal("unfocus", unfocus_window)

-- SCRATCHPADS
---------------------------------------------------------

-- TURN ON
----------

local function scratch_on(c)
    c.fulscreen = true
end

for _, scratch in ipairs(scratchpads) do
    scratch:connect_signal("turn_on", scratch_on)
end


-- =================================================== --
-- AUTORUN
-- =================================================== --

-- Function to run a program only if it isn't already loading.
local function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- This is to fix my secondary monitor's screen resolution since my Xorg config files don't seem to apply
-- properly when using AwesomeWM and NVidia for some reason. There may be another way, but this works for me.
awful.spawn.with_shell("~/.screensize.sh")

-- Remap CapsLock key to Ctrl to make Ctrl+ keybindings more confortable.
awful.spawn.with_shell("xmodmap ~/.Xmodmap")

-- awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("feh --no-fehbg --bg-fill " .. wallpaper)

run_once("lxsession -a")
run_once("picom --experimental-backends")
run_once("nm-applet")
run_once("flameshot")
run_once("discord")
run_once("emacs --daemon")
run_once("ticktick")

awful.spawn.with_shell("pgrep -u $USER -x 'pcloud' > /dev/null || (~/Applications/pcloud)")
