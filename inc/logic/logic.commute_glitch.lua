--- @section CommuteGlitch
CommuteGlitch = {}

--- Gets the current commute glitch level.
--- @within CommuteGlitch
--- @return number Current glitch level (0-7).
function CommuteGlitch.get_level()
  return Context and (Context.commute_glitch_level or 0) or 0
end

--- Increments the glitch counter. Called on each office screen init at asc level 7.
--- Caps at 6; use enter_truth() to reach 7.
--- @within CommuteGlitch
function CommuteGlitch.increment()
  if not Context then return end
  if Context.commute_glitch_level >= 7 then return end
  Context.commute_glitch_level = math.min(6, (Context.commute_glitch_level or 0) + 1)
end

--- Resets the glitch counter and hides the glitch overlay. Called when going home.
--- @within CommuteGlitch
function CommuteGlitch.reset()
  if not Context then return end
  Context.commute_glitch_level = 0
  Glitch.hide()
end

--- Jumps to glitch level 7 (full corruption). Called by go_to_truth.
--- @within CommuteGlitch
function CommuteGlitch.enter_truth()
  if not Context then return end
  Context.commute_glitch_level = 7
  Glitch.show()
  Ascension.start_flash()
end

--- Returns true when ascension level is 7 (ASCENSIO step active).
--- @within CommuteGlitch
--- @return boolean Whether the commute glitch system is active.
function CommuteGlitch.is_active()
  return Ascension.get_level() == 7
end

--- Returns the music playback speed for the current glitch level.
--- TIC-80 default speed is 6; each step past 1 adds 2.
--- @within CommuteGlitch
--- @return number Speed value for music().
function CommuteGlitch.music_speed()
  local level = CommuteGlitch.get_level()
  if level <= 1 then return 6 end
  return 6 + (level - 1) * 2
end

--- Returns a corrupted copy of a sprite drawable list.
--- Applies flip_y and norman_echo id replacements based on glitch level.
--- Entries marked norman_echo should be drawn via draw_sprite_list for palette change handling.
--- @within CommuteGlitch
--- @param list table Drawable sprite list from Sprite.list_randomize.
--- @return table Corrupted copy of the list.
function CommuteGlitch.corrupt_sprite_list(list)
  local level = CommuteGlitch.get_level()
  if level < 3 or not list then return list end
  local result = {}
  for i, entry in ipairs(list) do
    local e = {}
    for k, v in pairs(entry) do e[k] = v end
    if level >= 7 then
      e.id = "norman_echo"
    else
      local n_flip = (level >= 5) and 2 or 1
      local n_echo = (level >= 5) and 2 or (level >= 4) and 1 or 0
      if i <= n_flip then e.flip_y = 1 end
      if i > n_flip and i <= n_flip + n_echo then e.id = "norman_echo" end
    end
    table.insert(result, e)
  end
  return result
end

-- Palette indices for Norman echo color remap.
-- Implementer: pick ECHO_SRC as one of Norman's main body colors and ECHO_DST
-- as a contrasting or wrong palette color by inspecting the sprite sheet.
local ECHO_SRC = 4
local ECHO_DST = 14

-- Base nibble address of the PALETTE MAP in VRAM.
local PALETTE_MAP_ADDR = 0x03FF0 * 2

--- Draws a sprite list, applying a PALETTE MAP remap for norman_echo entries.
--- Uses poke4 to remap ECHO_SRC → ECHO_DST before drawing echoes, then restores.
--- @within CommuteGlitch
--- @param list table Drawable sprite list (may contain mixed normal and echo entries).
function CommuteGlitch.draw_sprite_list(list)
  if not list then return end
  local normal, echo = {}, {}
  for _, entry in ipairs(list) do
    if entry.id == "norman_echo" then
      table.insert(echo, entry)
    else
      table.insert(normal, entry)
    end
  end
  if #normal > 0 then
    Sprite.draw_list(normal)
  end
  if #echo > 0 then
    poke4(PALETTE_MAP_ADDR + ECHO_SRC, ECHO_DST)
    Sprite.draw_list(echo)
    poke4(PALETTE_MAP_ADDR + ECHO_SRC, ECHO_SRC)
  end
end

local _flicker_tick = 0

--- Draws a random tile-flicker effect over the background (glitch level 7).
--- Every 3 frames draws 6 random 8x8 rects in random palette colors.
--- @within CommuteGlitch
function CommuteGlitch.draw_background_flicker()
  _flicker_tick = (_flicker_tick + 1) % 3
  if _flicker_tick ~= 0 then return end
  for _ = 1, 6 do
    local tx = math.random(0, math.floor(Config.screen.width  / 8) - 1) * 8
    local ty = math.random(0, math.floor(Config.screen.height / 8) - 1) * 8
    local color = math.random(0, 15)
    rect(tx, ty, 8, 8, color)
  end
end
