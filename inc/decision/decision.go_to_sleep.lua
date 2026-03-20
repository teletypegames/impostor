Decision.register({
  id = "go_to_sleep",
  label = "Go to Sleep",
  handle = function()
    Meter.hide()
    Day.increase()
    MinigameRhythmWindow.start("game", {
      focus_center_x = (Config.screen.width / 2) - 22,
      focus_center_y = (Config.screen.height / 2) - 18,
      focus_initial_radius = 0,
      on_win = function()
        local ascended = Ascension.consume_increase()
        MysteriousManScreen.start({ skip_text = not ascended })
      end,
    })
  end,
})
