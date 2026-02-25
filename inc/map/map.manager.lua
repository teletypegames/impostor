-- Manages game maps.
--- @section Map


local _maps = {}

--- Gets all registered maps as an array.
--- @within Map
-- @return table An array of registered map data.
function Map.get_maps_array()
  local maps_array = {}
  for _, map_data in pairs(_maps) do
    table.insert(maps_array, map_data)
  end
  return maps_array
end

--- Registers a map definition.
--- @within Map
-- @param map_data table The map data table.
function Map.register(map_data)
  if _maps[map_data.id] then
    trace("Warning: Overwriting map with id: " .. map_data.id)
  end
  _maps[map_data.id] = map_data
end

--- Gets a map by ID.
--- @within Map
-- @param map_id string The ID of the map.
-- @return table The map data table or nil.
function Map.get_by_id(map_id)
  return _maps[map_id]
end

--- Draws a map.
--- @within Map
-- @param map_id string The ID of the map to draw.
function Map.draw(map_id)
  local map_data = Map.get_by_id(map_id)
  if not map_data then
    return
  end
  map(
    map_data.from_x,
    map_data.from_y,
    map_data.width,
    map_data.height,
    map_data.to_x,
    map_data.to_y
  )
end
