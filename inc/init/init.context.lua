local SAVE_GAME_BANK = 6
local SAVE_GAME_MAGIC_VALUE_ADDRESS = 0
local SAVE_GAME_MAGIC_VALUE = 0xCA

--- Global game context.
--- @section Context
Context = {}

--- Gets initial data for Context.
--- @within Context
--- @return result table Initial context data or nil. </br>
--- Fields: </br>
--- * current_menu_item (number) Index of the currently selected menu item.<br/>
--- * popup (table) Popup window state. Contains: `show` (boolean) whether popup is visible, `content` (table) array of strings to display.<br/>
--- * game_in_progress (boolean) Whether a game is currently active.<br/>
--- * minigame_ddr (table) DDR minigame state (see Minigame.get_default_ddr).<br/>
--- * minigame_button_mash (table) Button mash minigame state (see Minigame.get_default_button_mash).<br/>
--- * minigame_rhythm (table) Rhythm minigame state (see Minigame.get_default_rhythm).<br/>
--- * meters (table) Meter values (see Meter.get_initial).<br/>
--- * ascension (table) Ascension meter state (see Ascension.get_initial).<br/>
--- * triggers (table) Active trigger runtime state, keyed by trigger ID.<br/>
--- * stat_screen_active (boolean) Whether the stat screen overlay is currently shown.<br/>
--- * have_met_sumphore (boolean) Whether the player has talked to the homeless guy.<br/>
--- * game (table) Current game progress state. Contains: `current_screen` (string) active screen ID, `current_situation` (string|nil) active situation ID.<br/>
function Context.initial_data()
  return {
    current_menu_item = 1,
    test_mode = false,
    popup = {
      show = false,
      content = {}
    },
    game_in_progress = false,
    stat_screen_active = false,
    minigame_ddr = {},
    minigame_button_mash = {},
    minigame_rhythm = {},
    meters = Meter.get_initial(),
    ascension = Ascension.get_initial(),
    timer = Timer.get_initial(),
    triggers = {},
    home_norman_visible = false,
    have_met_sumphore = false,
    game = {
      current_screen = "home",
      current_situation = nil,
    },
    day_count = 1,
    glitch = {
      enabled = false,
      state = "active",
      timer = 0,
    },
    _end = {
      state = "choice",
      selection = 1,
    },
    discussion = {
      active = false,
      id = nil,
      step = 1,
      selected_answer = 1,
      scroll_y = 0,
      scroll_timer = 0,
      auto_scroll = true,
      return_window = nil,
    },
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
  MysteriousManScreen.start({
    text = [[
      Norman was never a bad
      simulation engineer, but
      we need to be careful in
      letting him improve. We
      need to distract him.
    ]],
    on_text_complete = function()
      Audio.sfx_alarm()
      Context.home_norman_visible = false
      Util.go_to_screen_by_id("home")
      MinigameButtonMashWindow.start("game", {
        focus_center_x = (Config.screen.width / 2) - 22,
        focus_center_y = (Config.screen.height / 2) - 18,
        focus_initial_radius = 0,
        target_points = 100,
        instruction_text = "Wake up Norman!",
        show_progress_text = false,
        on_win = function()
          Audio.music_play_wakingup()
          Context.home_norman_visible = true
          Meter.show()
          Window.set_current("game")
        end,
      })
    end,
  })
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
