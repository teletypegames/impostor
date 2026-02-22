--- Draws the top bar.
-- @param title string The title text to display.
function UI.draw_top_bar(title)
  rect(0, 0, Config.screen.width, 10, Config.colors.dark_grey)
  Print.text(title, 3, 2, Config.colors.green)
end

--- Draws dialog window.
function UI.draw_dialog()
  PopupWindow.draw()
end

--- Draws a menu.
-- @param items table A table of menu items.
-- @param selected_item number The index of the currently selected item.
-- @param x number The x-coordinate for the menu.
-- @param y number The y-coordinate for the menu.
function UI.draw_menu(items, selected_item, x, y)
  for i, item in ipairs(items) do
    local current_y = y + (i-1)*10
    if i == selected_item then
      Print.text(">", x - 8, current_y, Config.colors.green)
    end
    Print.text(item.label, x, current_y, Config.colors.green)
  end
end

--- Updates menu selection.
-- @param items table A table of menu items.
-- @param selected_item number The current index of the selected item.
-- @return number The updated index of the selected item.
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

--- Wraps text.
-- @param text string The text to wrap.
-- @param max_chars_per_line number The maximum characters per line.
-- @return table A table of wrapped lines.
function UI.word_wrap(text, max_chars_per_line)
    if text == nil then return {""} end
    local lines = {}
    for input_line in (text .. "\n"):gmatch("(.-)\n") do
        local current_line = ""
        local words_in_line = 0
        for word in input_line:gmatch("%S+") do
            words_in_line = words_in_line + 1
            if #current_line == 0 then
                current_line = word
            elseif #current_line + #word + 1 <= max_chars_per_line then
                current_line = current_line .. " " .. word
            else
                table.insert(lines, current_line)
                current_line = word
            end
        end
        if words_in_line > 0 then
            table.insert(lines, current_line)
        else
            table.insert(lines, "")
        end
    end
    if #lines == 0 then
        return {""}
    end
    return lines
end

--- Creates a numeric stepper.
-- @param label string The label for the stepper.
-- @param value_getter function Function to get the current value.
-- @param value_setter function Function to set the current value.
-- @param min number The minimum value.
-- @param max number The maximum value.
-- @param step number The step increment.
-- @param[opt] format string The format string for displaying the value.
-- @return table A numeric stepper control definition.
function UI.create_numeric_stepper(label, value_getter, value_setter, min, max, step, format)
  return {
    label = label,
    get = value_getter,
    set = value_setter,
    min = min,
    max = max,
    step = step,
    format = format or "%.1f",
    type = "numeric_stepper"
  }
end

--- Creates an action item.
-- @param label string The label for the action item.
-- @param action function The function to execute when the item is selected.
-- @return table An action item control definition.
function UI.create_action_item(label, action)
  return {
    label = label,
    action = action,
    type = "action_item"
  }
end

--- Draws decision selector.
-- @param decisions table A table of decision items.
-- @param selected_decision_index number The index of the selected decision.
function UI.draw_decision_selector(decisions, selected_decision_index)
  local bar_height = 16
  local bar_y = Config.screen.height - bar_height
  rect(0, bar_y, Config.screen.width, bar_height, Config.colors.dark_grey)
  if #decisions > 0 then
    local selected_decision = decisions[selected_decision_index]
    local decision_label = selected_decision.label
    local text_width = #decision_label * 4     local text_y = bar_y + 4
        local text_x = (Config.screen.width - text_width) / 2
        Print.text("<", 2, text_y, Config.colors.green)
        Print.text(decision_label, text_x, text_y, Config.colors.item)         Print.text(">", Config.screen.width - 6, text_y, Config.colors.green)   end
end

--- Draws meters.
function UI.draw_meters()
  if not Context or not Context.game_in_progress or not Context.meters then return end
  if Context.meters.hidden then return end

  local m = Context.meters
  local max = Meter.get_max()
  local bar_w = 44
  local bar_h = 2
  local bar_x = 182
  local label_x = 228
  local line_h = 5
  local start_y = 11
  local bar_offset = math.floor((line_h - bar_h) / 2)

  local meter_list = {
    { key = "wpm", label = "WPM", color = Meter.COLOR_WPM, row = 0 },
    { key = "ism", label = "ISM", color = Meter.COLOR_ISM, row = 1 },
    { key = "bm", label = "BM", color = Meter.COLOR_BM, row = 2 },
  }

  for _, meter in ipairs(meter_list) do
    local label_y = start_y + meter.row * line_h
    local bar_y = label_y + bar_offset
    local fill_w = math.max(0, math.floor((m[meter.key] / max) * bar_w))
    rect(bar_x, bar_y, bar_w, bar_h, Meter.COLOR_BG)
    if fill_w > 0 then
      rect(bar_x, bar_y, fill_w, bar_h, meter.color)
    end
    print(meter.label, label_x, label_y, meter.color, false, 1, true)
  end
end

--- Updates decision selector.
-- @param decisions table A table of decision items.
-- @param selected_decision_index number The current index of the selected decision.
-- @return number The updated index of the selected decision.
function UI.update_decision_selector(decisions, selected_decision_index)
  if Input.left() then
    Audio.sfx_beep()
    selected_decision_index = Util.safeindex(decisions, selected_decision_index - 1)
  elseif Input.right() then
    Audio.sfx_beep()
    selected_decision_index = Util.safeindex(decisions, selected_decision_index + 1)
  end
  return selected_decision_index
end
