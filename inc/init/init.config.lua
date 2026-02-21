local DEFAULT_CONFIG = {
  screen = {
    width = 240,
    height = 136
  },
  colors = {
    black = 0,
    light_grey = 13,
    dark_grey = 14,
    red = 2,
    green = 6,
    blue = 9,
    white = 12,
    item = 12,
    meter_bg = 12
  },
  player = {
    sprite_id = 1
  },
  timing = {
    splash_duration = 120
  }
}

-- Game configuration settings.
Config = {
  screen = DEFAULT_CONFIG.screen,
  colors = DEFAULT_CONFIG.colors,
  player = DEFAULT_CONFIG.player,
  timing = DEFAULT_CONFIG.timing,
}

local CONFIG_SAVE_BANK = 7
local CONFIG_MAGIC_VALUE_ADDRESS = 2
local CONFIG_SPLASH_DURATION_ADDRESS = 3
local CONFIG_MAGIC_VALUE = 0xDE

--- Saves the current configuration.
function Config.save()
  mset(CONFIG_MAGIC_VALUE, CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK)
end

--- Loads saved configuration.
function Config.load()
  if mget(CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK) == CONFIG_MAGIC_VALUE then
    Config.timing.splash_duration = mget(CONFIG_SPLASH_DURATION_ADDRESS, CONFIG_SAVE_BANK)
  else
    Config.restore_defaults()
  end
end

--- Restores default configuration settings.
function Config.restore_defaults()
  Config.timing.splash_duration = DEFAULT_CONFIG.timing.splash_duration
end

Config.load()
