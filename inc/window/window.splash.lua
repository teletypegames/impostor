--- Draws the splash window.
function SplashWindow.draw()
  local txt = "Definitely not an Impostor"
  local w = #txt * 6
  local x = (240 - w) / 2
  local y = (136 - 6) / 2
  print(txt, x, y, 12)
end

--- Updates the splash window logic.
function SplashWindow.update()
  Context.splash_timer = Context.splash_timer - 1
  if Context.splash_timer <= 0 or Input.menu_confirm() then
    GameWindow.set_state(WINDOW_INTRO)
  end
end
