--- @section Day
local _day_increase_handlers = {}

--- Increases the day count and triggers registered handlers.
--- @within Day
function Day.increase()
    Context.day_count = Context.day_count + 1
    for _, handler in ipairs(_day_increase_handlers) do
        handler()
    end
end

--- Registers a handler to be called when the day increases.
--- @within Day
--- @param handler function The function to call when the day increases.
function Day.register_handler(handler)
    table.insert(_day_increase_handlers, handler)
end

Day.register_handler(function()
    local m = Context.meters
    m.ism = math.max(0, m.ism - METER_DECAY_PER_DAY)
    m.wpm = math.max(0, m.wpm - METER_DECAY_PER_DAY)
    m.bm = math.max(0, m.bm - METER_DECAY_PER_DAY)
end)