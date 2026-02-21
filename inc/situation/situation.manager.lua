local _situations = {}

--- Registers a situation definition.
-- @param situation table The situation data table.
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
-- @param id string The situation ID.
-- @return table The situation table or nil.
function Situation.get(id)
  return _situations[id]
end

--- Applies a situation.
-- @param id string The situation ID to apply.
function Situation.apply(id)
  local situation = Situation.get(id)
  if not situation then
    trace("Error: No situation found with id: " .. id)
    return
  end

  local current_screen_obj = Screen.get_by_id(Context.current_screen)
  if current_screen_obj and not current_screen_obj.situations[id] then
    trace("Info: Situation " .. id .. " cannot be applied to current screen (id: " .. Context.current_screen .. ").")
    return
  end

  Context.current_situation = id
  situation.handle()
end
