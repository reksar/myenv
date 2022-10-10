local awful = require("awful")
local mytable = awful.util.table


local function brightness(percent)
  return function()
    os.execute("xbacklight " .. percent)
  end
end


local function bind_keys(root)

  root.keys(mytable.join(root.keys(),
    -- TODO: XF86MonBrightnessCycle

    awful.key({}, "XF86MonBrightnessUp", brightness("+5"), {
      description = "Brightness +5%",
      group = "Fn",
    }),

    awful.key({}, "XF86MonBrightnessDown", brightness("-5"), {
      description = "Brightness -5%",
      group = "Fn",
    })
  ))
end


return function(root)
  bind_keys(root)
end
