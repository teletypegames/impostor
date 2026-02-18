local _desitions = {}

function DesitionManager.register(desition)
  if not desition or not desition.id then
    PopupWindow.show({"Error: Invalid desition object registered (missing id)!"})
    return
  end
  if not desition.label then
    PopupWindow.show({"Error: Invalid desition object registered (missing label)!"})
    return
  end

  if not desition.condition then
    desition.condition = function() return true end
  end
  if not desition.handle then
    desition.handle = function() end
  end
  if _desitions[desition.id] then
    trace("Warning: Overwriting desition with id: " .. desition.id)
  end
  _desitions[desition.id] = desition
end

function DesitionManager.get(id)
  return _desitions[id]
end

function DesitionManager.get_all()
  return _desitions
end
