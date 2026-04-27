--- @section EndWindow

--- Draws the end screen window.
--- @within EndWindow
function EndWindow.draw()
  cls(Config.colors.black)

  if Context._end.state == "choice" then
    local lines = {
      "This is not a workplace.",
      "This is a cycle.",
      "And if it is a cycle...",
      "it can be broken."
    }

    local y = 40
    for _, line in ipairs(lines) do
      Print.text_center(line, Config.screen.width / 2, y, Config.colors.white)
      y = y + 10
    end

    y = y + 20
    local yes_color = Context._end.selection == 1 and Config.colors.light_blue or Config.colors.white
    local no_color = Context._end.selection == 2 and Config.colors.light_blue or Config.colors.white

    local yes_text = (Context._end.selection == 1 and "> YES" or "  YES")
    local no_text = (Context._end.selection == 2 and "> NO" or "  NO")

    local centerX = Config.screen.width / 2
    Print.text(yes_text, centerX - 40, y, yes_color)
    Print.text(no_text, centerX + 10, y, no_color)
  elseif Context._end.state == "ending" then
    local cx   = Config.screen.width / 2
    local name = Context.player_name or "AAA"
    local code = CodeGenerator.encrypt(name)
    Print.text_center("Game over -- good ending.",          cx, 40, Config.colors.light_blue)
    Print.text_center("Congrats " .. name .. "!",          cx, 54, Config.colors.white)
    Print.text_center("Your personal code:",        cx, 72, Config.colors.light_grey)
    Print.text_center(code,                         cx, 84, Config.colors.white, false, 3)
    Print.text_center("Write it down!",             cx, 112, Config.colors.item)
    Print.text_center("Press Z to return to menu",  cx, 126, Config.colors.dark_grey)
  end
end

--- Updates the end screen logic.
--- @within EndWindow
function EndWindow.update()
  if Context._end.state == "choice" then
    if Input.left() or Input.up() then
      if Context._end.selection == 2 then
        Audio.sfx_beep()
        Context._end.selection = 1
      end
    elseif Input.right() or Input.down() then
      if Context._end.selection == 1 then
        Audio.sfx_beep()
        Context._end.selection = 2
      end
    end

    if Input.select() then
      Audio.sfx_select()
      if Context._end.selection == 1 then
        Context._end.state = "ending"
      else
        -- NO: increment day and go home
        Day.increase()
        Util.go_to_screen_by_id("home")
        Window.set_current("game")
        -- Initialize home screen
        local home_screen = Screen.get_by_id("home")
        if home_screen and home_screen.init then
          home_screen.init()
        end
      end
    end
  elseif Context._end.state == "ending" then
    if Input.select() then
      Window.set_current("menu")
      MenuWindow.refresh_menu_items()
    end
  end
end
