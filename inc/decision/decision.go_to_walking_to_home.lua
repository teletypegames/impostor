Decision.register({
  id = "go_to_walking_to_home",
  label = "Walk home",
  handle = function()
    Util.go_to_screen_by_id("walking_to_home")
  end,
})
