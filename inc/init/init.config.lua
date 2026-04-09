Config = {}

--- Return initial data for Config
--- @within Config
function Config.initial_data()
  return {
    screen = {
      width = 240,
      height = 136
    },
    colors = {
      black = 0,
      light_grey = 2,
      dark_grey = 1,
      red = 13,
      light_blue = 9,
      blue = 3,
      white = 4,
      item = 7,
      orange = 7,
      meter_bg = 1
    },
    timing = {
      minigame_win_duration = 180
    }
  }
end

--- Restores default configuration settings.
--- @within Config
function Config.reset()
  local initial = Config.initial_data()
  Config.screen = initial.screen
  Config.colors = initial.colors
  Config.timing = initial.timing
end

local CONFIG_SAVE_BANK = 7
local CONFIG_MAGIC_VALUE_ADDRESS = 2
local CONFIG_MAGIC_VALUE = 0xDE

--- Saves the current configuration.
--- @within Config
function Config.save()
  mset(CONFIG_MAGIC_VALUE, CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK)
end

--- Loads saved configuration.
--- @within Config
function Config.load()
  if mget(CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK) == CONFIG_MAGIC_VALUE then
    return
  else
    Config.reset()
  end
end

Config.load()
