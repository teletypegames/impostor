--- Gets initial button mash minigame configuration.
--- @within MinigameButtonMashWindow
--- @return result table The default button mash minigame configuration.
function MinigameButtonMashWindow.init_context()
  return {
    bar_fill = 0,
    target_points = 100,
    fill_per_press = 8,
    base_degradation = 0.15,
    degradation_multiplier = 0.006,
    button_pressed_timer = 0,
    button_press_duration = 8,
    instruction_text = "MASH Z!",
    show_progress_text = true,
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
    win_timer = 0,
    on_win = nil
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
    if params.max_fill and not params.target_points then
      defaults.target_points = params.max_fill
    end
  end
  Context.minigame_button_mash = defaults
end

--- Starts the button mash minigame.
--- @within MinigameButtonMashWindow
--- @param return_window string The window ID to return to after the minigame.<br/>
--- @param[opt] params table Optional parameters for minigame configuration.<br/>
function MinigameButtonMashWindow.start(return_window, params)
  Audio.music_stop()
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
      if mg.focus_center_x then Focus.stop() end
      Context.home_norman_visible = true
      Context.have_done_work_today = false
      Context.have_been_to_office = false
      if mg.on_win then
        mg.on_win()
      else
        Meter.show()
        Window.set_current(mg.return_window)
      end
    end
    return
  end

  local mouse_on_button = Mouse.zone_circle({ x = mg.button_x, y = mg.button_y, r = mg.button_size })

  if Input.select() or mouse_on_button then
    Audio.sfx_drum_high()

    mg.bar_fill = mg.bar_fill + mg.fill_per_press
    mg.button_pressed_timer = mg.button_press_duration
    if mg.bar_fill > mg.target_points then
      mg.bar_fill = mg.target_points
    end
  end
  if mg.bar_fill >= mg.target_points then
    Audio.sfx_select()
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
    Focus.set_percentage(mg.bar_fill / mg.target_points)
  end
end

--- Draws button mash minigame.
--- @within MinigameButtonMashWindow
function MinigameButtonMashWindow.draw()
  local mg = Context.minigame_button_mash
  if mg.return_window == "game" then
    GameWindow.draw_with_underlay(function()
      Sprite.draw_at("sleeping_norman", (Config.screen.width / 2) - 30, (Config.screen.height / 2) - 22)
    end)
  end
  if not mg.focus_center_x then
    rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  end
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  local fill_width = (mg.bar_fill / mg.target_points) * mg.bar_width
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
  Print.text_center("Z", mg.button_x, mg.button_y - 3, button_color)
  Print.text_center_contour(mg.instruction_text, Config.screen.width / 2, mg.bar_y + mg.bar_height + 10, Config.colors.light_blue)
  if mg.show_progress_text then
    local points_text = math.floor(mg.bar_fill) .. "/" .. mg.target_points
    Print.text_center(points_text, mg.bar_x + mg.bar_width / 2, mg.bar_y + 2, Config.colors.black)
  end

  if mg.win_timer > 0 then
    Minigame.draw_win_overlay()
  end
end
