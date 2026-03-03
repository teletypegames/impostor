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
--- @param x number The x-coordinate for the menu.<br/>
--- @param y number The y-coordinate for the menu.<br/>
function UI.draw_menu(items, selected_item, x, y)
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

--- Wraps text.
--- @within UI
--- @param text string The text to wrap.<br/>
--- @param max_chars_per_line number The maximum characters per line.<br/>
--- @return result table A table of wrapped lines.
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
