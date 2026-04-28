Decision.register({
  id = "go_to_office",
  label = "Go to Office",
  condition = function()
    return not (CommuteGlitch.is_active() and CommuteGlitch.get_level() == 6)
  end,
  handle = function()
    if CommuteGlitch.is_active() then
      CommuteGlitch.increment()
    end

    Util.go_to_screen_by_id("office")
  end,
})
