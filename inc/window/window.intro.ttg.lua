--- @section TTGIntroWindow
TTGIntroWindow.timer = 180
TTGIntroWindow.glitch_started = false
TTGIntroWindow.space_count = 0
TTGIntroWindow.space_timer = 0
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

  -- Count enter presses during the intro
  if Input.enter() then
    TTGIntroWindow.space_count = TTGIntroWindow.space_count + 1
  end

  TTGIntroWindow.timer = TTGIntroWindow.timer - 1
  if TTGIntroWindow.timer <= 0 or Input.select() then
    -- Evaluate exactly 3 presses at the end of the intro
    if TTGIntroWindow.space_count == 3 then
      Context.test_mode = true
      MenuWindow.refresh_menu_items()
      Audio.sfx_success()
    end
    Glitch.hide()
    Window.set_current("intro_brief")
  end
end
