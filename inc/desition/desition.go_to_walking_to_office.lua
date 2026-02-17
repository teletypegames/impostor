DesitionManager.register({
  id = "go_to_walking_to_office",
  label = "Go to Walking to office",
  handle = function()
    local screen_index = Context.screen_indices_by_id["walking_to_office"]
    if screen_index then
      Context.current_screen = screen_index
      Context.selected_desition_index = 1
    else
      PopupWindow.show({"Error: Screen 'walking_to_office' not found or not indexed!"})
    end
  end,
  condition = function() return true end
})
