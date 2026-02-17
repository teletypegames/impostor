Desitions = {}

function Desitions.go_to_screen(screen_id)
  for i, screen_data in ipairs(Context.screens) do
    if screen_data.id == screen_id then
      Context.current_screen = i
      Context.selected_desition_index = 1 -- Reset selected decision on new screen
      return
    end
  end
  -- Handle error: screen_id not found, perhaps show a debug message or a popup
  PopupWindow.show({"Error: Screen '" .. screen_id .. "' not found!"})
end

-- Specific navigation helpers
function Desitions.go_to_home() Desitions.go_to_screen("home") end
function Desitions.go_to_toilet() Desitions.go_to_screen("toilet") end
function Desitions.go_to_walking_to_office() Desitions.go_to_screen("walking_to_office") end
function Desitions.go_to_office() Desitions.go_to_screen("office") end
function Desitions.go_to_walking_to_home() Desitions.go_to_screen("walking_to_home") end

-- Minigame functions
function Desitions.start_minigame_mash()
  MinigameButtonMashWindow.start(WINDOW_GAME)
end

function Desitions.start_minigame_rhythm()
  MinigameRhythmWindow.start(WINDOW_GAME)
end

function Desitions.start_minigame_ddr(song_key)
  MinigameDDRWindow.start(WINDOW_GAME, song_key)
end