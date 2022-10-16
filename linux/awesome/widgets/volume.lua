--[[

ALSA volume control. Creates the `theme.volume` and binds keys to.

--]]


local awful = require("awful")
local lain = require("lain")
local naughty = require("naughty")

local async_shell = awful.spawn.easy_async_with_shell
local fmt = string.format


local function set(volume, value)

  local set_volume = fmt("amixer -q set %s %s", volume.widget.channel, value)

  return function()
    async_shell(set_volume, function()
      volume.widget.update()
      volume.show_popup()
    end)
  end
end


local function keys(volume)
  local calibre = 2
  return {
    awful.key({}, "XF86AudioRaiseVolume", set(volume, calibre .. "%+"), {
      description = fmt("Volume +%u%%", calibre),
      group = "Fn",
    }),
    awful.key({}, "XF86AudioLowerVolume", set(volume, calibre .. "%-"), {
      description = fmt("Volume -%u%%", calibre),
      group = "Fn",
    }),
    awful.key({}, "XF86AudioMute", set(volume, "toggle"), {
      description = "Volume Mute/Unmute",
      group = "Fn",
    }),
  }
end


return function(theme)

  -- Some third-party widgets expects that a theme has this property.
  theme.volume = lain.widget.alsabar{}

  local volume = {}
  volume.widget = theme.volume
  volume.keys = keys(volume)


  volume.show_popup = function()
    local get_actual_volume = fmt("amixer get %s", volume.widget.channel)
      .. "| grep -i playback | grep -o '[0-9]\\+%' | sort | tail -1"
    async_shell(get_actual_volume, volume.notify)
  end


  volume.notify = function(actual_percent)

    if volume.popup then
      volume.popup.die()
    end

    volume.popup = naughty.notify{
      text = "Volume " .. actual_percent,
      position = "top_middle",
    }
  end


  return volume
end
