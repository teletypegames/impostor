Decision.register({
  id = "play_button_mash",
  label = "Play Button Mash",
  handle = function() Meter.hide() MinigameButtonMashWindow.start(WINDOW_GAME) end,
})
