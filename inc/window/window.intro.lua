--- @section IntroWindow
IntroWindow.y = Config.screen.height
IntroWindow.speed = 0.5
IntroWindow.text = [[
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

--- Draws the intro window.
--- @within IntroWindow
function IntroWindow.draw()
  local x = (Config.screen.width - 132) / 2
  Print.text(IntroWindow.text, x, IntroWindow.y, Config.colors.green)
end

--- Updates the intro window logic.
--- @within IntroWindow
function IntroWindow.update()
  IntroWindow.y = IntroWindow.y - IntroWindow.speed

  local lines = 1
  for _ in string.gmatch(IntroWindow.text, "\n") do
    lines = lines + 1
  end

  if IntroWindow.y < -lines * 8 then
    Window.set_current("menu")
  end

  if Input.menu_confirm() then
    Window.set_current("menu")
  end
end
