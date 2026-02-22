Decision.register({
  id = "play_ddr",
  label = "Play DDR (Random)",
  handle = function() Meter.hide() MinigameDDRWindow.start("game", nil) end,
})
