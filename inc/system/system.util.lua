
--- @section Util

--- Safely wraps an index for an array.
--- @within Util
-- @param array table The array to index.
-- @param index number The desired index (can be out of bounds).
-- @return number The wrapped index within the array's bounds.
function Util.safeindex(array, index)
    return ((index - 1 + #array) % #array) + 1
end

--- Navigates to a screen by its ID.
--- @within Util
-- @param screen_id string The ID of the screen to go to.
function Util.go_to_screen_by_id(screen_id)
  local screen = Screen.get_by_id(screen_id)
  if screen then
    Context.game.current_screen = screen_id
    screen.init()
  else
    PopupWindow.show({"Error: Screen '" .. screen_id .. "' not found!"})
  end
end

--- Checks if a table contains a specific value.
--- @within Util
-- @param t table The table to check.
-- @param value any The value to look for.
function Util.contains(t, value)
  for i = 1, #t do
    if t[i] == value then
      return true
    end
  end
  return false
end