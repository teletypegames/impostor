--- @section Ascension
local ASCENSION_MAX_LEVEL = 9
local ASCENSION_WORD = "ASCENSION"
local _increased_this_cycle = false

local _flash_active = false
local _flash_timer = 0
local _flash_total = 0
local FLASH_DURATION = 120

local _fade_active = false
local _fade_timer = 0
local FADE_DURATION = 120
local FADE_COLORS = nil

--- Gets initial ascension state.
--- @within Ascension
--- @return result table Initial ascension state. </br>
--- Fields: </br>
--- * level (number) Current ascension level (0-9).
function Ascension.get_initial()
  _increased_this_cycle = false
  return {
    level = 0,
  }
end

--- Gets the current ascension level.
--- @within Ascension
--- @return number The current ascension level (0-9).
function Ascension.get_level()
  if not Context or not Context.ascension then return 0 end
  return Context.ascension.level
end

--- Gets the maximum ascension level.
--- @within Ascension
--- @return number The maximum ascension level.
function Ascension.get_max_level()
  return ASCENSION_MAX_LEVEL
end

--- Increases the ascension level by 1, clamped to the max.
--- @within Ascension
function Ascension.increase()
  if not Context or not Context.ascension then return end
  Context.ascension.level = math.min(ASCENSION_MAX_LEVEL, Context.ascension.level + 1)
  _increased_this_cycle = true
end

--- Returns true if ascension was incremented since the last consume call.
--- @within Ascension
--- @return boolean Whether ascension increased this cycle.
function Ascension.did_increase()
  return _increased_this_cycle
end

--- Consumes the increase flag, returning its value and resetting it.
--- @within Ascension
--- @return boolean Whether ascension had increased this cycle.
function Ascension.consume_increase()
  local result = _increased_this_cycle
  _increased_this_cycle = false
  return result
end

--- Returns true when the ascension meter is fully complete (level 10).
--- @within Ascension
--- @return boolean Whether the cycle can be broken.
function Ascension.is_complete()
  return Ascension.get_level() >= ASCENSION_MAX_LEVEL
end

--- Draws the ascension meter as individual letters of "ASCENSION".
--- Each letter lights up per level. Drawn beneath existing meter bars.
--- @within Ascension
--- @param x number Left x position.
--- @param y number Top y position.
--- @param options table Optional overrides: lit_color, dim_color, spacing.
function Ascension.draw(x, y, options)
  if not Context or not Context.ascension then return end
  options = options or {}
  local level = Context.ascension.level
  if level < 1 then return end
  local lit_color = options.lit_color or Config.colors.white
  local spacing = options.spacing or 5

  for i = 1, level do
    local ch = ASCENSION_WORD:sub(i, i)
    local color
    if i == level and _fade_active then
      color = Ascension.get_fade_color()
    else
      color = lit_color
    end
    Print.text_contour(ch, x + (i - 1) * spacing, y, color, false, 1)
  end
end

--- Returns the current fade-in color based on progress through the palette.
--- @within Ascension
--- @return number The palette color index for the current fade step.
function Ascension.get_fade_color()
  if not FADE_COLORS then
    FADE_COLORS = {
      Config.colors.black,
      Config.colors.dark_grey,
      Config.colors.light_grey,
      Config.colors.white,
    }
  end
  if not _fade_active then return Config.colors.white end
  local progress = math.min(_fade_timer / FADE_DURATION, 1)
  local idx = math.floor(progress * (#FADE_COLORS - 1)) + 1
  return FADE_COLORS[idx]
end

--- Starts the fade-in effect for the most recently gained letter.
--- @within Ascension
function Ascension.start_fade()
  _fade_active = true
  _fade_timer = 0
end

--- Starts the ascension flash effect.
--- @within Ascension
function Ascension.start_flash()
  _flash_active = true
  _flash_timer = 0
  _flash_total = FLASH_DURATION
end

--- Updates and draws the ascension flash overlay.
--- Call once per frame from the main loop.
--- @within Ascension
function Ascension.draw_flash()
  if not _flash_active then return end
  _flash_timer = _flash_timer + 1

  local sw = Config.screen.width
  local sh = Config.screen.height

  local progress = _flash_timer / FLASH_DURATION
  local pulse = math.abs(math.sin(progress * math.pi * 6))
  local flash_color = (pulse > 0.5) and Config.colors.white or Config.colors.light_grey
  rect(0, 0, sw, sh, flash_color)

  local cx = math.floor(sw / 2)
  local cy = math.floor(sh / 2)
  Print.text_center("Level Up!", cx, cy - 12, Config.colors.black, false, 2)
  Print.text_center("One step closer to ascension", cx, cy + 6, Config.colors.black, false, 1)

  if _flash_timer >= _flash_total then
    _flash_active = false
    Ascension.start_fade()
  end
end

--- Updates the fade-in timer. Call once per frame from the main loop.
--- @within Ascension
function Ascension.update_fade()
  if not _fade_active then return end
  _fade_timer = _fade_timer + 1
  if _fade_timer >= FADE_DURATION then
    _fade_active = false
  end
end

--- Returns whether a flash effect is currently active.
--- @within Ascension
--- @return boolean Whether the flash is playing.
function Ascension.is_flashing()
  return _flash_active
end

--- Returns whether the fade-in effect is currently active.
--- @within Ascension
--- @return boolean Whether the letter fade-in is playing.
function Ascension.is_fading()
  return _fade_active
end
