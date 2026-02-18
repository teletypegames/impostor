function MinigameRhythmWindow.init(params)
  Context.minigame_rhythm = Minigames.configure_rhythm(params)
end

function MinigameRhythmWindow.start(return_window, params)
  MinigameRhythmWindow.init(params)
  Context.minigame_rhythm.return_window = return_window or WINDOW_GAME
  Context.active_window = WINDOW_MINIGAME_RHYTHM
end

function MinigameRhythmWindow.update()
  local mg = Context.minigame_rhythm
  -- Move the line across the bar (bidirectional)
  mg.line_position = mg.line_position + (mg.line_speed * mg.line_direction)
  -- Reverse direction when reaching either end
  if mg.line_position > 1 then
    mg.line_position = 1
    mg.line_direction = -1
  elseif mg.line_position < 0 then
    mg.line_position = 0
    mg.line_direction = 1
  end
  -- Decrease cooldown timer
  if mg.press_cooldown > 0 then
    mg.press_cooldown = mg.press_cooldown - 1
  end
  -- Check for Z button press (only if cooldown expired)
  if Input.select() and mg.press_cooldown == 0 then
    mg.button_pressed_timer = mg.button_press_duration
    mg.press_cooldown = mg.press_cooldown_duration
    -- Calculate if line is within target area
    local target_left = mg.target_center - (mg.target_width / 2)
    local target_right = mg.target_center + (mg.target_width / 2)
    if mg.line_position >= target_left and mg.line_position <= target_right then
      -- HIT! Award point
      mg.score = mg.score + 1
    else
      -- MISS! Deduct point (but not below 0)
      mg.score = mg.score - 1
      if mg.score < 0 then
        mg.score = 0
      end
    end
    -- Calculate target width dynamically based on score
    -- Each point shrinks by 10%, so reverse the formula
    mg.target_width = mg.initial_target_width * (mg.target_shrink_rate ^ mg.score)
    if mg.target_width < mg.min_target_width then
      mg.target_width = mg.min_target_width
    end
  end
  -- Check win condition
  if mg.score >= mg.max_score then
    Context.active_window = mg.return_window
    return
  end
  -- Update button press timer
  if mg.button_pressed_timer > 0 then
    mg.button_pressed_timer = mg.button_pressed_timer - 1
  end
end

function MinigameRhythmWindow.draw()
  local mg = Context.minigame_rhythm
  -- Draw the underlying window first (for overlay effect)
  if mg.return_window == WINDOW_GAME then
    GameWindow.draw()
  end
  -- Draw semi-transparent overlay background
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  -- Calculate actual pixel positions
  -- Draw bar container background
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  -- Draw bar background (empty area)
  rect(mg.bar_x, mg.bar_y, mg.bar_width, mg.bar_height, Config.colors.dark_grey)
  -- Draw target area (highlighted section in middle)
  local target_left = mg.target_center - (mg.target_width / 2)
  local target_x = mg.bar_x + (target_left * mg.bar_width)
  local target_width_pixels = mg.target_width * mg.bar_width
  rect(target_x, mg.bar_y, target_width_pixels, mg.bar_height, Config.colors.green)
  -- Draw the moving line
  local line_x = mg.bar_x + (mg.line_position * mg.bar_width)
  rect(line_x - 1, mg.bar_y, 2, mg.bar_height, Config.colors.item) -- Yellow line
  -- Draw score text
  local score_text = "SCORE: " .. mg.score .. " / " .. mg.max_score
  Print.text_center(score_text, Config.screen.width / 2, mg.bar_y + mg.bar_height + 8, Config.colors.light_grey)
  -- Draw instruction text
  Print.text_center(
    "Press Z when line is in green!",
    Config.screen.width / 2,
    mg.bar_y + mg.bar_height + 20,
    Config.colors.light_grey
  )
  -- Draw button indicator in bottom-right corner
  local button_color = Config.colors.light_grey
  if mg.button_pressed_timer > 0 then
    button_color = Config.colors.green -- Highlight when pressed
  end
  -- Draw button circle
  circb(mg.button_x, mg.button_y, mg.button_size, button_color)
  if mg.button_pressed_timer > 0 then
    circ(mg.button_x, mg.button_y, mg.button_size - 2, button_color)
  end
  -- Draw Z text in the button
  Print.text_center("Z", mg.button_x - 2, mg.button_y - 3, button_color)
end