local METER_MAX = 1000
local METER_DEFAULT = 500
local METER_DECAY_PER_FRAME = 0.02
local METER_GAIN_PER_CHORE = 100
local COMBO_BASE_BONUS = 0.02
local COMBO_MAX_BONUS = 0.16
local COMBO_TIMEOUT_FRAMES = 600

Meters.COLOR_ISM = Config.colors.red
Meters.COLOR_WPM = Config.colors.blue
Meters.COLOR_BM = Config.colors.black
Meters.COLOR_BG = Config.colors.meter_bg

function Meters.get_initial()
  return {
    ism = METER_DEFAULT,
    wpm = METER_DEFAULT,
    bm = METER_DEFAULT,
    combo = 0,
    combo_timer = 0,
    hidden = false,
  }
end

function Meters.hide()
  if Context and Context.meters then Context.meters.hidden = true end
end

function Meters.show()
  if Context and Context.meters then Context.meters.hidden = false end
end

function Meters.get_max()
  return METER_MAX
end

function Meters.get_combo_multiplier()
  if not Context or not Context.meters then return 1 end
  local combo = Context.meters.combo
  if combo == 0 then return 1 end
  return 1 + math.min(COMBO_MAX_BONUS, COMBO_BASE_BONUS * (2 ^ (combo - 1)))
end

function Meters.update()
  if not Context or not Context.game_in_progress or not Context.meters then return end
  local m = Context.meters
  m.ism = math.max(0, m.ism - METER_DECAY_PER_FRAME)
  m.wpm = math.max(0, m.wpm - METER_DECAY_PER_FRAME)
  m.bm = math.max(0, m.bm - METER_DECAY_PER_FRAME)
  if m.combo > 0 then
    m.combo_timer = m.combo_timer + 1
    if m.combo_timer >= COMBO_TIMEOUT_FRAMES then
      m.combo = 0
      m.combo_timer = 0
    end
  end
end

function Meters.add(key, amount)
  if not Context or not Context.meters then return end
  local m = Context.meters
  if m[key] ~= nil then
    m[key] = math.min(METER_MAX, m[key] + amount)
  end
end

function Meters.on_minigame_complete()
  local m = Context.meters
  local gain = math.floor(METER_GAIN_PER_CHORE * Meters.get_combo_multiplier())
  Meters.add("wpm", gain)
  Meters.add("ism", gain)
  Meters.add("bm", gain)
  m.combo = m.combo + 1
  m.combo_timer = 0
end
