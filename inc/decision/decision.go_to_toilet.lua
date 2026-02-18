DecisionManager.register({
  id = "go_to_toilet",
  label = "Go to Toilet",
  handle = function()
    Util.go_to_screen_by_id("toilet")
  end,
  condition = function() return true end
})
