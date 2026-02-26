--- @section Situation
local _situations = {}

--- Registers a situation definition.
--- @within Situation
-- @param situation table The situation data table.
-- @param situation.id string Unique situation identifier.
-- @param[opt] situation.screen_id string ID of the screen this situation belongs to.
-- @param[opt] situation.handle function Called when the situation is applied. Defaults to noop.
-- @param[opt] situation.update function Called each frame while situation is active. Defaults to noop.
function Situation.register(situation)
  if not situation or not situation.id then
    PopupWindow.show({"Error: Invalid situation object registered (missing id)!"})
    return
  end
  if not situation.handle then
    situation.handle = function() end
  end
  if not situation.update then
    situation.update = function() end
  end
  if _situations[situation.id] then
    trace("Warning: Overwriting situation with id: " .. situation.id)
  end
  _situations[situation.id] = situation
end

--- Gets a situation by ID.
--- @within Situation
-- @param id string The situation ID.
-- @return table The situation table or nil.
function Situation.get_by_id(id)
  return _situations[id]
end

--- Gets all registered situations, optionally filtered by screen ID.
--- @within Situation
-- @param screen_id string Optional. If provided, returns situations associated with this screen ID.
-- @return table A table containing all registered situation data, indexed by their IDs, or filtered by screen_id.
function Situation.get_all(screen_id)
  if screen_id then
    local filtered_situations = {}
    for _, situation in pairs(_situations) do
      if situation.screen_id == screen_id then
        table.insert(filtered_situations, situation)
      end
    end
    return filtered_situations
  end
  return _situations
end

--- Applies a situation, checking screen compatibility and returning the new situation ID if successful.
--- @within Situation
-- @param id string The situation ID to apply.
-- @param current_screen_id string The ID of the currently active screen.
-- @return string|nil The ID of the applied situation if successful, otherwise nil.
function Situation.apply(id, current_screen_id)
  local situation = Situation.get_by_id(id)
  local screen = Screen.get_by_id(current_screen_id)

  if not situation then
    trace("Error: No situation found with id: " .. id)
    return nil
  end

  if Util.contains(screen.situations, id) then
    situation.handle()
    return id
  else
    trace("Info: Situation " .. id .. " cannot be applied to current screen (id: " .. current_screen_id .. ").")
    return nil
  end
end
