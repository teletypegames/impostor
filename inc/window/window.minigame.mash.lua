function MinigameButtonMashWindow.init(params)
  Context.minigame_button_mash = Minigames.configure_button_mash(params)
end

function MinigameButtonMashWindow.start(return_window, params)
  MinigameButtonMashWindow.init(params)
  Context.minigame_button_mash.return_window = return_window or WINDOW_GAME
  Context.active_window = WINDOW_MINIGAME_BUTTON_MASH
end

function MinigameButtonMashWindow.update()
  local mg = Context.minigame_button_mash
  -- Check for Z button press
  if Input.select() then
    mg.bar_fill = mg.bar_fill + mg.fill_per_press
    mg.button_pressed_timer = mg.button_press_duration
    -- Clamp to max
    if mg.bar_fill > mg.max_fill then
      mg.bar_fill = mg.max_fill
    end
  end
  -- Check if bar is full (completed)
  if mg.bar_fill >= mg.max_fill then
    Context.active_window = mg.return_window
    return
  end
  -- Automatic degradation (increases with bar fill level)
  local degradation = mg.base_degradation + (mg.bar_fill * mg.degradation_multiplier)
  mg.bar_fill = mg.bar_fill - degradation
  -- Clamp to minimum
  if mg.bar_fill < 0 then
    mg.bar_fill = 0
  end
  -- Update button press timer
  if mg.button_pressed_timer > 0 then
    mg.button_pressed_timer = mg.button_pressed_timer - 1
  end
end

function MinigameButtonMashWindow.draw()
  local mg = Context.minigame_button_mash
  -- Draw the underlying window first (for overlay effect)
  if mg.return_window == WINDOW_GAME then
    GameWindow.draw()
  end
  -- Draw semi-transparent overlay background
  -- Draw darker rectangles to create overlay effect
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  -- Draw progress bar background
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  -- Draw progress bar fill
  local fill_width = (mg.bar_fill / mg.max_fill) * mg.bar_width
  if fill_width > 0 then
    -- Color changes as bar fills (green -> yellow -> red analogy using available colors)
    local bar_color = Config.colors.green
    if mg.bar_fill > 66 then
      bar_color = Config.colors.item -- yellow
    elseif mg.bar_fill > 33 then
      bar_color = Config.colors.blue
    end
    rect(mg.bar_x, mg.bar_y, fill_width, bar_color)
  end
  -- Draw button indicator
  local button_color = Config.colors.light_grey
  if mg.button_pressed_timer > 0 then
    button_color = Config.colors.green -- Highlight when pressed
  end
  circb(mg.button_x, mg.button_y, mg.button_size, button_color)
  if mg.button_pressed_timer > 0 then
    circ(mg.button_x, mg.button_y, mg.button_size - 2, button_color)
  end
  -- Draw Z text in the button
  Print.text_center(" Z", mg.button_x - 2, mg.button_y - 3, Config.colors.light_grey)
  -- Draw instruction text
  Print.text_center("MASH Z!", Config.screen.width / 2, mg.bar_y + mg.bar_height + 10, Config.colors.light_grey)
  -- Draw progress percentage
  local percentage = math.floor((mg.bar_fill / mg.max_fill) * 100)
  Print.text_center(percentage .. "%", mg.bar_x + mg.bar_width / 2, mg.bar_y + 2, Config.colors.black)
end