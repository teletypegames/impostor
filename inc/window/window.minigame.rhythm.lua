--- @section MinigameRhythmWindow

--- Gets initial rhythm minigame configuration.
--- @within MinigameRhythmWindow
--- @return result table The default rhythm minigame configuration.
function MinigameRhythmWindow.init_context()
  return {
    line_position = 0,
    line_speed = 0.015,
    line_direction = 1,
    target_center = 0.5,
    target_width = 0.3,
    initial_target_width = 0.3,
    min_target_width = 0.08,
    target_shrink_rate = 0.9,
    score = 0,
    max_score = 10,
    button_pressed_timer = 0,
    button_press_duration = 10,
    return_window = nil,
    bar_x = 20,
    bar_y = 10,
    bar_width = 200,
    bar_height = 12,
    button_x = 210,
    button_y = 110,
    button_size = 10,
    press_cooldown = 0,
    press_cooldown_duration = 15,
    focus_center_x = nil,
    focus_center_y = nil,
    focus_initial_radius = 0,
    win_timer = 0
  }
end

--- Initializes rhythm minigame state.
--- @within MinigameRhythmWindow
--- @param params table Optional parameters for configuration.<br/>
function MinigameRhythmWindow.init(params)
  local defaults = MinigameRhythmWindow.init_context()
  if params then
    for k, v in pairs(params) do
      defaults[k] = v
    end
  end
  Context.minigame_rhythm = defaults
end

--- Starts the rhythm minigame.
--- @within MinigameRhythmWindow
--- @param return_window string The window ID to return to after the minigame.<br/>
--- @param[opt] params table Optional parameters for minigame configuration.<br/>
function MinigameRhythmWindow.start(return_window, params)
  MinigameRhythmWindow.init(params)
  local mg = Context.minigame_rhythm
  mg.return_window = return_window or "game"
  if mg.focus_center_x then
    Focus.start_driven(mg.focus_center_x, mg.focus_center_y, {
      initial_radius = mg.focus_initial_radius
    })
  end
  Window.set_current("minigame_rhythm")
end

--- Updates rhythm minigame logic.
--- @within MinigameRhythmWindow
function MinigameRhythmWindow.update()
  local mg = Context.minigame_rhythm

  if mg.win_timer > 0 then
    mg.win_timer = mg.win_timer - 1
    if mg.win_timer == 0 then
      Meter.on_minigame_complete()
      Meter.show()
      if mg.focus_center_x then Focus.stop() end
      Window.set_current(mg.return_window)
    end
    return
  end

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
    mg.win_timer = Config.timing.minigame_win_duration
    return
  end
  if mg.button_pressed_timer > 0 then
    mg.button_pressed_timer = mg.button_pressed_timer - 1
  end
  if mg.focus_center_x then
    Focus.set_percentage(1 - mg.score / mg.max_score)
  end
end

--- Draws rhythm minigame.
--- @within MinigameRhythmWindow
function MinigameRhythmWindow.draw()
  local mg = Context.minigame_rhythm
  if mg.return_window == "game" then
    GameWindow.draw()
  end
  if not mg.focus_center_x then
    rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  end
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  rect(mg.bar_x, mg.bar_y, mg.bar_width, mg.bar_height, Config.colors.dark_grey)
  local target_left = mg.target_center - (mg.target_width / 2)
  local target_x = mg.bar_x + (target_left * mg.bar_width)
  local target_width_pixels = mg.target_width * mg.bar_width
  rect(target_x, mg.bar_y, target_width_pixels, mg.bar_height, Config.colors.light_blue)
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
    button_color = Config.colors.light_blue
  end
  circb(mg.button_x, mg.button_y, mg.button_size, button_color)
  if mg.button_pressed_timer > 0 then
    circ(mg.button_x, mg.button_y, mg.button_size - 2, button_color)
  end
  Print.text_center("Z", mg.button_x - 2, mg.button_y - 3, button_color)

  if mg.win_timer > 0 then
    Minigame.draw_win_overlay()
  end
end
