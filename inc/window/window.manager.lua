--- @section Window
local _windows = {}

--- Registers a window table.
--- @within Window
-- @param id string The ID of the window (e.g., "splash", "menu").
-- @param window_table table The actual window module table (e.g., SplashWindow).
function Window.register(id, window_table)
  _windows[id] = window_table
end

--- Retrieves a registered window table by its ID.
--- @within Window
-- @param id string The ID of the window.
-- @return table The window module table.
function Window.get(id)
  return _windows[id]
end

--- Sets the currently active window.
--- @within Window
-- @param id string The ID of the window to activate.
function Window.set_current(id)
  Context.current_window = id
end

--- Gets the ID of the currently active window.
--- @within Window
-- @return string The ID of the active window.
function Window.get_current_id()
  return Context.current_window
end

--- Gets the handler function for the currently active window.
-- This function is used by the main game loop to update and draw the active window.
--- @within Window
-- @return function A function that updates and draws the current window.
function Window.get_current_handler()
  local window_table = Window.get(Context.current_window)
  if window_table and window_table.update and window_table.draw then
    return function()
      window_table.update()
      window_table.draw()
    end
  else
    -- Fallback handler for unregistered or incomplete windows
    return function() trace("Error: No handler for window: " .. tostring(Context.current_window)) end
  end
end
