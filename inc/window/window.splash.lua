--- @section SplashWindow

--- Draws the splash window.
--- @within SplashWindow
function SplashWindow.draw()
  local txt = "Definitely not an Impostor"
  local y = (Config.screen.height - 6) / 2
  Print.text_center(txt, Config.screen.width / 2, y, Config.colors.white)
end

--- Updates the splash window logic.
--- @within SplashWindow
function SplashWindow.update()
  Context.splash_timer = Context.splash_timer - 1
  if Context.splash_timer <= 0 or Input.menu_confirm() then
    Window.set_current("intro")
  end
end
