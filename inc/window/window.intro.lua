function IntroWindow.draw()
  local x = (Config.screen.width - 132) / 2
  Print.text(Context.intro.text, x, Context.intro.y, Config.colors.green)
end

function IntroWindow.update()
  Context.intro.y = Context.intro.y - Context.intro.speed

    local lines = 1
  for _ in string.gmatch(Context.intro.text, "\n") do
    lines = lines + 1
  end

    if Context.intro.y < -lines * 8 then
    GameWindow.set_state(WINDOW_MENU)
  end

    if Input.menu_confirm() then
    GameWindow.set_state(WINDOW_MENU)
  end
end