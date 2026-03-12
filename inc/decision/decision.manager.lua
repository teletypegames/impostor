--- @section Decision
local _decisions = {}

--- Registers a decision definition.
--- @within Decision
--- @param decision table The decision data table.
--- @param decision.id string Unique decision identifier.
--- @param decision.label string|function Display text for the decision, or a function returning it.
--- @param[opt] decision.condition function Returns true if decision is available. Defaults to always true.
--- @param[opt] decision.handle function Called when the decision is selected. Defaults to noop.
function Decision.register(decision)
  if not decision or not decision.id then
    trace("Error: Invalid decision object registered (missing id)!")
    return
  end
  if not decision.label then
    trace("Error: Invalid decision object registered (missing label)!")
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

--- Gets the display label for a decision.
--- @within Decision
--- @param decision table The decision data table.
--- @return string result The resolved decision label.
function Decision.get_label(decision)
  if not decision then return "" end
  if type(decision.label) == "function" then
    return decision.label() or ""
  end
  return decision.label or ""
end

--- Gets a decision by ID.
--- @within Decision
--- @param id string The ID of the decision.
--- @return table|nil result The decision table or nil. </br>
--- Fields: </br>
--- * id (string) Unique decision identifier.<br/>
--- * label (string) Display text for the decision.<br/>
--- * condition (function) Returns true if decision is available.<br/>
--- * handle (function) Called when the decision is selected.
function Decision.get_by_id(id)
  return _decisions[id]
end

--- Gets all registered decisions.
--- @within Decision
--- @return result table A table of all registered decisions, indexed by their IDs. </br>
--- Fields: </br>
--- * id (string) Unique decision identifier.<br/>
--- * label (string) Display text for the decision.<br/>
--- * condition (function) Returns true if decision is available.<br/>
--- * handle (function) Called when the decision is selected.
function Decision.get_all()
  return _decisions
end

--- Gets decision objects based on a screen's data.
--- @within Decision
--- @param screen_data table The data for the screen.
--- @param screen_data.decisions table Array of decision ID strings.
--- @return result table An array of decision objects relevant to the screen or nil. </br>
--- Fields: </br>
--- * id (string) Unique decision identifier.<br/>
--- * label (string) Display text for the decision.<br/>
--- * condition (function) Returns true if decision is available.<br/>
--- * handle (function) Called when the decision is selected.<br/>
function Decision.get_for_screen(screen_data)
  if not screen_data or not screen_data.decisions then
    return {}
  end

  local screen_decisions = {}
  for _, decision_id in ipairs(screen_data.decisions) do
    local decision = Decision.get_by_id(decision_id)
    if decision then
      table.insert(screen_decisions, decision)
    end
  end
  return screen_decisions
end

--- Filters a list of decision objects based on their condition function.
--- @within Decision
--- @param decisions_list table A table of decision objects.
--- @return result table An array of decisions for which condition() is true or nil. </br>
--- Fields: </br>
--- * id (string) Unique decision identifier.<br/>
--- * label (string) Display text for the decision.<br/>
--- * condition (function) Returns true if decision is available.<br/>
--- * handle (function) Called when the decision is selected.<br/>
function Decision.filter_available(decisions_list)
  local available = {}
  for _, decision in ipairs(decisions_list) do
    if decision and (not decision.condition or decision.condition()) then
      table.insert(available, decision)
    end
  end
  return available
end

--- Draws decision selector.
--- @within Decision
--- @param decisions table A table of decision items.<br/>
--- @param selected_decision_index number The index of the selected decision.<br/>
function Decision.draw(decisions, selected_decision_index)
  local bar_height = 16
  local bar_y = Config.screen.height - bar_height
  rect(0, bar_y, Config.screen.width, bar_height, Config.colors.dark_grey)
  if #decisions > 0 then
    local selected_decision = decisions[selected_decision_index]
    local decision_label = Decision.get_label(selected_decision)
    local text_y = bar_y + 4
    Print.text("<", 2, text_y, Config.colors.light_blue)
    Print.text_center(decision_label, Config.screen.width / 2, text_y, Config.colors.item)
    Print.text(">", Config.screen.width - 6, text_y, Config.colors.light_blue)
  end
end

--- Updates decision selector.
--- @within Decision
--- @param decisions table A table of decision items.<br/>
--- @param selected_decision_index number The current index of the selected decision.<br/>
--- @return number selected_decision_index The updated index of the selected decision.
function Decision.update(decisions, selected_decision_index)
  if Input.left() then
    Audio.sfx_beep()
    selected_decision_index = Util.safeindex(decisions, selected_decision_index - 1)
  elseif Input.right() then
    Audio.sfx_beep()
    selected_decision_index = Util.safeindex(decisions, selected_decision_index + 1)
  end
  return selected_decision_index
end
