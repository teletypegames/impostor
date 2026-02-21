local SAVE_GAME_BANK = 6
local SAVE_GAME_MAGIC_VALUE_ADDRESS = 0
local SAVE_GAME_MAGIC_VALUE = 0xCA

local SAVE_GAME_CURRENT_SCREEN_ADDRESS = 6

local function get_initial_data()
  return {
    active_window = WINDOW_SPLASH,
    intro = {
      y = Config.screen.height,
      speed = 0.5,
      text = [[Norman Reds’ everyday life
seems ordinary: work,
meetings, coffee, and
endless notifications.
But beneath the surface
— within him, or around
him — something is
constantly building, and
it soon becomes clear
that there is more going
on than meets the eye.]]
    },
    current_screen = 1,
    splash_timer = Config.timing.splash_duration,
    popup = {
      show = false,
      content = {}
    },
    player = {
      sprite_id = Config.player.sprite_id
    },
    ground = {
      x = 0,
      y = Config.screen.height,
      w = Config.screen.width,
      h = 8
    },
    menu_items = {},
    selected_menu_item = 1,
    selected_decision_index = 1,
    game_in_progress = false,
    screens = {},
    minigame_ddr = Minigames.get_default_ddr(),
    minigame_button_mash = Minigames.get_default_button_mash(),
    minigame_rhythm = Minigames.get_default_rhythm(),
    meters = Meters.get_initial(),
    sprites = {},
    current_situation = nil,
  }
end

Context = {}

local function reset_context_to_initial_state()
  local initial_data = get_initial_data()

  for k in pairs(Context) do
    if type(Context[k]) ~= "function" then       Context[k] = nil
    end
  end

  for k, v in pairs(initial_data) do
    Context[k] = v
  end

  Context.screens = {}
  Context.screen_indices_by_id = {}
  local screen_order = {"home", "toilet", "walking_to_office", "office", "walking_to_home"}
  for i, screen_id in ipairs(screen_order) do
    local screen_data = Screen.get_by_id(screen_id)
    if screen_data then
      table.insert(Context.screens, screen_data)
      Context.screen_indices_by_id[screen_id] = i
    else
      PopupWindow.show({"Error: Screen '" .. screen_id .. "' not registered!"})
    end
  end
end

reset_context_to_initial_state()

function Context.new_game()
  reset_context_to_initial_state()
  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
  Context.screens[Context.current_screen].init()
end

function Context.save_game()
  if not Context.game_in_progress then return end

  mset(SAVE_GAME_MAGIC_VALUE, SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK)
  mset(Context.current_screen, SAVE_GAME_CURRENT_SCREEN_ADDRESS, SAVE_GAME_BANK)
end

function Context.load_game()
  if mget(SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK) ~= SAVE_GAME_MAGIC_VALUE then
        Context.new_game()
    return
  end

  reset_context_to_initial_state()
  Context.current_screen = mget(SAVE_GAME_CURRENT_SCREEN_ADDRESS, SAVE_GAME_BANK)

  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
  Context.screens[Context.current_screen].init()
end
