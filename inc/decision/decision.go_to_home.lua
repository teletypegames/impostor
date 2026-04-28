Decision.register({
  id = "go_to_home",
  label = "Go Home",
  condition = function()
    if CommuteGlitch.is_active() then
      local g = CommuteGlitch.get_level()
      if g >= 4 and g <= 5 then return false end
      if g >= 7 then
        return Context.talked_to_norman_echo and Context.talked_to_true_sumphore
      end
    end
    return Context.have_been_to_office and Context.have_done_work_today
  end,
  handle = function()
    if CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 7 then
      Context.should_ascend = true
      CommuteGlitch.reset()
      Meter.hide()
      Day.increase()
      local ascended = Ascension.consume_increase()
      local level = Ascension.get_level()
      MysteriousManScreen.start({
          skip_text = not ascended,
          text = ascended and MysteriousManScreen.get_text_for_level(level) or nil,
      })
      return
    elseif CommuteGlitch.is_active() then
      CommuteGlitch.reset()
    end

    Util.go_to_screen_by_id("home")
  end,
})
