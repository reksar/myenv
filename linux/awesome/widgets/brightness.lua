--[[

Brightness key bindings and notify.

--]]


local awful = require("awful")
local naughty = require("naughty")

local async_shell = awful.spawn.easy_async_with_shell


local function keys(brightness)

  local percent_up = string.format("+%u", brightness.calibre)
  local percent_down = string.format("-%u", brightness.calibre)


  local function up()
    brightness.set(percent_up)
  end


  local function down()
    brightness.set(percent_down)
  end


  return {
    awful.key({}, "XF86MonBrightnessUp", up, {
      description = "Brightness " .. percent_up,
      group = "Fn",
    }),
    awful.key({}, "XF86MonBrightnessDown", down, {
      description = "Brightness " .. percent_down,
      group = "Fn",
    }),
    -- TODO: XF86MonBrightnessCycle
  }
end


return function()

  local brightness = {}
  brightness.calibre = 5
  brightness.keys = keys(brightness)

  brightness.popup = {}
  brightness.popup.preset = {
    position = "top_middle",
  }


  brightness.set = function(percent)
    async_shell("xbacklight " .. percent, brightness.notify)
  end


  brightness.notify = function()
    async_shell("xbacklight", brightness.popup.show)
  end


  brightness.popup.show = function(current_percent)
    brightness.popup.widget = naughty.notify{
      preset = brightness.popup.preset,
      text = string.format("Brigntness %u%%", math.ceil(current_percent)),
    }
  end


  return brightness
end
