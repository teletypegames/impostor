Decision.register({
  id = "go_to_walking_to_home",
  label = "Walk home",
  condition= function ()
    return
      (not CommuteGlitch.is_active()) or
      (CommuteGlitch.is_active() and CommuteGlitch.get_level() ~= 7) or
      (CommuteGlitch.is_active() and CommuteGlitch.get_level() == 7 and Context.talked_to_norman_echo)
  end,
  handle = function()
    Util.go_to_screen_by_id("walking_to_home")
  end,
})
