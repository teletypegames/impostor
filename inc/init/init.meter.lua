--- @section Meter
local METER_MAX = 1000
local METER_DEFAULT = 500
local METER_DECAY_PER_FRAME = 0.02
local METER_GAIN_PER_CHORE = 100
local COMBO_BASE_BONUS = 0.02
local COMBO_MAX_BONUS = 0.16
local COMBO_TIMEOUT_FRAMES = 600

-- 1800 frames = 30 seconds (1800 ÷ 60 = 30)
local meter_timer_duration = 1800
local meter_timer_decay_per_revolution = 20

-- Internal meters for tracking game progress and player stats.
Meter.COLOR_ISM = Config.colors.red
Meter.COLOR_WPM = Config.colors.blue
Meter.COLOR_BM = Config.colors.black
Meter.COLOR_BG = Config.colors.meter_bg

--- Sets the number of frames for one full timer revolution.
--- @within Meter
--- @param frames number Frames per revolution (controls degradation speed).
function Meter.set_timer_duration(frames)
  meter_timer_duration = frames
end

--- Sets the degradation amount applied to all meters per revolution.
--- @within Meter
--- @param amount number Amount to subtract from each meter per revolution.
function Meter.set_timer_decay(amount)
  meter_timer_decay_per_revolution = amount
end

--- Gets initial meter values.
--- @within Meter
--- @return result table A table of initial meter values.
--- @return result.ism number Initial ISM meter value.
--- @return result.wpm number Initial WPM meter value.
--- @return result.bm number Initial BM meter value.
--- @return result.combo number Current combo count.
--- @return result.combo_timer number Frames since last combo action.
--- @return result.hidden boolean Whether meters are hidden.
--- @return result.timer_progress number Clock timer revolution progress (0 to 1).
function Meter.get_initial()
  return {
    ism = METER_DEFAULT,
    wpm = METER_DEFAULT,
    bm = METER_DEFAULT,
    combo = 0,
    combo_timer = 0,
    hidden = false,
    timer_progress = 0,
  }
end

--- Hides meters.
--- @within Meter
function Meter.hide()
  if Context and Context.meters then Context.meters.hidden = true end
end

--- Shows meters.
--- @within Meter
function Meter.show()
  if Context and Context.meters then Context.meters.hidden = false end
end

--- Gets max meter value.
--- @within Meter
--- @return number The maximum meter value.
function Meter.get_max()
  return METER_MAX
end

--- Gets combo multiplier.
--- @within Meter
--- @return number The current combo multiplier.
function Meter.get_combo_multiplier()
  if not Context or not Context.meters then return 1 end
  local combo = Context.meters.combo
  if combo == 0 then return 1 end
  return 1 + math.min(COMBO_MAX_BONUS, COMBO_BASE_BONUS * (2 ^ (combo - 1)))
end

--- Updates all meters.
--- @within Meter
function Meter.update()
  if not Context or not Context.game_in_progress or not Context.meters then return end
  local m = Context.meters
  local in_minigame = string.find(Window.get_current_id(), "^minigame_") ~= nil
  if not in_minigame then
    if m.combo > 0 then
      m.combo_timer = m.combo_timer + 1
      if m.combo_timer >= COMBO_TIMEOUT_FRAMES then
        m.combo = 0
        m.combo_timer = 0
      end
    end
    m.timer_progress = m.timer_progress + (1 / meter_timer_duration)
    if m.timer_progress >= 1 then
      m.timer_progress = m.timer_progress - 1
      m.ism = math.max(0, m.ism - meter_timer_decay_per_revolution)
      m.wpm = math.max(0, m.wpm - meter_timer_decay_per_revolution)
      m.bm = math.max(0, m.bm - meter_timer_decay_per_revolution)
    end
  end
end

--- Adds amount to a meter.
--- @within Meter
--- @param key string The meter key (e.g., "wpm", "ism", "bm").
--- @param amount number The amount to add.
function Meter.add(key, amount)
  if not Context or not Context.meters then return end
  local m = Context.meters
  if m[key] ~= nil then
    m[key] = math.min(METER_MAX, m[key] + amount)
  end
end

--- Gets the timer decay as a percentage of the max meter value.
--- @within Meter
--- @return number The decay percentage per revolution (e.g. 2 means -2%).
function Meter.get_timer_decay_percentage()
  return math.floor(meter_timer_decay_per_revolution / METER_MAX * 100)
end

--- Called on minigame completion.
--- @within Meter
function Meter.on_minigame_complete()
  local m = Context.meters
  local gain = math.floor(METER_GAIN_PER_CHORE * Meter.get_combo_multiplier())
  Meter.add("wpm", gain)
  Meter.add("ism", gain)
  Meter.add("bm", gain)
  m.combo = m.combo + 1
  m.combo_timer = 0
end
