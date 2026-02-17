DesitionManager.register({
  id = "go_to_office",
  label = "Go to Office",
  handle = function()
    local screen_index = Context.screen_indices_by_id["office"]
    if screen_index then
      Context.current_screen = screen_index
      Context.selected_desition_index = 1
    else
      PopupWindow.show({"Error: Screen 'office' not found or not indexed!"})
    end
  end,
  condition = function() return true end
})
