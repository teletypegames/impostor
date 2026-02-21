Decision.register({
  id = "go_to_walking_to_office",
  label = "Walking to office",
  handle = function()
    Util.go_to_screen_by_id("walking_to_office")
  end,
  condition = function() return true end
})
