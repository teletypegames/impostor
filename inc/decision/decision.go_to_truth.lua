Decision.register({
  id = "go_to_truth",
  label = "Go to Truth",
  condition = function()
    return CommuteGlitch.is_active() and CommuteGlitch.get_level() == 6
  end,
  handle = function()
    CommuteGlitch.enter_truth()
    
    Util.go_to_screen_by_id("office")
  end,
})
