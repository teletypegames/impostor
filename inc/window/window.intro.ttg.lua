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
  if not TTGIntroWindow.glitch_started then
    Glitch.show()
    TTGIntroWindow.glitch_started = true
  end

  local lines = {}
  local max_len = 0
  for line in TTGIntroWindow.text:gmatch("[^\r\n]+") do
    table.insert(lines, line)
    if #line > max_len then max_len = #line end
  end

  local char_w = 6
  local char_h = 7
  local y = (Config.screen.height - (#lines * char_h + 12)) / 2
  local x_offset = (Config.screen.width - (max_len * char_w)) / 2

  for i, line in ipairs(lines) do
    for j = 1, #line do
      local char = line:sub(j, j)
      if char == "#" then
        rect(x_offset + (j - 1) * char_w, y + (i - 1) * char_h, char_w - 1, char_h - 1, Config.colors.light_blue)
      end
    end
  end

  Print.text_center("Teletype Games", Config.screen.width / 2, y + #lines * char_h + 4, Config.colors.light_blue)
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
