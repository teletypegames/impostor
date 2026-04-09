--- @section ControlsWindow
local _controls = {
  { action = "Navigate",       keyboard = "Arrow keys",  gamepad = "D-pad" },
  { action = "Select / OK",    keyboard = "Space",       gamepad = "Z button" },
  { action = "Back",           keyboard = "Backspace",   gamepad = "B button" },
  { action = "Click",          keyboard = "Mouse",       gamepad = "" },
}

--- Draws the controls window.
--- @within ControlsWindow
function ControlsWindow.draw()
  UI.draw_top_bar("Controls")

  local col_action   = 4
  local col_keyboard = 80
  local col_gamepad  = 170
  local row_h        = 10
  local y_header     = 18
  local y_start      = 30

  Print.text("Action",   col_action,   y_header, Config.colors.light_grey)
  Print.text("Keyboard", col_keyboard, y_header, Config.colors.light_grey)
  Print.text("Gamepad",  col_gamepad,  y_header, Config.colors.light_grey)
  line(col_action, y_header + 8, Config.screen.width - 4, y_header + 8, Config.colors.dark_grey)

  for i, entry in ipairs(_controls) do
    local y = y_start + (i - 1) * row_h
    Print.text(entry.action,   col_action,   y, Config.colors.white)
    Print.text(entry.keyboard, col_keyboard, y, Config.colors.light_blue)
    if entry.gamepad ~= "" then
      Print.text(entry.gamepad, col_gamepad, y, Config.colors.light_blue)
    end
  end

  Print.text("Space / Z button  or  click to go back", col_action, Config.screen.height - 10, Config.colors.light_grey)
end

--- Updates the controls window logic.
--- @within ControlsWindow
function ControlsWindow.update()
  if Input.back() or Input.select() then
    Window.set_current("menu")
  end
end
