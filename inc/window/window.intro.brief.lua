--- @section BriefIntroWindow
BriefIntroWindow.y = Config.screen.height
BriefIntroWindow.speed = 30 -- pixels per second
BriefIntroWindow.text = [[
Norman Reds’ everyday life
seems ordinary: work,
meetings, coffee, and
endless notifications.
But beneath him, or around
him — something is
constantly building, and
it soon becomes clear
that there is more going
on than meets the eye.
]]

--- Draws the brief intro window.
--- @within BriefIntroWindow
function BriefIntroWindow.draw()
  local x = (Config.screen.width - 132) / 2
  Print.text(BriefIntroWindow.text, x, BriefIntroWindow.y, Config.colors.light_blue)
end

--- Updates the brief intro window logic.
--- @within BriefIntroWindow
function BriefIntroWindow.update()
  BriefIntroWindow.y = BriefIntroWindow.y - (BriefIntroWindow.speed * Context.delta_time)

  local lines = 1
  for _ in string.gmatch(BriefIntroWindow.text, "\n") do
    lines = lines + 1
  end

  if BriefIntroWindow.y < -lines * 8 or Input.select() or Input.menu_confirm() then
    Window.set_current("menu")
  end
end
