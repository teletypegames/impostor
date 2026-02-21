local _screens = {}

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

function Screen.get_by_id(screen_id)
  return _screens[screen_id]
end
