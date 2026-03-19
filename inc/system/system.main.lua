--- @section Main
local initialized_game = false

--- Initializes game state.
--- @within Main
--- @return boolean initialized_game True if game has been initialized, false otherwise.
local function init_game()
  if initialized_game then return false end
  Context.reset()
  Window.set_current("intro_title") -- Set initial window using new manager
  MenuWindow.refresh_menu_items()
  initialized_game = true
  return true
end

--- Main game loop (TIC-80 callback).
--- @within Main
function TIC()
  init_game()
  cls(Config.colors.black)
  local handler = Window.get_current_handler() -- Get handler from Window manager
  if handler then
    handler()
  end
  Meter.update()
  Timer.update()
  Trigger.update()
  Glitch.draw()
  Ascension.update_fade()
  if Context.game_in_progress then
    Meter.draw()
    Timer.draw()
  end
  Ascension.draw_flash()
end
