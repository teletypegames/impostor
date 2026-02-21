local _screens = {}

--- Registers a screen definition.
-- @param screen_data table The screen data table.
function Screen.register(screen_data)
  if _screens[screen_data.id] then
    trace("Warning: Overwriting screen with id: " .. screen_data.id)
  end
  if not screen_data.situations then
    screen_data.situations = {}
  end
  if not screen_data.init then
    screen_data.init = function() end
  end
  if not screen_data.update then
    screen_data.update = function() end
  end
  _screens[screen_data.id] = screen_data
end

--- Gets a screen by ID.
-- @param screen_id string The ID of the screen.
-- @return table The screen table or nil.
function Screen.get_by_id(screen_id)
  return _screens[screen_id]
end
