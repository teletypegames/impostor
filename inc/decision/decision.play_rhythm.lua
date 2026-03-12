Decision.register({
  id = "play_rhythm",
  label = "Play Rhythm Game",
  handle = function()
    Meter.hide()
    MinigameRhythmWindow.start("game", {
      focus_center_x = (Config.screen.width / 2) - 22,
      focus_center_y = (Config.screen.height / 2) - 18,
      focus_initial_radius = 0,
    })
  end,
})
