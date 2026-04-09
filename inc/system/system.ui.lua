--- @section UI

--- Draws the top bar.
--- @within UI
--- @param title string The title text to display.<br/>
function UI.draw_top_bar(title)
  rect(0, 0, Config.screen.width, 10, Config.colors.dark_grey)
  Print.text(title, 3, 2, Config.colors.light_blue)
end

--- Draws a menu.
--- @within UI
--- @param items table A table of menu items.<br/>
--- @param selected_item number The index of the currently selected item.<br/>
--- @param x number The x-coordinate for the menu (ignored if centered is true).<br/>
--- @param y number The y-coordinate for the menu.<br/>
--- @param[opt] centered boolean Whether to center the menu block horizontally. Defaults to false.<br/>
function UI.draw_menu(items, selected_item, x, y, centered)
  if centered then
    local max_w = 0
    for _, item in ipairs(items) do
      local w = print(item.label, 0, -10, 0, false, 1, false)
      if w > max_w then max_w = w end
    end
    x = (Config.screen.width - max_w) / 2
  end

  for i, item in ipairs(items) do
    local current_y = y + (i-1)*10
    if i == selected_item then
      Print.text(">", x - 8, current_y, Config.colors.light_blue)
    end
    Print.text(item.label, x, current_y, Config.colors.light_blue)
  end
end

--- Updates menu selection.
--- @within UI
--- @param items table A table of menu items.<br/>
--- @param selected_item number The current index of the selected item.<br/>
--- @param[opt] x number Menu x position (required for mouse support).<br/>
--- @param[opt] y number Menu y position (required for mouse support).<br/>
--- @param[opt] centered boolean Whether the menu is centered horizontally.<br/>
--- @return number selected_item The updated index of the selected item.
--- @return boolean mouse_confirmed True if the user clicked on a menu item.
function UI.update_menu(items, selected_item, x, y, centered)
  if Input.up() then
    Audio.sfx_beep()
    selected_item = selected_item - 1
    if selected_item < 1 then
      selected_item = #items
    end
  elseif Input.down() then
    Audio.sfx_beep()
    selected_item = selected_item + 1
    if selected_item > #items then
      selected_item = 1
    end
  end

  if x ~= nil and y ~= nil then
    local menu_x = x
    if centered then
      local max_w = 0
      for _, item in ipairs(items) do
        local w = print(item.label, 0, -10, 0, false, 1, false)
        if w > max_w then max_w = w end
      end
      menu_x = (Config.screen.width - max_w) / 2
    end
    for i, _ in ipairs(items) do
      if Mouse.zone({ x = menu_x - 8, y = y + (i-1) * 10, w = Config.screen.width, h = 10 }) then
        return i, true
      end
    end
  end

  return selected_item, false
end

--- Draws a bordered textbox with scrolling text.
--- @within UI
--- @param text string The text to display (multi-line supported).<br/>
--- @param box_x number The x-coordinate of the box.<br/>
--- @param box_y number The y-coordinate of the box.<br/>
--- @param box_w number The width of the box.<br/>
--- @param box_h number The height of the box.<br/>
--- @param scroll_y number The vertical scroll offset for the text (0 = top, increases to scroll up).<br/>
--- @param[opt] color number The text color (default: Config.colors.white).<br/>
--- @param[opt] bg_color number The background fill color (default: Config.colors.dark_grey).<br/>
--- @param[opt] border_color number The border color (default: Config.colors.white).<br/>
--- @param[opt] center_text boolean Whether to center each line inside the box. Defaults to false.<br/>
local function draw_rounded_rect_fill(x, y, w, h, radius, color)
  local inner_w = w - radius * 2
  local inner_h = h - radius * 2
  if inner_w > 0 and inner_h > 0 then
    rect(x + radius, y + radius, inner_w, inner_h, color)
  end
  if inner_w > 0 and radius > 0 then
    rect(x + radius, y, inner_w, radius, color)
    rect(x + radius, y + h - radius, inner_w, radius, color)
  end
  if radius > 0 and inner_h > 0 then
    rect(x, y + radius, radius, inner_h, color)
    rect(x + w - radius, y + radius, radius, inner_h, color)
  end
  for row = 0, radius - 1 do
    for col = 0, radius - 1 do
      if col + row >= radius - 1 then
        pix(x + radius - 1 - col, y + radius - 1 - row, color)
        pix(x + w - radius + col, y + radius - 1 - row, color)
        pix(x + radius - 1 - col, y + h - radius + row, color)
        pix(x + w - radius + col, y + h - radius + row, color)
      end
    end
  end
end

local function draw_rounded_rect_border(x, y, w, h, radius, color)
  line(x + radius, y, x + w - radius - 1, y, color)
  line(x + radius, y + h - 1, x + w - radius - 1, y + h - 1, color)
  line(x, y + radius, x, y + h - radius - 1, color)
  line(x + w - 1, y + radius, x + w - 1, y + h - radius - 1, color)
  pix(x + radius - 1, y + 1, color)
  pix(x + 1, y + radius - 1, color)
  pix(x + w - radius, y + 1, color)
  pix(x + w - 2, y + radius - 1, color)
  pix(x + radius - 1, y + h - 2, color)
  pix(x + 1, y + h - radius, color)
  pix(x + w - radius, y + h - 2, color)
  pix(x + w - 2, y + h - radius, color)
end

function UI.draw_textbox(text, box_x, box_y, box_w, box_h, scroll_y, color, bg_color, border_color, center_text)
  color = color or Config.colors.white
  bg_color = bg_color or Config.colors.black
  border_color = border_color or Config.colors.white
  center_text = center_text or false

  local r = 3
  local padding = 4
  local line_height = 8
  local inner_x = box_x + padding
  local inner_y = box_y + padding
  local inner_center_x = box_x + (box_w / 2)
  local visible_height = box_h - padding * 2
  local lines = UI.word_wrap(text, 30)
  local text_height = #lines * line_height
  local base_y = inner_y

  if center_text and text_height < visible_height then
    base_y = inner_y + math.floor((visible_height - text_height) / 2)
  end

  draw_rounded_rect_fill(box_x, box_y, box_w, box_h, r, bg_color)

  for i, line in ipairs(lines) do
    local ly = base_y + (i - 1) * line_height - scroll_y
    if ly >= inner_y and ly + line_height <= inner_y + visible_height then
      if center_text then
        Print.text_center(line, inner_center_x, ly, color)
      else
        Print.text(line, inner_x, ly, color)
      end
    end
  end

  draw_rounded_rect_border(box_x, box_y, box_w, box_h, r, border_color)
end

--- Wraps text.
--- @within UI
--- @param text string The text to wrap.<br/>
--- @param max_chars_per_line number The maximum characters per line.<br/>
--- @return result table A table of wrapped lines.
function UI.word_wrap(text, max_chars_per_line)
  if text == nil then return {""} end

  local lines = {}

  local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
  end

  local function previous_whitespace_index(s, target)
    if s:sub(target, target):match("%s") then
      return target
    end

    for i = target - 1, 1, -1 do
      if s:sub(i, i):match("%s") then
        return i
      end
    end

    return nil
  end

  for input_line in (text .. "\n"):gmatch("(.-)\n") do
    local remaining = trim(input_line)

    if remaining == "" then
      table.insert(lines, "")
    else
      while #remaining > max_chars_per_line do
        local split_at = previous_whitespace_index(remaining, max_chars_per_line)
        local line = trim(remaining:sub(1, split_at))

        if not split_at or line == "" then
          line = remaining:sub(1, max_chars_per_line)
          split_at = max_chars_per_line
        end

        table.insert(lines, line)
        remaining = trim(remaining:sub(split_at + 1))
      end

      table.insert(lines, remaining)
    end
  end

  if #lines == 0 then
    return {""}
  end

  return lines
end
