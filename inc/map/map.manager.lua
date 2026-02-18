MapManager = {}

local _maps = {}

function MapManager.get_maps_array()
  local maps_array = {}
  for _, map_data in pairs(_maps) do
    table.insert(maps_array, map_data)
  end
  return maps_array
end

function MapManager.register(map_data)
  if _maps[map_data.id] then
    trace("Warning: Overwriting map with id: " .. map_data.id)
  end
  _maps[map_data.id] = map_data
end

function MapManager.get_by_id(map_id)
  return _maps[map_id]
end

function MapManager.draw(map_id)
  local map_data = MapManager.get_by_id(map_id)
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