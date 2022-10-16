--[[

Brightness key bindings and notify.

--]]


local awful = require("awful")
local naughty = require("naughty")

local async_shell = awful.spawn.easy_async_with_shell


local function keys(brightness)

  local calibre = 2
  local percent_up = string.format("+%u", calibre)
  local percent_down = string.format("-%u", calibre)


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
  brightness.keys = keys(brightness)


  brightness.set = function(percent)
    async_shell("xbacklight " .. percent, brightness.show_popup)
  end


  brightness.show_popup = function()
    async_shell("xbacklight", brightness.notify)
  end


  brightness.notify = function(actual_percent)

    if brightness.popup then
      brightness.popup.die()
    end

    brightness.popup = naughty.notify{
      text = string.format("Brightness %u%%", math.ceil(actual_percent)),
      position = "top_middle",
    }
  end


  return brightness
end
