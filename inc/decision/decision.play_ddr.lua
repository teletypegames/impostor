Decision.register({
  id = "play_ddr",
  label = "Play DDR (Random)",
  handle = function() Meters.hide() MinigameDDRWindow.start(WINDOW_GAME, nil) end,
})
