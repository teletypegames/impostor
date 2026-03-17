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
--- @return number selected_item The updated index of the selected item.
function UI.update_menu(items, selected_item)
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
  return selected_item
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
function UI.draw_textbox(text, box_x, box_y, box_w, box_h, scroll_y, color, bg_color, border_color, center_text)
  color = color or Config.colors.white
  bg_color = bg_color or Config.colors.dark_grey
  border_color = border_color or Config.colors.white
  center_text = center_text or false

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

  rect(box_x, box_y, box_w, box_h, bg_color)

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

  rectb(box_x, box_y, box_w, box_h, border_color)
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
