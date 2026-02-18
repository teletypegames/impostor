Util = {}

function Util.safeindex(array, index)
    return ((index - 1 + #array) % #array) + 1
end

function Util.go_to_screen_by_id(screen_id)
  local screen_index = Context.screen_indices_by_id[screen_id]
  if screen_index then
    Context.current_screen = screen_index
    Context.selected_decision_index = 1   else
    PopupWindow.show({"Error: Screen '" .. screen_id .. "' not found or not indexed!"})
  end
end