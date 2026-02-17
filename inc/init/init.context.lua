local SAVE_GAME_BANK = 6
local SAVE_GAME_MAGIC_VALUE_ADDRESS = 0
local SAVE_GAME_MAGIC_VALUE = 0xCA

local SAVE_GAME_CURRENT_SCREEN_ADDRESS = 6

-- Helper for deep copying tables
local function clone_table(t)
  local copy = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      copy[k] = clone_table(v)
    else
      copy[k] = v
    end
  end
  return copy
end

-- This function returns a table containing only the initial *data* for Context
local function get_initial_data()
  return {
    active_window = WINDOW_SPLASH,
    intro = {
      y = Config.screen.height,
      speed = 0.5,
      text = "Norman Reds’ everyday life\nseems ordinary: work,\nmeetings, coffee, and\nendless notifications.\nBut beneath the surface\n— within him, or around\nhim — something is\nconstantly building, and\nit soon becomes clear\nthat there is more going\non than meets the eye."
    },
    current_screen = 1,
    splash_timer = Config.timing.splash_duration,
    popup = { -- New popup table
      show = false,
      content = {} -- Array of strings
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
    selected_desition_index = 1, -- New desition index
    game_in_progress = false, -- New flag
    screens = {} -- Initialize as empty, populated on reset
  }
end

Context = {}

local function reset_context_to_initial_state()
  local initial_data = get_initial_data()

  -- Clear existing data properties from Context (but not methods)
  for k in pairs(Context) do
    if type(Context[k]) ~= "function" then -- Only clear data, leave functions
      Context[k] = nil
    end
  end

  -- Copy all initial data properties into Context
  for k, v in pairs(initial_data) do
    Context[k] = v
  end

  -- Populate Context.screens from ScreenManager, ensuring indexed array
  Context.screens = {}
  Context.screen_indices_by_id = {} -- Renamed for clarity, stores index
  -- The screen order needs to be explicit to ensure consistent numerical indices
  local screen_order = {"home", "toilet", "walking_to_office", "office", "walking_to_home"}
  for i, screen_id in ipairs(screen_order) do
    local screen_data = ScreenManager.get_by_id(screen_id)
    if screen_data then
      table.insert(Context.screens, screen_data)
      Context.screen_indices_by_id[screen_id] = i -- Store index
    else
      -- Handle error if a screen is not registered
      PopupWindow.show({"Error: Screen '" .. screen_id .. "' not registered!"})
    end
  end
end

-- Initially populate Context with data
reset_context_to_initial_state()

-- Now define the methods for Context
function Context.new_game()
  reset_context_to_initial_state()
  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
end

function Context.save_game()
  if not Context.game_in_progress then return end

  mset(SAVE_GAME_MAGIC_VALUE, SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK)
  mset(Context.current_screen, SAVE_GAME_CURRENT_SCREEN_ADDRESS, SAVE_GAME_BANK)
end

function Context.load_game()
  if mget(SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK) ~= SAVE_GAME_MAGIC_VALUE then
    -- No saved game found, start a new one
    Context.new_game()
    return
  end

  reset_context_to_initial_state() -- Reset data, preserve methods

  Context.current_screen = mget(SAVE_GAME_CURRENT_SCREEN_ADDRESS, SAVE_GAME_BANK)

  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
end
