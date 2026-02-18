DecisionManager.register({
  id = "play_rhythm",
  label = "Play Rhythm Game",
  handle = function() MinigameRhythmWindow.start(WINDOW_GAME) end,
  condition = function() return true end
})
