Decision.register({
  id = "play_rhythm",
  label = "Play Rhythm Game",
  handle = function() Meter.hide() MinigameRhythmWindow.start("game") end,
})
