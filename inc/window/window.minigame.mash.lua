--- Gets initial button mash minigame configuration.
--- @within MinigameButtonMashWindow
--- @return result table The default button mash minigame configuration.
function MinigameButtonMashWindow.init_context()
  return {
    bar_fill = 0,
    max_fill = 100,
    fill_per_press = 8,
    base_degradation = 0.15,
    degradation_multiplier = 0.006,
    button_pressed_timer = 0,
    button_press_duration = 8,
    return_window = nil,
    bar_x = 20,
    bar_y = 10,
    bar_width = 200,
    bar_height = 12,
    button_x = 20,
    button_y = 110,
    button_size = 12,
    focus_center_x = nil,
    focus_center_y = nil,
    focus_initial_radius = 0,
    win_timer = 0
  }
end

--- Initializes button mash minigame state.
--- @within MinigameButtonMashWindow
--- @param params table Optional parameters for configuration.<br/>
function MinigameButtonMashWindow.init(params)
  local defaults = MinigameButtonMashWindow.init_context()
  if params then
    for k, v in pairs(params) do
      defaults[k] = v
    end
  end
  Context.minigame_button_mash = defaults
end

--- Starts the button mash minigame.
--- @within MinigameButtonMashWindow
--- @param return_window string The window ID to return to after the minigame.<br/>
--- @param[opt] params table Optional parameters for minigame configuration.<br/>
function MinigameButtonMashWindow.start(return_window, params)
  MinigameButtonMashWindow.init(params)
  local mg = Context.minigame_button_mash
  mg.return_window = return_window or "game"
  if mg.focus_center_x then
    Focus.start_driven(mg.focus_center_x, mg.focus_center_y, {
      initial_radius = mg.focus_initial_radius
    })
  end
  Window.set_current("minigame_button_mash")
end

--- Updates button mash minigame logic.
--- @within MinigameButtonMashWindow
function MinigameButtonMashWindow.update()
  local mg = Context.minigame_button_mash

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

  if Input.select() then
    mg.bar_fill = mg.bar_fill + mg.fill_per_press
    mg.button_pressed_timer = mg.button_press_duration
    if mg.bar_fill > mg.max_fill then
      mg.bar_fill = mg.max_fill
    end
  end
  if mg.bar_fill >= mg.max_fill then
    mg.win_timer = Config.timing.minigame_win_duration
    return
  end
  local degradation = mg.base_degradation + (mg.bar_fill * mg.degradation_multiplier)
  mg.bar_fill = mg.bar_fill - degradation
  if mg.bar_fill < 0 then
    mg.bar_fill = 0
  end
  if mg.button_pressed_timer > 0 then
    mg.button_pressed_timer = mg.button_pressed_timer - 1
  end
  if mg.focus_center_x then
    Focus.set_percentage(mg.bar_fill / mg.max_fill)
  end
end

--- Draws button mash minigame.
--- @within MinigameButtonMashWindow
function MinigameButtonMashWindow.draw()
  local mg = Context.minigame_button_mash
  if mg.return_window == "game" then
    GameWindow.draw()
  end
  if not mg.focus_center_x then
    rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  end
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  local fill_width = (mg.bar_fill / mg.max_fill) * mg.bar_width
  if fill_width > 0 then
    local bar_color = Config.colors.light_blue
    if mg.bar_fill > 66 then
      bar_color = Config.colors.item
    elseif mg.bar_fill > 33 then
      bar_color = Config.colors.blue
    end
    rect(mg.bar_x, mg.bar_y, fill_width, mg.bar_height, bar_color)
  end
  local button_color = Config.colors.light_grey
  if mg.button_pressed_timer > 0 then
    button_color = Config.colors.light_blue
  end
  circb(mg.button_x, mg.button_y, mg.button_size, button_color)
  if mg.button_pressed_timer > 0 then
    circ(mg.button_x, mg.button_y, mg.button_size - 2, button_color)
  end
  Print.text_center(" Z", mg.button_x - 2, mg.button_y - 3, Config.colors.light_grey)
  Print.text_center("MASH Z!", Config.screen.width / 2, mg.bar_y + mg.bar_height + 10, Config.colors.light_grey)
  local percentage = math.floor((mg.bar_fill / mg.max_fill) * 100)
  Print.text_center(percentage .. "%", mg.bar_x + mg.bar_width / 2, mg.bar_y + 2, Config.colors.black)

  if mg.win_timer > 0 then
    Minigame.draw_win_overlay()
  end
end
