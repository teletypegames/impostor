Util = {}

function Util.create_decision(id, label, handler)
  return {
    id = id,
    label = label,
    handler = handler
  }
end

function Util.safeindex(array, index)
    return ((index - 1 + #array) % #array) + 1
end
