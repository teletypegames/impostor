ScreenManager = {}

local _screens = {} -- Internal list to hold screen data

-- Public property to access the registered screens as an indexed array
function ScreenManager.get_screens_array()
  local screens_array = {}
  for _, screen_data in pairs(_screens) do
    table.insert(screens_array, screen_data)
  end
  return screens_array
end

-- Registers a screen with the manager
-- screen_data: A table containing id, name, and decisions for the screen
function ScreenManager.register(screen_data)
  if _screens[screen_data.id] then
    -- Optional: warning if overwriting an existing screen
    trace("Warning: Overwriting screen with id: " .. screen_data.id)
  end
  _screens[screen_data.id] = screen_data
end

-- Retrieves a screen by its id (if needed directly)
function ScreenManager.get_by_id(screen_id)
  return _screens[screen_id]
end
