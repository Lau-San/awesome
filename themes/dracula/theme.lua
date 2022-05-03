-- =================================================== --
-- ------------ AWESOME WM DRACULA THEME ------------- --
-- =================================================== --
--
-- An Awesome WM theme inpired by the popular Dracula
-- theme (draculatheme.com).
--
-- DEPENDENCIES
-- ------------
--
-- FONTS
-- -----
-- -> Ubuntu
-- -> Dosis


-- =================================================== --
-- IMPORTS
-- =================================================== --

local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")

local lain          = require("lain")
local markup        = lain.util.markup
local separators    = lain.util.separators


-- =================================================== --
-- THEME SETUP
-- =================================================== --

local theme     = {}
theme.name      = "dracula"
theme.dir       = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme.name
theme.icons_dir = theme.dir .. "/icons/"


-- =================================================== --
-- GENERAL SETTINGS
-- =================================================== --

-- FONTS
---------------------------------------------------------
theme.font          = "Ubuntu 12"
theme.taglist_font  = "Dosis Bold 14"

-- WALLPAPER
theme.wallpaper     = theme.dir .. "/wallpaper.png"

-- COLOR PALETTE
---------------------------------------------------------

local colors    = {}
colors.black    = "#282a36"
colors.gray     = "#44475a"
colors.white    = "#f8f8f2"
colors.blue     = "#6272a4"
colors.cyan     = "#8be9fd"
colors.green    = "#50fa7b"
colors.orange   = "#ffb86c"
colors.pink     = "#ff79c6"
colors.purple   = "#bd93f9"
colors.red      = "#ff5555"
colors.yellow   = "#f1fa8c"

-- =================================================== --
-- GENERAL COLORS
-- =================================================== --

theme.bg_normal     = colors.black
theme.fg_normal     = colors.white
theme.bg_focus      = colors.black
theme.fg_focus      = colors.cyan
theme.bg_urgent     = colors.black
theme.fg_urgent     = colors.red


-- =================================================== --
-- PROMPT (DMENU)
-- =================================================== --

theme.prompt_bg         = colors.black
theme.prompt_fg         = colors.white
theme.prompt_focus_bg   = colors.blue
theme.prompt_focus_fg   = colors.white


-- =================================================== --
-- STATUS BAR
-- =================================================== --

theme.bar_height    = 22
theme.bar_bg        = colors.black
theme.bar_fg        = colors.white


-- =================================================== --
-- TAGS
-- =================================================== --

-- EMPTY
theme.taglist_bg_empty      = colors.black
theme.taglist_fg_empty      = colors.blue
-- OCCUPIED
theme.taglist_bg_occupied   = colors.black
theme.taglist_fg_occupied   = colors.purple
-- FOCUS
theme.taglist_bg_focus      = colors.blue
theme.taglist_fg_focus      = colors.white
-- URGENT
theme.taglist_bg_urgent     = colors.red
theme.taglist_fg_urgent     = colors.white


-- =================================================== --
-- WINDOWS
-- =================================================== --

-- BORDERS
---------------------------------------------------------

theme.border_width  = 2
theme.border_normal = colors.gray
theme.border_focus  = colors.purple
theme.border_marked = colors.pink

-- SPACE BETWEEN WINDOWS
------------------------

theme.useless_gap   = 4


-- =================================================== --
-- WIDGETS
-- =================================================== --

local widget_spacing    = 8
local icon_size         = 18
local icon_margin_top   = (theme.bar_height - icon_size) // 2

-- SEPARATOR
------------

local separator = wibox.widget {
    layout  = wibox.layout.fixed.horizontal,

    separators.arrow_left("alpha", colors.gray),
    separators.arrow_left(colors.gray, "alpha"),
}

-- TEXT CLOCK
---------------------------------------------------------

-- COLORS
---------

theme.widget_clock_bg   = colors.gray
theme.widget_clock_fg   = colors.green

-- WIDGET SETUP
---------------

local clock_widget = wibox.widget {
    layout  = wibox.container.margin,
    bottom  = widget_vertical_offset,
    left    = widget_spacing,
    right   = widget_spacing,

    {
        widget  = wibox.widget.textclock,
        refresh = 60,
        format  = markup.fontfg(
            theme.font,
            theme.widget_clock_fg,
            "%b %a, %d %I:%M %p"
        )
    }
}

-- BATTERY
---------------------------------------------------------

-- COLORS
---------

theme.widget_battery_bg     = colors.gray
theme.widget_battery_fg     = colors.cyan
theme.widget_battery_low_fg = colors.red

-- ICONS
--------

-- AC STATE
theme.widget_battery_icon_ac = theme.icons_dir .. "ac.png"

-- BATTERY LEVELS
theme.widget_battery_icon_0 = theme.icons_dir .. "battery_0.png"
theme.widget_battery_icon_1 = theme.icons_dir .. "battery_1.png"
theme.widget_battery_icon_2 = theme.icons_dir .. "battery_2.png"
theme.widget_battery_icon_3 = theme.icons_dir .. "battery_3.png"
theme.widget_battery_icon_4 = theme.icons_dir .. "battery_4.png"
theme.widget_battery_icon_5 = theme.icons_dir .. "battery_5.png"
theme.widget_battery_icon_6 = theme.icons_dir .. "battery_6.png"
theme.widget_battery_icon_7 = theme.icons_dir .. "battery_7.png"

-- WIDGET SETUP
---------------

-- ICON WIDGET
local battery_icon = wibox.widget {
    widget          = wibox.widget.imagebox,
    image           = theme.widget_battery_icon_ac,
    forced_width    = icon_size,
    forced_height   = icon_size
}
local battery_widget_icon = wibox.widget {
    layout  = wibox.container.margin,
    top     = icon_margin_top,

    battery_icon
}

-- INFO WIDGET
local battery_widget_info = lain.widget.bat {

    -- REFRESH RATE
    timeout = 30,

    -- UPDATE FUNCTION
    settings = function()
       if bat_now.status and bat_now.status ~= "N/A" then
          -- THERE IS A BATTERY

          -- Set battery markup
          widget:set_markup(
             markup.fontfg(
                theme.font,
                theme.widget_battery_fg,
                bat_now.perc .. "%"
             )
          )

          if bat_now.ac_status == 1 then
             -- AC STATUS IS ON

             battery_icon:set_image(theme.widget_battery_icon_ac)
          else
             -- AC STATUS IS OFF

             -- Icon progression
             if tonumber(bat_now.perc) >= 95 then
                 battery_icon:set_image(theme.widget_battery_icon_7)
             elseif tonumber(bat_now.perc) >= 75 then
                 battery_icon:set_image(theme.widget_battery_icon_6)
             elseif tonumber(bat_now.perc) >= 65 then
                 battery_icon:set_image(theme.widget_battery_icon_5)
             elseif tonumber(bat_now.perc) >= 45 then
                 battery_icon:set_image(theme.widget_battery_icon_4)
             elseif tonumber(bat_now.perc) >= 35 then
                 battery_icon:set_image(theme.widget_battery_icon_3)
             elseif tonumber(bat_now.perc) >= 25 then
                 battery_icon:set_image(theme.widget_battery_icon_2)
             elseif tonumber(bat_now.perc) >= 15 then
                 battery_icon:set_image(theme.widget_battery_icon_1)
             else
                 battery_icon:set_image(theme.widget_battery_icon_0)
             end

             if tonumber(bat_now.perc) <= 15 then
                -- BATTERY IS TOO LOW

                widget:set_markup(
                   markup.fontfg(
                      theme.font,
                      theme.widget_battery_low_fg,
                      markup.bold(bat_now.perc .. "%")
                   )
                )
             end
          end


       else
          -- THERE IS NO BATTERY

          battery_icon:set_image(theme.widget_battery_icon_ac)
          widget:set_markup()
       end
    end
}

local battery_widget = wibox.widget {
    layout  = wibox.container.margin,
    left    = widget_spacing ,
    right   = widget_spacing,

    {
        layout  = wibox.layout.fixed.horizontal,

        battery_widget_icon,
        {
            layout  = wibox.container.margin,
            left    = widget_spacing // 2,

            battery_widget_info
        }
    }
}

-- VOLUME
---------------------------------------------------------

-- COLORS
---------

theme.widget_volume_bg  = colors.black
theme.widget_volume_fg  = colors.cyan

-- ICONS
--------

theme.widget_volume_icon_low    = theme.icons_dir .. "volume_0.png"
theme.widget_volume_icon_med    = theme.icons_dir .. "volume_1.png"
theme.widget_volume_icon_high   = theme.icons_dir .. "volume_2.png"
theme.widget_volume_icon_mute   = theme.icons_dir .. "volume_off.png"

-- WIDGET SETUP
---------------

-- WIDGET ICON
local volume_icon = wibox.widget {
    widget          = wibox.widget.imagebox,
    image           = theme.widget_volume_icon_high,
    forced_width    = icon_size,
    forced_height   = icon_size
}
local volume_widget_icon = wibox.widget {
    layout     = wibox.container.margin,
    top        = icon_margin_top,

    volume_icon
}

-- WIDGET INFO
theme.volume = lain.widget.alsa {
    timeout = 1,
    settings = function ()
        if volume_now.status == "on" then
            widget:set_markup(
                markup.fontfg(
                    theme.font,
                    theme.widget_volume_fg,
                    volume_now.level .. "%"
                )
            )

            if volume_now.level <= 15 then
                volume_icon:set_image(theme.widget_volume_icon_low)
            elseif volume_now.level <= 75 then
                volume_icon:set_image(theme.widget_volume_icon_med)
            else
                volume_icon:set_image(theme.widget_volume_icon_high)
            end
        else
            volume_icon:set_image(theme.widget_volume_icon_mute)
            widget:set_markup()
        end
    end,
}

-- VOLUME WIDGET
local volume_widget = wibox.widget {
    layout  = wibox.container.margin,
    left    = widget_spacing,
    right   = widget_spacing,

    {
        layout = wibox.layout.fixed.horizontal,

        volume_widget_icon,
        {
            layout  = wibox.container.margin,
            left    = widget_spacing // 2,

            theme.volume
        }
    }
}

-- NETWORK
---------------------------------------------------------

-- COLORS
---------

theme.widget_net_bg = colors.black
theme.widget_net_fg = colors.cyan

-- ICONS
--------

theme.widget_net_icon   = theme.icons_dir .. "network.png"

-- WIDGET SETUP
---------------

-- ICON WIDGET
local net_icon = wibox.widget {
    widget          = wibox.widget.imagebox,
    image           = theme.widget_net_icon,
    forced_width    = icon_size,
    forced_height   = icon_size
}
local net_widget_icon = wibox.widget {
    layout  = wibox.container.margin,
    top     = icon_margin_top,

    net_icon
}

-- INFO WIDGETS
local net_widget_down       = wibox.widget.textbox()
local net_widget_up         = wibox.widget.textbox()
local net_widget_separator  = wibox.widget.textbox()

-- WIDGET UPDATE
local net_update = lain.widget.net {
    wifi_state = "on",
    settings = function()
        net_icon:set_image(theme.widget_net_icon)
        net_widget_down:set_markup(
            markup.fontfg(
                theme.font,
                theme.widget_net_fg,
                net_now.received
            )
        )
        net_widget_up:set_markup(
            markup.fontfg(
                theme.font,
                theme.widget_net_fg,
                net_now.sent
            )
        )
        net_widget_separator:set_markup(
            markup.fontfg(
                theme.font,
                colors.white,
                " ↓↑ "
            )
        )
    end
}

-- NETWORK WIDGET
local net_widget = wibox.widget {
    layout  = wibox.container.margin,
    left    = widget_spacing,
    right   = widget_spacing,

    {
        layout = wibox.layout.fixed.horizontal,

        net_widget_icon,
        {
            layout  = wibox.container.margin,
            left    = widget_spacing // 2,

            {
                layout = wibox.layout.fixed.horizontal,

                net_widget_down,
                net_widget_separator,
                net_widget_up
            }
        }
    }
}

-- =================================================== --

function theme.at_screen_connect(s)

    -- Set wallpaper
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
       wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s)

     -- Set default layout
     awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Layout button widget
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(gears.table.join(
       awful.button({ }, 1, function () awful.layout.inc(1) end),
       awful.button({ }, 3, function () awful.layout.inc(-1) end)
    )))

    -- Taglist widget
    s.mytaglist = awful.widget.taglist {
       screen = s,
       filter = awful.widget.taglist.filter.all,
       buttons = awful.util.taglist_buttons
    }

    -- Takslist widget (shows only minimized clients)
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.minimizedcurrenttags,
        layout  = {
            layout          = wibox.layout.fixed.horizontal,
            spacing         = 1,
            spacing_widget  = {
                widget  = wibox.container.place,
                valign  = "center",
                halign  = "center",

                {
                    widget          = wibox.widget.separator,
                    forced_width    = 5,
                    forced_height   = 18,
                    thickness       = 1,
                    color           = colors.blue
                }
            }
        },
        widget_template = {
            layout = wibox.layout.align.vertical,
            {
                widget  = wibox.container.margin,
                margins = 5,
                {
                    widget  = awful.widget.clienticon,
                    id      = "clienticon"
                }
            },
            nil,
            create_callback = function(self, c, index, objects)
                self:get_children_by_id("clienticon")[1].client = c
            end
        }
    }

    -- System Tray widget
    s.mysystray = wibox.widget {
        layout  = awful.widget.only_on_screen,
        screen  = s.primary,

        {
            layout = wibox.layout.fixed.horizontal,

            -- Adding this separator it only appears in primary monitor
            -- instead of having double separators in monitors without system tray.
            separator,
            {
                layout  = wibox.container.margin,
                top     = icon_margin_top,
                left    = widget_spacing,
                right   = widget_spacing,

                {
                    widget = wibox.widget.systray,
                    create_callback = function(self)
                        self:set_base_size(18)
                    end
                }
            },
        }
    }

    -- Create status bar
    s.mywibox = awful.wibar({
       position = "top",
       screen   = s,
       opacity  = 0.9,
       height   = theme.bar_height,
       bg       = theme.bar_bg,
       fg       = theme.bar_fg
    })

    -- Add widgets to the status bar
    s.mywibox:setup {
       layout = wibox.layout.align.horizontal,

       -- LEFT WIDGETS
       ---------------
       {
          layout = wibox.layout.fixed.horizontal,

          s.mytaglist
       },

       -- MIDDLE WIDGETS
       -----------------

       s.mytasklist,

       -- RIGHT WIDGETS
       ----------------
       {
          layout = wibox.layout.fixed.horizontal,

          separator,
          net_widget,
          separator,
          volume_widget,
          separator,
          battery_widget,
          separator,
          clock_widget,
          -- Implicit separator here, since systray contains a separator so that
          -- the screen that doesn't have a systray doesn't draw two separators
          -- next to eachother.
          s.mysystray,
          separator,
          {
              layout    = wibox.container.margin,
              left      = widget_spacing,
              right     = widget_spacing,

              s.mylayoutbox
          }
       }
    }
end

return theme
