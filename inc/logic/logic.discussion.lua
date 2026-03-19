--- @section Discussion
local _discussions = {}

--- Registers a discussion definition.
--- @within Discussion
--- @param discussion table The discussion data table.
--- @param discussion.id string Unique discussion identifier.
--- @param discussion.steps table Array of step tables, each with `question` (string) and `answers` (array of {label, next_step} tables).
--- @param[opt] discussion.on_end function Called when the discussion ends. Defaults to noop.
function Discussion.register(discussion)
  if not discussion or not discussion.id then
    trace("Error: Invalid discussion registered (missing id)!")
    return
  end
  if not discussion.steps or #discussion.steps == 0 then
    trace("Error: Discussion '" .. discussion.id .. "' has no steps!")
    return
  end
  if not discussion.on_end then
    discussion.on_end = function() end
  end
  if _discussions[discussion.id] then
    trace("Warning: Overwriting discussion with id: " .. discussion.id)
  end
  _discussions[discussion.id] = discussion
end

--- Gets a discussion by ID.
--- @within Discussion
--- @param id string The discussion ID.
--- @return table|nil result The discussion table or nil.
function Discussion.get_by_id(id)
  return _discussions[id]
end

--- Starts a discussion, switching to the discussion window.
--- @within Discussion
--- @param id string The discussion ID to start.
--- @param return_window string The window ID to return to after the discussion.
--- @param[opt] start_step number The step index to start from (defaults to 1).
function Discussion.start(id, return_window, start_step)
  local discussion = _discussions[id]
  if not discussion then
    trace("Error: Discussion not found: " .. tostring(id))
    return
  end
  local step = start_step or 1
  if not discussion.steps[step] then step = 1 end
  Context.discussion.active = true
  Context.discussion.id = id
  Context.discussion.step = step
  Context.discussion.selected_answer = 1
  Context.discussion.scroll_y = 0
  Context.discussion.scroll_timer = 0
  Context.discussion.auto_scroll = true
  Context.discussion.return_window = return_window or "game"
  Meter.hide()
  Window.set_current("discussion")
end

--- Gets the current step data for the active discussion.
--- @within Discussion
--- @return table|nil result The current step table or nil.
function Discussion.get_current_step()
  if not Context.discussion.active or not Context.discussion.id then return nil end
  local discussion = _discussions[Context.discussion.id]
  if not discussion then return nil end
  return discussion.steps[Context.discussion.step]
end

--- Advances to a specific step or ends the discussion.
--- @within Discussion
--- @param next_step number|nil The step index to go to, or nil to end.
function Discussion.go_to_step(next_step)
  if not next_step then
    Discussion.finish()
    return
  end
  local discussion = _discussions[Context.discussion.id]
  if not discussion or not discussion.steps[next_step] then
    Discussion.finish()
    return
  end
  Context.discussion.step = next_step
  Context.discussion.selected_answer = 1
  Context.discussion.scroll_y = 0
  Context.discussion.scroll_timer = 0
  Context.discussion.auto_scroll = true
end

--- Ends the active discussion and returns to the previous window.
--- @within Discussion
function Discussion.finish()
  local discussion = _discussions[Context.discussion.id]
  local return_window = Context.discussion.return_window or "game"
  Context.discussion.active = false
  Context.discussion.id = nil
  Context.discussion.scroll_y = 0
  Context.discussion.scroll_timer = 0
  Context.discussion.auto_scroll = true
  Meter.show()
  if discussion and discussion.on_end then
    discussion.on_end()
  end
  Window.set_current(return_window)
end
