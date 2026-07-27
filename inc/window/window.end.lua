--- @section EndWindow

--- Draws the end screen window.
--- @within EndWindow
function EndWindow.draw()
  cls(Config.colors.black)

  local cx   = Config.screen.width / 2
  local name = Context.player_name or "AAA"
  local code = CodeGenerator.encrypt(name)

  Print.text_center("~ GOOD ENDING ~",                     cx,  8, Config.colors.light_blue)
  Print.text_center("Congratulations, " .. name .. "!",    cx, 20, Config.colors.white)

  rectb(40, 29, 160, 36, Config.colors.blue)
  Print.text_center("your code",                           cx, 33, Config.colors.light_grey)
  Print.text_center(code,                                  cx, 44, Config.colors.white, false, 2)

  Print.text_center("Write it down!",                      cx, 70, Config.colors.item)

  line(20, 82, 219, 82, Config.colors.dark_grey)
  Print.text_center("To continue via telnet:",             cx, 87, Config.colors.light_grey)
  Print.text_center("teletypegames.org  2324",             cx, 98, Config.colors.white)
  line(20, 110, 219, 110, Config.colors.dark_grey)

  Print.text_center("Press Z to return to menu",           cx, 116, Config.colors.dark_grey)
end

--- Updates the end screen logic.
--- @within EndWindow
function EndWindow.update()
  if Input.select() then
    Context.reset()
    Window.set_current("menu")
    MenuWindow.refresh_menu_items()
  end
end
