--- Initializes rhythm minigame state.
-- @param params table Optional parameters for configuration.
function MinigameRhythmWindow.init(params)
  Context.minigame_rhythm = Minigames.configure_rhythm(params)
end

--- Starts the rhythm minigame.
-- @param return_window number The window ID to return to after the minigame.
-- @param[opt] params table Optional parameters for minigame configuration.
function MinigameRhythmWindow.start(return_window, params)
  MinigameRhythmWindow.init(params)
  Context.minigame_rhythm.return_window = return_window or WINDOW_GAME
  Context.active_window = WINDOW_MINIGAME_RHYTHM
end

--- Updates rhythm minigame logic.
function MinigameRhythmWindow.update()
  local mg = Context.minigame_rhythm
  mg.line_position = mg.line_position + (mg.line_speed * mg.line_direction)
  if mg.line_position > 1 then
    mg.line_position = 1
    mg.line_direction = -1
  elseif mg.line_position < 0 then
    mg.line_position = 0
    mg.line_direction = 1
  end
  if mg.press_cooldown > 0 then
    mg.press_cooldown = mg.press_cooldown - 1
  end
  if Input.select() and mg.press_cooldown == 0 then
    mg.button_pressed_timer = mg.button_press_duration
    mg.press_cooldown = mg.press_cooldown_duration
    local target_left = mg.target_center - (mg.target_width / 2)
    local target_right = mg.target_center + (mg.target_width / 2)
    if mg.line_position >= target_left and mg.line_position <= target_right then
      mg.score = mg.score + 1
    else
      mg.score = mg.score - 1
      if mg.score < 0 then
        mg.score = 0
      end
    end
    mg.target_width = mg.initial_target_width * (mg.target_shrink_rate ^ mg.score)
    if mg.target_width < mg.min_target_width then
      mg.target_width = mg.min_target_width
    end
  end
  if mg.score >= mg.max_score then
    Meters.on_minigame_complete()
    Meters.show()
    Context.active_window = mg.return_window
    return
  end
  if mg.button_pressed_timer > 0 then
    mg.button_pressed_timer = mg.button_pressed_timer - 1
  end
end

--- Draws rhythm minigame.
function MinigameRhythmWindow.draw()
  local mg = Context.minigame_rhythm
  if mg.return_window == WINDOW_GAME then
    GameWindow.draw()
  end
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  rect(mg.bar_x, mg.bar_y, mg.bar_width, mg.bar_height, Config.colors.dark_grey)
  local target_left = mg.target_center - (mg.target_width / 2)
  local target_x = mg.bar_x + (target_left * mg.bar_width)
  local target_width_pixels = mg.target_width * mg.bar_width
  rect(target_x, mg.bar_y, target_width_pixels, mg.bar_height, Config.colors.green)
  local line_x = mg.bar_x + (mg.line_position * mg.bar_width)
  rect(line_x - 1, mg.bar_y, 2, mg.bar_height, Config.colors.item)
  local score_text = "SCORE: " .. mg.score .. " / " .. mg.max_score
  Print.text_center(score_text, Config.screen.width / 2, mg.bar_y + mg.bar_height + 8, Config.colors.light_grey)
  Print.text_center(
    "Press Z when line is in green!",
    Config.screen.width / 2,
    mg.bar_y + mg.bar_height + 20,
    Config.colors.light_grey
  )
  local button_color = Config.colors.light_grey
  if mg.button_pressed_timer > 0 then
    button_color = Config.colors.green
  end
  circb(mg.button_x, mg.button_y, mg.button_size, button_color)
  if mg.button_pressed_timer > 0 then
    circ(mg.button_x, mg.button_y, mg.button_size - 2, button_color)
  end
  Print.text_center("Z", mg.button_x - 2, mg.button_y - 3, button_color)
end
