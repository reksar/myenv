local awful = require("awful")


local function brightness(percent)
  return function()
    awful.spawn.with_shell("xbacklight " .. percent)
  end
end


root.keys(awful.util.table.join(root.keys(),
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
