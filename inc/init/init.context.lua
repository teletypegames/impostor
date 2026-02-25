local SAVE_GAME_BANK = 6
local SAVE_GAME_MAGIC_VALUE_ADDRESS = 0
local SAVE_GAME_MAGIC_VALUE = 0xCA

--- Global game context.
--- @section Context
Context = {}

--- Gets initial data for Context.
--- @within Context
-- @return table Initial context data.
function Context.initial_data()
  return {
    current_menu_item = 1,
    splash_timer = Config.timing.splash_duration,
    popup = {
      show = false,
      content = {}
    },
    game_in_progress = false,
    minigame_ddr = Minigame.get_default_ddr(),
    minigame_button_mash = Minigame.get_default_button_mash(),
    minigame_rhythm = Minigame.get_default_rhythm(),
    meters = Meter.get_initial(),
    game = {
      current_screen = "home",
      current_situation = nil,
    }
  }
end

--- Resets game context to initial state.
--- @within Context
function Context.reset()
  local initial_data = Context.initial_data()
  for k in pairs(Context) do
    if type(Context[k]) ~= "function" then
      Context[k] = nil
    end
  end

  for k, v in pairs(initial_data) do
    Context[k] = v
  end
end

--- Starts a new game.
--- @within Context
function Context.new_game()
  Context.reset()
  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
  Screen.get_by_id(Context.game.current_screen).init()
end

--- Saves the current game state.
--- @within Context
function Context.save_game()
  if not Context.game_in_progress then return end
  mset(SAVE_GAME_MAGIC_VALUE, SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK)
end

--- Loads a saved game state.
--- @within Context
function Context.load_game()
  if mget(SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK) ~= SAVE_GAME_MAGIC_VALUE then
    Context.new_game()
    return
  end
  Context.reset()
  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
  Screen.get_by_id(Context.game.current_screen).init()
end
