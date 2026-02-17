local DEFAULT_CONFIG = {
  screen = {
    width = 240,
    height = 136
  },
  colors = {
    black = 0,
    light_grey = 13,
    dark_grey = 14,
    green = 6,
    item = 12 -- yellow
  },
  player = {
    sprite_id = 1
  },
  timing = {
    splash_duration = 120
  }
}

local Config = {
  -- Copy default values initially
  screen = DEFAULT_CONFIG.screen,
  colors = DEFAULT_CONFIG.colors,
  player = DEFAULT_CONFIG.player,
  timing = DEFAULT_CONFIG.timing,
}

local CONFIG_SAVE_BANK = 7
local CONFIG_MAGIC_VALUE_ADDRESS = 2
local CONFIG_SPLASH_DURATION_ADDRESS = 3 -- New address for splash duration
local CONFIG_MAGIC_VALUE = 0xDE -- A magic number to check if config is saved

function Config.save()
  mset(CONFIG_MAGIC_VALUE, CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK) -- Mark as saved
  --mset(Config.timing.splash_duration, CONFIG_SPLASH_DURATION_ADDRESS, CONFIG_SAVE_BANK)
end

function Config.load()
  if mget(CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK) == CONFIG_MAGIC_VALUE then
    -- Config has been saved, load values
    Config.timing.splash_duration = mget(CONFIG_SPLASH_DURATION_ADDRESS, CONFIG_SAVE_BANK)
  else
    -- No saved config, restore defaults
    Config.restore_defaults()
  end
end

function Config.restore_defaults()
  Config.timing.splash_duration = DEFAULT_CONFIG.timing.splash_duration
  -- Any other configurable items should be reset here
end

-- Load configuration on startup
Config.load()
