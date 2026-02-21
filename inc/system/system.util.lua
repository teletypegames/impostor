--- Utility functions.
Util = {}

--- Safely wraps an index for an array.
-- @param array table The array to index.
-- @param index number The desired index (can be out of bounds).
-- @return number The wrapped index within the array's bounds.
function Util.safeindex(array, index)
    return ((index - 1 + #array) % #array) + 1
end

--- Navigates to a screen by its ID.
-- @param screen_id string The ID of the screen to go to.
function Util.go_to_screen_by_id(screen_id)
  local screen_index = Context.screen_indices_by_id[screen_id]
  if screen_index then
    Context.current_screen = screen_index
    Context.selected_decision_index = 1   else
    PopupWindow.show({"Error: Screen '" .. screen_id .. "' not found or not indexed!"})
  end
end
