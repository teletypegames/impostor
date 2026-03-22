--- @section AsciiArt
AsciiArt = {}

--- Draws ASCII art text using rectangles.
--- @param text string The ASCII art text to draw.
--- @param options table Configuration options (char_w, char_h, line_gap, word_gap, color, x, y).
function AsciiArt.draw(text, options)
  options = options or {}
  local char_w = options.char_w or 4
  local char_h = options.char_h or 5
  local line_gap = options.line_gap or 0
  local word_gap = options.word_gap or 6
  local color = options.color or Config.colors.light_blue

  local lines = {}
  local max_len = 0
  -- Get all lines and find max length
  for line in (text .. "\n"):gmatch("(.-)\n") do
    table.insert(lines, line)
    if #line > max_len then max_len = #line end
  end

  -- Clean up empty lines from the start/end
  while #lines > 0 and lines[1]:gsub("%s+", "") == "" do table.remove(lines, 1) end
  while #lines > 0 and lines[#lines]:gsub("%s+", "") == "" do table.remove(lines, #lines) end

  if #lines == 0 then return end

  local total_h = 0
  for _, line in ipairs(lines) do
    if line:find("#") then
      total_h = total_h + char_h + line_gap
    else
      total_h = total_h + word_gap
    end
  end
  total_h = total_h - line_gap

  local current_y = options.y or (Config.screen.height - total_h) / 2
  local x_offset = options.x or (Config.screen.width - (max_len * char_w)) / 2

  for _, line in ipairs(lines) do
    if line:find("#") then
      for j = 1, #line do
        local char = line:sub(j, j)
        if char == "#" then
          rect(x_offset + (j - 1) * char_w, current_y, char_w, char_h, color)
        end
      end
      current_y = current_y + char_h + line_gap
    else
      current_y = current_y + word_gap
    end
  end

  return {
    x = x_offset,
    y = options.y or (Config.screen.height - total_h) / 2,
    width = max_len * char_w,
    height = total_h,
    bottom = (options.y or (Config.screen.height - total_h) / 2) + total_h
  }
end
