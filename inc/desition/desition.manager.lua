DesitionManager = {}

local _desitions = {} -- Private table to store all desitions

-- Registers a decision object with the manager
-- desition_object: A table containing id, label, handle(), and condition()
function DesitionManager.register(desition_object)
  if not desition_object or not desition_object.id then
    PopupWindow.show({"Error: Invalid desition object registered (missing id)!"})
    return
  end
  if not desition_object.label then
    PopupWindow.show({"Error: Invalid desition object registered (missing label)!"})
    return
  end

  -- Ensure handle() and condition() methods exist with defaults if missing
  if not desition_object.condition then
    desition_object.condition = function() return true end
  end
  if not desition_object.handle then
    desition_object.handle = function() end
  end
  
  if _desitions[desition_object.id] then
    -- Optional: warning if overwriting an existing desition
    -- trace("Warning: Overwriting desition with id: " .. desition_object.id)
  end
  _desitions[desition_object.id] = desition_object
end

-- Retrieves a desition by its id
-- id: unique string identifier of the desition
-- Returns the desition object, or nil if not found
function DesitionManager.get(id)
  return _desitions[id]
end

-- Optional: a way to get all registered desitions, if needed (e.g., for debug)
function DesitionManager.get_all()
  return _desitions
end
