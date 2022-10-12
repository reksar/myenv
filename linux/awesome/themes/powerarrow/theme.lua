--[[

  Powerarrow Awesome WM theme
  From https://github.com/lcpz/awesome-copycats

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local math, string, os = math, string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Theme {{{
local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow"
theme.wallpaper                                 = theme.dir .. "/wall.png"
theme.font                                      = "Terminus 9"
theme.fg_normal                                 = "#FEFEFE"
theme.fg_focus                                  = "#32D6FF"
theme.fg_urgent                                 = "#C83F11"
theme.bg_normal                                 = "#222222"
theme.bg_focus                                  = "#1E2320"
theme.bg_urgent                                 = "#3F3F3F"
theme.taglist_fg_focus                          = "#00CCFF"
theme.tasklist_bg_focus                         = "#222222"
theme.tasklist_fg_focus                         = "#00CCFF"
theme.border_width                              = dpi(2)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#6F6F6F"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_brightness                         = theme.dir .. "/icons/brightness.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.battery_widget_icon                       = theme.dir .. "/icons/battery.png"
theme.net_widget_icon                           = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_music_pause                        = theme.dir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.dir .. "/icons/stop.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.widget_task                               = theme.dir .. "/icons/task.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = 0
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

theme.widgets = {
  language = require("widgets.language"),
}
-- }}}

local markup = lain.util.markup


function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height/2, 0

    -- Avoid going out of the (potential) clip area.
    -- NOTE: arrows has been removed.
    if arrow_depth < 0 then
        width  =  width + 2*arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth         , 0        )
    cr:line_to(offset + width               , 0        )
    cr:line_to(offset + width - arrow_depth , height/2 )
    cr:line_to(offset + width               , height   )
    cr:line_to(offset + arrow_depth         , height   )
    cr:line_to(offset                       , height/2 )

    cr:close_path()
end

-- Statusbar Widgets {{{

local function clock_widget()

  local clock = awful.widget.watch("date +'%R'", 60,
    function(widget, stdout)
      widget:set_markup(" " .. markup.font(theme.font, stdout))
    end)

  theme.calendar = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
      font = "Terminus 10",
      fg   = theme.fg_normal,
      bg   = theme.bg_normal
    },
  })

  return clock
end


local function net_widget()

  local net = lain.widget.net({
    settings = function()
      widget:set_markup(markup.fontfg(
        theme.font,
        "#FEFEFE",
        " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
    end,
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    net.widget,
  }
end


local function battery_widget()

  local icon = wibox.widget.imagebox(theme.battery_widget_icon)

  local battery = lain.widget.bat({
    settings = function()
      if bat_now.status and bat_now.status ~= "N/A" then
        if bat_now.ac_status == 1 then
          widget:set_markup(markup.font(theme.font, " AC "))
          icon:set_image(theme.widget_ac)
          return
        elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
          icon:set_image(theme.widget_battery_empty)
        elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
          icon:set_image(theme.widget_battery_low)
        else
          icon:set_image(theme.battery_widget_icon)
        end
        widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
      else
        widget:set_markup()
        icon:set_image(theme.widget_ac)
      end
    end
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    icon,
    battery.widget,
  }
end


local function temp_widget()

  local icon = wibox.widget.imagebox(theme.widget_temp)

  local function display()
    widget:set_markup(coretemp_now .. "°C")
  end

  local temp = lain.widget.temp({
    format = "%d",
    settings = display,
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    icon,
    temp.widget,
  }
end


local function cpu_widget()

  local icon = wibox.widget.imagebox(theme.widget_cpu)

  local function display()
    widget:set_markup(string.format("%03d%%", cpu_now.usage))
  end

  local cpu = lain.widget.cpu({
    settings = display,
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    icon,
    cpu.widget,
  }
end


local function mem_widget()

  local icon = wibox.widget.imagebox(theme.widget_mem)

  local mem = lain.widget.mem({
    settings = function()
      widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end,
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    icon,
    mem.widget,
  }
end


local function task_widget()

  -- Taskwarrior
  local task = wibox.widget.imagebox(theme.widget_task)

  local lain_task = lain.widget.contrib.task
  lain_task.attach(task, {
    -- do not colorize output
    show_cmd = "task | sed -r 's/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"
  })

  task:buttons(my_table.join(awful.button({}, 1, lain_task.prompt)))
  return task
end


local function player_widget()

  local icon = wibox.widget.imagebox(theme.widget_music)
  local player = awful.util.terminal .. " -title Music -g 130x34-320+16 -e ncmpcpp"

  icon:buttons(my_table.join(

    awful.button({ modkey }, 1, function()
      awful.spawn.with_shell(player)
    end),

    awful.button({}, 1, function()
      os.execute("mpc prev")
      theme.mpd.update()
    end),

    awful.button({}, 2, function()
      os.execute("mpc toggle")
      theme.mpd.update()
    end),

    awful.button({}, 3, function()
      os.execute("mpc next")
      theme.mpd.update()
    end)))

  theme.mpd = lain.widget.mpd({
    settings = function()
      if mpd_now.state == "play" then
        artist = " " .. mpd_now.artist .. " "
        title  = mpd_now.title  .. " "
        icon:set_image(theme.widget_music_on)
        widget:set_markup(markup.font(theme.font, markup("#FF8466", artist) .. " " .. title))
      elseif mpd_now.state == "pause" then
        widget:set_markup(markup.font(theme.font, " mpd paused "))
        icon:set_image(theme.widget_music_pause)
      else
        widget:set_text("")
        icon:set_image(theme.widget_music)
      end
    end,
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    icon,
    theme.mpd.widget,
  }
end


local function mail_widget()

  local icon = wibox.widget.imagebox(theme.widget_mail)
  icon:buttons(my_table.join(awful.button({}, 1, function()
    awful.spawn(mail)
  end)))

  -- Mail IMAP check. Needs to be set before use.
  theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
      if mailcount > 0 then
        widget:set_text(" " .. mailcount .. " ")
        icon:set_image(theme.widget_mail_on)
      else
        widget:set_text("")
        icon:set_image(theme.widget_mail)
      end
    end,
  })

  return wibox.widget{
    layout = wibox.layout.align.horizontal,
    icon,
    theme.mail.widget,
  }
end

-- }}}

-- Statusbar {{{

local function statusbar_layout(screen)
  local left = wibox.layout.fixed.horizontal(
    screen.mytaglist,
    screen.mypromptbox)
  local middle = screen.mytasklist
  local bg = wibox.container.background
  local margin = wibox.container.margin
  local right = wibox.layout.fixed.horizontal(
    wibox.widget.systray(),
    margin(task_widget(), dpi(3), dpi(7)),
    margin(net_widget(), dpi(3), dpi(3)),
    bg(margin(mem_widget(), dpi(2), dpi(3)), "#777E76"),
    bg(margin(cpu_widget(), dpi(3), dpi(4)), "#4B696D"),
    bg(margin(temp_widget(), dpi(4), dpi(4)), "#4B3B51"),
    bg(margin(battery_widget(), dpi(3), dpi(3)), "#8DAA9A"),
    margin(theme.widgets.language.widget, dpi(3), dpi(3)),
    margin(clock_widget(), dpi(4), dpi(8)),
    screen.mylayoutbox)
  return wibox.layout.align.horizontal(left, middle, right)
end


local function statusbar(screen)
  return awful.wibar{
    screen = screen,
    position = "bottom",
    height = dpi(16),
    bg = theme.bg_normal,
    fg = theme.fg_normal,
    widget = statusbar_layout(screen),
  }
end

-- }}}

-- Screen connect {{{

function theme.at_screen_connect(screen)

  gears.wallpaper.maximized(theme.wallpaper, screen, true)

  -- Tags
  awful.tag(awful.util.tagnames, screen, awful.layout.layouts[1])

  -- Quake application
  screen.quake = lain.util.quake({ app = awful.util.terminal })

  screen.mypromptbox = awful.widget.prompt()

  -- Create the imagebox widget which will contain an icon indicating which
  -- layout we're using. One mylayoutbox per screen.
  screen.mylayoutbox = awful.widget.layoutbox(screen)
  screen.mylayoutbox:buttons(my_table.join(
    awful.button({}, 1, function() awful.layout.inc( 1) end),
    awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc( 1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)))

  screen.mytaglist = awful.widget.taglist(
    screen,
    awful.widget.taglist.filter.all,
    awful.util.taglist_buttons)

  screen.mytasklist = awful.widget.tasklist(
    screen,
    awful.widget.tasklist.filter.currenttags,
    awful.util.tasklist_buttons)

  screen.mywibox = statusbar(screen)
end

-- }}}


return theme
