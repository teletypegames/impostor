--- @section Screen
local _screens = {}

--- Registers a screen definition.
--- @within Screen
--- @param screen_data table The screen data table.
--- @param screen_data.id string Unique screen identifier.
--- @param screen_data.name string Display name of the screen.
--- @param screen_data.decisions table Array of decision ID strings available on this screen.
--- @param screen_data.background string Map ID used as background.
--- @param[opt] screen_data.situations table Array of situation ID strings. Defaults to {}.
--- @param[opt] screen_data.init function Called when the screen is entered. Defaults to noop.
--- @param[opt] screen_data.update function Called each frame while screen is active. Defaults to noop.
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
--- @within Screen
--- @param screen_id string The ID of the screen.
--- @return result table The screen table or nil.
--- @return result.id string Unique screen identifier.
--- @return result.name string Display name of the screen.
--- @return result.decisions table Array of decision ID strings available on this screen.
--- @return result.background string Map ID used as background.
--- @return result.situations table Array of situation ID strings.
--- @return result.init function Called when the screen is entered.
--- @return result.update function Called each frame while screen is active.
function Screen.get_by_id(screen_id)
  return _screens[screen_id]
end

--- Gets all registered screens.
--- @within Screen
--- @return result table A table containing all registered screen data, indexed by their IDs.
--- @return result.id string Unique screen identifier.
--- @return result.name string Display name of the screen.
--- @return result.decisions table Array of decision ID strings available on this screen.
--- @return result.background string Map ID used as background.
--- @return result.situations table Array of situation ID strings.
--- @return result.init function Called when the screen is entered.
--- @return result.update function Called each frame while screen is active.
function Screen.get_all()
  return _screens
end
