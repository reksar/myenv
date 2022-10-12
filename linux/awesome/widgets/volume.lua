--[[

ALSA volume control.

Creates the `theme.volume` widget that the `beautiful.volume` will connect to.
Adds `globalkeys` bindings to control the audio volume with `beautiful.volume`.

--]]


local awful = require("awful")
local beautiful = require("beautiful")
local lain = require("lain")


local function add_widget(beautiful)
  local theme = beautiful.get()
  theme.volume = lain.widget.alsabar({})
end


local function set(volume, value)
  return function()
    awful.spawn.with_shell(
      string.format(
        "amixer -q set %s %s",
        volume.channel,
        value))
    volume.update()
  end
end


local function bind_keys(beautiful)
  -- NOTE: Requires `beautiful.volume` from `lain.widget.alsabar`, so init the
  -- alsabar to make these bindings work.

  local volume = beautiful.volume

  root.keys(awful.util.table.join(root.keys(),

    awful.key({}, "XF86AudioRaiseVolume", set(volume, "2%+"), {
      description = "Volume +2%",
      group = "Fn",
    }),

    awful.key({}, "XF86AudioLowerVolume", set(volume, "2%-"), {
      description = "Volume -2%",
      group = "Fn",
    }),

    awful.key({}, "XF86AudioMute", set(volume, "toggle"), {
      description = "Volume Mute / Unmute",
      group = "Fn",
    })
  ))
end


add_widget(beautiful)
bind_keys(beautiful)
