DesitionManager.register({
  id = "go_to_office",
  label = "Go to Office",
  handle = function()
    Util.go_to_screen_by_id("office")
  end,
  condition = function() return true end
})
