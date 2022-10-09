--[[

ALSA volume control.

Creates the `theme.volume` widget that the `beautiful.volume` will connect to.
Adds `globalkeys` bindings to control the audio volume with `beautiful.volume`.

--]]


local awful = require("awful")
local lain = require("lain")

local mytable = awful.util.table


local function add_widget(beautiful)
  local theme = beautiful.get()
  theme.volume = lain.widget.alsabar({})
end


local function set(volume, value)
  return function()
    os.execute(string.format("amixer -q set %s %s", volume.channel, value))
    volume.update()
  end
end


local function bind_keys(root, beautiful)

  local volume = beautiful.volume

  root.keys(mytable.join(root.keys(),

    awful.key({}, "XF86AudioRaiseVolume", set(volume, "1%+"), {
      description = "Volume +1%",
      group = "Fn",
    }),

    awful.key({}, "XF86AudioLowerVolume", set(volume, "1%-"), {
      description = "Volume -1%",
      group = "Fn",
    }),

    awful.key({}, "XF86AudioMute", set(volume, "toggle"), {
      description = "Volume Mute / Unmute",
      group = "Fn",
    })
  ))
end


return function(root, beautiful)
  add_widget(beautiful)
  bind_keys(root, beautiful)
end
