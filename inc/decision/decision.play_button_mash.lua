Decision.register({
  id = "play_button_mash",
  label = "Play Button Mash",
  handle = function()
    Meter.hide()
    MinigameButtonMashWindow.start("game", {
      focus_center_x = (Config.screen.width / 2) - 22,
      focus_center_y = (Config.screen.height / 2) - 18,
      focus_initial_radius = 0,
    })
  end,
})
