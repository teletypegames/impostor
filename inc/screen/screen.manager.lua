local _screens = {}

function ScreenManager.get_screens_array()
  local screens_array = {}
  for _, screen_data in pairs(_screens) do
    table.insert(screens_array, screen_data)
  end
  return screens_array
end

function ScreenManager.register(screen_data)
  if _screens[screen_data.id] then
    -- Optional: warning if overwriting an existing screen
    trace("Warning: Overwriting screen with id: " .. screen_data.id)
  end
  _screens[screen_data.id] = screen_data
end

function ScreenManager.get_by_id(screen_id)
  return _screens[screen_id]
end
