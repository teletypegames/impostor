local _screens = {}

function Screen.register(screen_data)
  if _screens[screen_data.id] then
    trace("Warning: Overwriting screen with id: " .. screen_data.id)
  end
  if not screen_data.situations then
    screen_data.situations = {}
  end
  _screens[screen_data.id] = screen_data
end

function Screen.get_by_id(screen_id)
  return _screens[screen_id]
end
