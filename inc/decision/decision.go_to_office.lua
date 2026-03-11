Decision.register({
  id = "go_to_office",
  label = "Go to Office",
  handle = function()
    Glitch.show()
    Util.go_to_screen_by_id("office")
  end,
})
