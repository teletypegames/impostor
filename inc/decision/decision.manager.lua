local _decisions = {}

function Decision.register(decision)
  if not decision or not decision.id then
    PopupWindow.show({"Error: Invalid decision object registered (missing id)!"})
    return
  end
  if not decision.label then
    PopupWindow.show({"Error: Invalid decision object registered (missing label)!"})
    return
  end

  if not decision.condition then
    decision.condition = function() return true end
  end
  if not decision.handle then
    decision.handle = function() end
  end
  if _decisions[decision.id] then
    trace("Warning: Overwriting decision with id: " .. decision.id)
  end
  _decisions[decision.id] = decision
end

function Decision.get(id)
  return _decisions[id]
end

function Decision.get_all()
  return _decisions
end
