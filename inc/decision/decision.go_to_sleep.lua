Decision.register({
  id = "go_to_sleep",
  label = function()
    if Ascension.get_level() >= 8 then
      return "Break the Loop"
    end
    return "Go to Sleep"
  end,
  condition = function()
    return Context.have_been_to_office and Context.have_done_work_today
  end,
  handle = function()
    Meter.hide()
    Day.increase()
    MinigameRhythmWindow.start("game", {
      focus_center_x = (Config.screen.width / 2) - 22,
      focus_center_y = (Config.screen.height / 2) - 18,
      focus_initial_radius = 0,
      on_win = function()
        if Ascension.get_level() == 8 then
          Ascension.increase()
        end
        local ascended = Ascension.consume_increase()
        local level = Ascension.get_level()
        MysteriousManScreen.start({
          skip_text = not ascended,
          text = ascended and MysteriousManScreen.get_text_for_level(level) or nil,
          break_mode = level >= 9,
        })
      end,
    })
  end,
})
