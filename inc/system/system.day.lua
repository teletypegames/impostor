local _day_increase_handlers = {}

function Day.increase()
    Context.day_count = Context.day_count + 1
    for _, handler in ipairs(_day_increase_handlers) do
        handler()
    end
end
function Day.register_handler(handler)
    table.insert(_day_increase_handlers, handler)
end
