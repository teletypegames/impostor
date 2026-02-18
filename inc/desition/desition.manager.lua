DesitionManager = {}

local _desitions = {} -- Private table to store all desitions

-- Registers a decision object with the manager
-- desition: A table containing id, label, handle(), and condition()
function DesitionManager.register(desition)
  if not desition or not desition.id then
    PopupWindow.show({"Error: Invalid desition object registered (missing id)!"})
    return
  end
  if not desition.label then
    PopupWindow.show({"Error: Invalid desition object registered (missing label)!"})
    return
  end

  -- Ensure handle() and condition() methods exist with defaults if missing
  if not desition.condition then
    desition.condition = function() return true end
  end
  if not desition.handle then
    desition.handle = function() end
  end
  if _desitions[desition.id] then
    -- Optional: warning if overwriting an existing desition
    trace("Warning: Overwriting desition with id: " .. desition.id)
  end
  _desitions[desition.id] = desition
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
