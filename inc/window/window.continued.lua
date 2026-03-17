--- @section ContinuedWindow
ContinuedWindow.timer = 300 -- 5 seconds at 60fps
ContinuedWindow.text = [[
### ###     ### ###
 #  # #     # # #
 #  # #     ### ##
 #  # #     # # #
 #  ###     ### ###

### ### #  # ### ### #  # # # ### ##
#   # # ## #  #   #  ## # # # #   # #
#   # # # ##  #   #  # ## # # ##  # #
#   # # #  #  #   #  #  # # # #   # #
### ### #  #  #  ### #  # ### ### ##

]]

--- Draws the continued window.
--- @within ContinuedWindow
function ContinuedWindow.draw()
  cls(Config.colors.black)
  local lines = {}
  local max_len = 0
  -- Get all lines and find max length
  for line in (ContinuedWindow.text .. "\n"):gmatch("(.-)\n") do
    table.insert(lines, line)
    if #line > max_len then max_len = #line end
  end

  -- Clean up empty lines from the start/end
  if #lines > 0 and lines[1] == "" then table.remove(lines, 1) end
  if #lines > 0 and lines[#lines] == "" then table.remove(lines, #lines) end

  local char_w = 4
  local char_h = 5
  local line_gap = 0
  local word_gap = 6

  local total_h = 0
  for _, line in ipairs(lines) do
    if line:find("#") then
      total_h = total_h + char_h + line_gap
    else
      total_h = total_h + word_gap
    end
  end
  total_h = total_h - line_gap

  local current_y = (Config.screen.height - total_h) / 2
  local x_offset = (Config.screen.width - (max_len * char_w)) / 2

  for _, line in ipairs(lines) do
    if line:find("#") then
      for j = 1, #line do
        local char = line:sub(j, j)
        if char == "#" then
          rect(x_offset + (j - 1) * char_w, current_y, char_w - 1, char_h - 1, Config.colors.light_blue)
        end
      end
      current_y = current_y + char_h + line_gap
    else
      current_y = current_y + word_gap
    end
  end
end

--- Updates the continued window logic.
--- @within ContinuedWindow
function ContinuedWindow.update()
  ContinuedWindow.timer = ContinuedWindow.timer - 1
  if ContinuedWindow.timer <= 0 or Input.select() or Input.menu_confirm() then
    Window.set_current("menu")
    MenuWindow.refresh_menu_items()
  end
end
