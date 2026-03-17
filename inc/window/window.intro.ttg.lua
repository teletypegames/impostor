--- @section TTGIntroWindow
TTGIntroWindow.timer = 180
TTGIntroWindow.glitch_started = false
TTGIntroWindow.text = [[
###### ###### ######
  ##     ##   #
  ##     ##   # ####
  ##     ##   #    #
  ##     ##   ######
]]

--- Draws the TTG intro window.
--- @within TTGIntroWindow
function TTGIntroWindow.draw()
  local bounds = AsciiArt.draw(TTGIntroWindow.text, {})
  if not bounds then return end
  Print.text_center("Teletype Games", (Config.screen.width / 2 + 3) , (bounds.bottom + 4), Config.colors.light_blue)
end

--- Updates the TTG intro window logic.
--- @within TTGIntroWindow
function TTGIntroWindow.update()
  if not TTGIntroWindow.glitch_started then
    Glitch.show()
    TTGIntroWindow.glitch_started = true
  end

  TTGIntroWindow.timer = TTGIntroWindow.timer - 1
  if TTGIntroWindow.timer <= 0 or Input.select() or Input.menu_confirm() then
    Glitch.hide()
    Window.set_current("intro_brief")
  end
end
