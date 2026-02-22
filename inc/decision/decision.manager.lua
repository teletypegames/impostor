local _decisions = {}

--- Registers a decision definition.
-- @param decision table The decision data table.
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

--- Gets a decision by ID.
-- @param id string The ID of the decision.
-- @return table The decision table or nil.
function Decision.get(id)
  return _decisions[id]
end

--- Gets all registered decisions.
-- @return table A table of all registered decisions.
function Decision.get_all_registered()
  return _decisions
end

--- Gets decision objects based on a screen's data.
-- @param screen_data table The data for the screen, containing a 'decisions' field (list of decision IDs).
-- @return table A table containing decision objects relevant to the screen.
function Decision.get_for_screen(screen_data)
  if not screen_data or not screen_data.decisions then
    return {}
  end

  local screen_decisions = {}
  for _, decision_id in ipairs(screen_data.decisions) do
    local decision = Decision.get(decision_id)
    if decision then
      table.insert(screen_decisions, decision)
    end
  end
  return screen_decisions
end

--- Filters a list of decision objects based on their condition function.
-- @param decisions_list table A table of decision objects.
-- @return table A new table containing only the decisions for which condition() is true.
function Decision.filter_available(decisions_list)
  local available = {}
  for _, decision in ipairs(decisions_list) do
    if decision and decision.condition() then
      table.insert(available, decision)
    end
  end
  return available
end
