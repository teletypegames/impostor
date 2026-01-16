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
    npc = 8,
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
local CONFIG_MAGIC_VALUE = 0xDE -- A magic number to check if config is saved

function Config.save()
  -- Save physics settings
  mset(CONFIG_MAGIC_VALUE, CONFIG_MAGIC_VALUE_ADDRESS, CONFIG_SAVE_BANK) -- Mark as saved
end

function Config.load()
  Config.restore_defaults()
  -- Check if config has been saved before using a magic value
end

function Config.restore_defaults()
  -- Any other configurable items should be reset here
end

-- Load configuration on startup
Config.load()
