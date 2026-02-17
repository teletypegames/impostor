DesitionManager.register({
  id = "go_to_home",
  label = "Go to Home",
  handle = function()
    local screen_index = Context.screen_indices_by_id["home"]
    if screen_index then
      Context.current_screen = screen_index
      Context.selected_desition_index = 1
    else
      PopupWindow.show({"Error: Screen 'home' not found or not indexed!"})
    end
  end,
  condition = function() return true end
})
