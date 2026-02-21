local _screens = {}

function Screen.get_screens_array()
  local screens_array = {}
  for _, screen_data in pairs(_screens) do
    table.insert(screens_array, screen_data)
  end
  return screens_array
end

function Screen.register(screen_data)
  if _screens[screen_data.id] then
    trace("Warning: Overwriting screen with id: " .. screen_data.id)
  end
  _screens[screen_data.id] = screen_data
end

function Screen.get_by_id(screen_id)
  return _screens[screen_id]
end
