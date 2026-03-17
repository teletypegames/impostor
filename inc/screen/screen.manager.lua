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
--- @param[opt] screen_data.draw function Called after the focus overlay to draw screen-specific overlays. Defaults to noop.
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
    if not screen_data.exit then
    screen_data.exit = function() end
  end
  if not screen_data.update then
    screen_data.update = function() end
  end
  if not screen_data.draw then
    screen_data.draw = function() end
  end
  _screens[screen_data.id] = screen_data
end

--- Gets a screen by ID.
--- @within Screen
--- @param screen_id string The ID of the screen.
--- @return table|nil screen The screen table or nil. </br>
--- Fields: </br>
--- * id (string) Unique screen identifier.<br/>
--- * name (string) Display name.<br/>
--- * decisions (table) Array of decision ID strings.<br/>
--- * background (string) Map ID used as background.<br/>
--- * situations (table) Array of situation ID strings.<br/>
--- * init (function) Called when the screen is entered.<br/>
--- * update (function) Called each frame while screen is active.
function Screen.get_by_id(screen_id)
  return _screens[screen_id]
end

--- Gets all registered screens.
--- @within Screen
--- @return result table A table containing all registered screen data, indexed by their IDs or nil. </br>
--- Fields: </br>
--- * id (string) Unique screen identifier.<br/>
--- * name (string) Display name of the screen.<br/>
--- * decisions (table) Array of decision ID strings available on this screen.<br/>
--- * background (string) Map ID used as background.<br/>
--- * situations (table) Array of situation ID strings.<br/>
--- * init (function) Called when the screen is entered.<br/>
--- * update (function) Called each frame while screen is active.<br/>
function Screen.get_all()
  return _screens
end
