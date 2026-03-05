--- @section Trigger
local triggers = {}

--- @within Trigger
--- @param trigger table The trigger data table.
--- @param trigger.id string Unique trigger identifier.
--- @param trigger.duration number Duration in frames before the trigger fires.
--- @param[opt] trigger.on_start function Called when the trigger starts. Defaults to noop.
--- @param[opt] trigger.on_stop function Called when the trigger fires or is manually stopped. Defaults to noop.
--- @param[opt] trigger.repeating boolean If true, trigger restarts after firing. Defaults to false.
function Trigger.register(trigger)
  if not trigger or not trigger.id then
    trace("Error: Invalid trigger registered (missing id)!")
    return
  end
  if not trigger.duration or trigger.duration <= 0 then
    trace("Error: Invalid trigger registered (missing or invalid duration)!")
    return
  end

  if not trigger.on_start then
    trigger.on_start = function() end
  end
  if not trigger.on_stop then
    trigger.on_stop = function() end
  end
  if trigger.repeating == nil then
    trigger.repeating = false
  end
  if triggers[trigger.id] then
    trace("Warning: Overwriting trigger with id: " .. trigger.id)
  end
  triggers[trigger.id] = trigger
end

--- @within Trigger
--- @param id string The trigger ID.
--- @return table|nil result The trigger definition or nil.
function Trigger.get_by_id(id)
  return triggers[id]
end

--- @within Trigger
--- @return table result All trigger definitions keyed by ID.
function Trigger.get_all()
  return triggers
end

--- @within Trigger
--- @param id string The trigger ID.
--- @return boolean active True if the trigger is running.
function Trigger.is_active(id)
  if not Context or not Context.triggers then return false end
  return Context.triggers[id] ~= nil
end

--- If already active, restarts from 0.
--- @within Trigger
--- @param id string The trigger ID.
function Trigger.start(id)
  if not Context or not Context.triggers then return end
  local trigger = triggers[id]
  if not trigger then
    trace("Error: Cannot start unknown trigger: " .. tostring(id))
    return
  end

  Context.triggers[id] = { elapsed = 0 }
  trigger.on_start()
end

--- @within Trigger
--- @param id string The trigger ID.
function Trigger.stop(id)
  if not Context or not Context.triggers then return end
  local trigger = triggers[id]
  if not trigger then
    trace("Error: Cannot stop unknown trigger: " .. tostring(id))
    return
  end
  if not Context.triggers[id] then return end

  Context.triggers[id] = nil
  trigger.on_stop()
end

--- Resets elapsed time to 0 without calling handlers. No-op if inactive.
--- @within Trigger
--- @param id string The trigger ID.
function Trigger.reset(id)
  if not Context or not Context.triggers then return end
  if not triggers[id] then
    trace("Error: Cannot reset unknown trigger: " .. tostring(id))
    return
  end
  if not Context.triggers[id] then return end

  Context.triggers[id].elapsed = 0
end

--- Pauses during minigames.
--- @within Trigger
function Trigger.update()
  if not Context or not Context.game_in_progress or not Context.triggers then return end

  local in_minigame = string.find(Window.get_current_id(), "^minigame_") ~= nil
  if in_minigame then return end

  local fired = {}
  for id, state in pairs(Context.triggers) do
    local trigger = triggers[id]
    if trigger then
      state.elapsed = state.elapsed + 1
      if state.elapsed >= trigger.duration then
        table.insert(fired, id)
      end
    else
      table.insert(fired, id)
    end
  end

  for _, id in ipairs(fired) do
    local trigger = triggers[id]
    if trigger then
      trigger.on_stop()
      if trigger.repeating then
        Context.triggers[id] = { elapsed = 0 }
      else
        Context.triggers[id] = nil
      end
    else
      Context.triggers[id] = nil
    end
  end
end
