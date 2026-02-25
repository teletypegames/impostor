--- @section MinigameButtonMashWindow

--- Initializes button mash minigame state.
--- @within MinigameButtonMashWindow
-- @param params table Optional parameters for configuration.
function MinigameButtonMashWindow.init(params)
  Context.minigame_button_mash = Minigame.configure_button_mash(params)
end

--- Starts the button mash minigame.
--- @within MinigameButtonMashWindow
-- @param return_window string The window ID to return to after the minigame.
-- @param[opt] params table Optional parameters for minigame configuration.
function MinigameButtonMashWindow.start(return_window, params)
  MinigameButtonMashWindow.init(params)
  Context.minigame_button_mash.return_window = return_window or "game"
  Window.set_current("minigame_button_mash")
end

--- Updates button mash minigame logic.
--- @within MinigameButtonMashWindow
function MinigameButtonMashWindow.update()
  local mg = Context.minigame_button_mash
  if Input.select() then
    mg.bar_fill = mg.bar_fill + mg.fill_per_press
    mg.button_pressed_timer = mg.button_press_duration
    if mg.bar_fill > mg.max_fill then
      mg.bar_fill = mg.max_fill
    end
  end
  if mg.bar_fill >= mg.max_fill then
    Meter.on_minigame_complete()
    Meter.show()
    Window.set_current(mg.return_window)
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
end

--- Draws button mash minigame.
--- @within MinigameButtonMashWindow
function MinigameButtonMashWindow.draw()
  local mg = Context.minigame_button_mash
  if mg.return_window == "game" then
    GameWindow.draw()
  end
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  local fill_width = (mg.bar_fill / mg.max_fill) * mg.bar_width
  if fill_width > 0 then
    local bar_color = Config.colors.green
    if mg.bar_fill > 66 then
      bar_color = Config.colors.item
    elseif mg.bar_fill > 33 then
      bar_color = Config.colors.blue
    end
    rect(mg.bar_x, mg.bar_y, fill_width, mg.bar_height, bar_color)
  end
  local button_color = Config.colors.light_grey
  if mg.button_pressed_timer > 0 then
    button_color = Config.colors.green
  end
  circb(mg.button_x, mg.button_y, mg.button_size, button_color)
  if mg.button_pressed_timer > 0 then
    circ(mg.button_x, mg.button_y, mg.button_size - 2, button_color)
  end
  Print.text_center(" Z", mg.button_x - 2, mg.button_y - 3, Config.colors.light_grey)
  Print.text_center("MASH Z!", Config.screen.width / 2, mg.bar_y + mg.bar_height + 10, Config.colors.light_grey)
  local percentage = math.floor((mg.bar_fill / mg.max_fill) * 100)
  Print.text_center(percentage .. "%", mg.bar_x + mg.bar_width / 2, mg.bar_y + 2, Config.colors.black)
end
