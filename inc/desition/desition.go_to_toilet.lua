DesitionManager.register({
  id = "go_to_toilet",
  label = "Go to Toilet",
  handle = function()
    local screen_index = Context.screen_indices_by_id["toilet"]
    if screen_index then
      Context.current_screen = screen_index
      Context.selected_desition_index = 1
    else
      PopupWindow.show({"Error: Screen 'toilet' not found or not indexed!"})
    end
  end,
  condition = function() return true end
})
