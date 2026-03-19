Decision.register({
  id = "go_to_end",
  label = "Break the cycle",
  condition = function()
    return Ascension.is_complete()
  end,
  handle = function()
    Window.set_current("end")
  end,
})
