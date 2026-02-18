ConfigurationWindow = {
  controls = {},
  selected_control = 1,
}

function ConfigurationWindow.init()
  ConfigurationWindow.controls = {
    UI.create_desition_item(
      "Save",
      function() Config.save() end
    ),
    UI.create_desition_item(
      "Restore Defaults",
      function() Config.restore_defaults() end
    ),
  }
end

function ConfigurationWindow.draw()
  UI.draw_top_bar("Configuration")

  local x_start = 10   local y_start = 40
  local x_value_right_align = Config.screen.width - 10
  local char_width = 4
  for i, control in ipairs(ConfigurationWindow.controls) do
    local current_y = y_start + (i - 1) * 12
    local color = Config.colors.green
    if control.type == "numeric_stepper" then
      local value = control.get()
      local label_text = control.label
      local value_text = string.format(control.format, value)

            local value_x = x_value_right_align - (#value_text * char_width)

      if i == ConfigurationWindow.selected_control then
        color = Config.colors.item
        Print.text("<", x_start -8, current_y, color)
        Print.text(label_text, x_start, current_y, color)         Print.text(value_text, value_x, current_y, color)
        Print.text(">", x_value_right_align + 4, current_y, color)       else
        Print.text(label_text, x_start, current_y, color)
        Print.text(value_text, value_x, current_y, color)
      end
    elseif control.type == "desition_item" then
      local label_text = control.label
      if i == ConfigurationWindow.selected_control then
        color = Config.colors.item
        Print.text("<", x_start -8, current_y, color)
        Print.text(label_text, x_start, current_y, color)
        Print.text(">", x_start + 8 + (#label_text * char_width) + 4, current_y, color)
      else
        Print.text(label_text, x_start, current_y, color)
      end
    end
  end
  Print.text("Press B to go back", x_start, 120, Config.colors.light_grey)
end

function ConfigurationWindow.update()
  if Input.menu_back() then
    GameWindow.set_state(WINDOW_MENU)
    return
  end

  if Input.up() then
    ConfigurationWindow.selected_control = ConfigurationWindow.selected_control - 1
    if ConfigurationWindow.selected_control < 1 then
      ConfigurationWindow.selected_control = #ConfigurationWindow.controls
    end
  elseif Input.down() then
    ConfigurationWindow.selected_control = ConfigurationWindow.selected_control + 1
    if ConfigurationWindow.selected_control > #ConfigurationWindow.controls then
      ConfigurationWindow.selected_control = 1
    end
  end

  local control = ConfigurationWindow.controls[ConfigurationWindow.selected_control]
  if control then
    if control.type == "numeric_stepper" then
      local current_value = control.get()
      if btnp(2) then         local new_value = math.max(control.min, current_value - control.step)
        control.set(new_value)
      elseif btnp(3) then         local new_value = math.min(control.max, current_value + control.step)
        control.set(new_value)
      end
    elseif control.type == "desition_item" then
      if Input.menu_confirm() then
        control.desition()
      end
    end
  end
end