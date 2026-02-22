local initialized_game = false

--- Initializes game state.
local function init_game()
  if initialized_game then return end
  Context.reset()
  Window.set_current("splash") -- Set initial window using new manager
  MenuWindow.refresh_menu_items()
  initialized_game = true
end

--- Main game loop (TIC-80 callback).
function TIC()
  init_game()
  cls(Config.colors.black)
  local handler = Window.get_current_handler() -- Get handler from Window manager
  if handler then
    handler()
  end
  Meter.update()
  if Context.game_in_progress then
    UI.draw_meters()
  end
end
