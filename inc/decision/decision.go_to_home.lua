Decision.register({
  id = "go_to_home",
  label = "Go to Home",
  handle = function()
    Util.go_to_screen_by_id("home")
  end,
  condition = function() return true end
})
