Decision.register({
  id = "play_rhythm",
  label = "Play Rhythm Game",
  handle = function() Meter.hide() MinigameRhythmWindow.start(WINDOW_GAME) end,
})
