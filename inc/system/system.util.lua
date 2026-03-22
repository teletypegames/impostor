
--- @section Util

--- Safely wraps an index for an array.
--- @within Util
--- @param array table The array to index.
--- @param index number The desired index (can be out of bounds).
--- @return number index The wrapped index within the array's bounds.
function Util.safeindex(array, index)
    return ((index - 1 + #array) % #array) + 1
end

--- Navigates to a screen by its ID.
--- @within Util
--- @param screen_id string The ID of the screen to go to.<br/>
function Util.go_to_screen_by_id(screen_id)
  local prev_screen = Screen.get_by_id(Context.game.current_screen)
  local new_screen = Screen.get_by_id(screen_id)
  if new_screen then
    Context.game.current_screen = screen_id
    if prev_screen and prev_screen.exit then
      prev_screen.exit()
    end
    new_screen.init()
  else
    PopupWindow.show({"Error: Screen '" .. screen_id .. "' not found!"})
  end
end

--- Checks if a table contains a specific value.
--- @within Util
--- @param t table The table to check.
--- @param value any The value to look for.<br/>
--- @return boolean true if the value is found, false otherwise.
function Util.contains(t, value)
  for i = 1, #t do
    if t[i] == value then
      return true
    end
  end
  return false
end

--- Deep copies tables
--- @within Util
--- @param orig any The value to deep copy.
--- @param seen any Used for recursive calls to handle loops
--- @return any any The copied object
function Util.deepcopy(orig, seen)
  if type(orig) ~= "table" then
    return orig
  end

  if seen and seen[orig] then
    return seen[orig]  -- handle cycles / shared refs
  end

  local copy = {}
  seen = seen or {}
  seen[orig] = copy

  for k, v in pairs(orig) do
    local new_k = Util.deepcopy(k, seen)
    local new_v = Util.deepcopy(v, seen)
    copy[new_k] = new_v
  end

  return setmetatable(copy, getmetatable(orig))
end
