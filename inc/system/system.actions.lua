
function Actions.start_minigame_mash()
  MinigameButtonMashWindow.start(WINDOW_GAME)
end

function Actions.start_minigame_rhythm()
  MinigameRhythmWindow.start(WINDOW_GAME)
end

function Actions.start_minigame_ddr(song_key)
  MinigameDDRWindow.start(WINDOW_GAME, song_key)
end
