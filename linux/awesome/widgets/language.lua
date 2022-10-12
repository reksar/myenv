--[[

Keyboard layout indicator and changer.
NOTE: the `setxkbmap` is the base control. This widget is just indicator.
TODO: switch layout on mouse click.

--]]


local awful = require("awful")
local g = require("gears")
local wibox = require("wibox")

local language = {}
language.widget = wibox.widget.textbox()


function language:update()
  self.widget:set_text(self.layouts[self.current_layout])
end


function language:switch()
  self.current_layout = self.current_layout % #(self.layouts) + 1
  self:update()
end


function language:bind_keys()
  local altkey = "Mod1"
  -- TODO: autodetect key combination
  self.keys = {
    awful.key({ altkey }, "Shift_L", function() self:switch() end, {
      description = "Switch language layout",
      group = "widgets",
    }),
    awful.key({ "Shift" }, "Alt_L", function() self:switch() end, {
      description = "Switch language layout",
      group = "widgets",
    }),
  }
end


-- Init layouts.
awful.spawn.easy_async_with_shell(
  "setxkbmap -query | grep layout | grep -o '[a-z,]\\+$'",
  -- Expected a line like "en,ru,..."
  function(stdout, stderr, reason, rc)
    language.layouts = g.table.map(string.upper, g.string.split(stdout, ","))
    language.current_layout = 1
    language:update()
  end)

language:bind_keys()
return language
