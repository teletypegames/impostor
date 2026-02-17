DesitionManager.register({
  id = "play_ddr",
  label = "Play DDR (Random)",
  handle = function() MinigameDDRWindow.start(WINDOW_GAME, nil) end,
  condition = function() return true end
})
