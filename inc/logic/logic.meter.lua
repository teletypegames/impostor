--- @section Meter
local METER_MAX = 1000
local METER_DEFAULT = 500
local METER_GAIN_PER_CHORE = 100
local METER_DECAY_PER_DAY = 20
local COMBO_BASE_BONUS = 0.02
local COMBO_MAX_BONUS = 0.16
local COMBO_TIMEOUT_FRAMES = 600

-- Internal meters for tracking game progress and player stats.
Meter.COLOR_ISM = Config.colors.orange
Meter.COLOR_WPM = Config.colors.blue
Meter.COLOR_BM = Config.colors.red
Meter.COLOR_BG = Config.colors.meter_bg
Meter.COLOR_CONTOUR = Config.colors.white

--- Gets initial meter values.
--- @within Meter
--- @return result table Initial meter values. </br>
--- Fields: </br>
--- * ism (number) Initial ISM meter value.<br/>
--- * wpm (number) Initial WPM meter value.<br/>
--- * bm (number) Initial BM meter value.<br/>
--- * combo (number) Current combo count.<br/>
--- * combo_timer (number) Frames since last combo action.<br/>
--- * hidden (boolean) Whether meters are hidden.
function Meter.get_initial()
  return {
    ism = METER_DEFAULT,
    wpm = METER_DEFAULT,
    bm = METER_DEFAULT,
    combo = 0,
    combo_timer = 0,
    hidden = false,
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

--- Sets the decay amount applied to all meters per day.
--- @within Meter
--- @param amount number Amount to subtract from each meter.
function Meter.set_decay(amount)
  METER_DECAY_PER_DAY = amount
end

--- Gets the meter decay as a percentage of the max meter value.
--- @within Meter
--- @return number The decay percentage per day.
function Meter.get_decay_percentage()
  return math.floor(METER_DECAY_PER_DAY / METER_MAX * 100)
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

--- Draws meters.
--- @within Meter
function Meter.draw()
  if not Context or not Context.game_in_progress or not Context.meters then return end
  if Context.meters.hidden then return end

  local m = Context.meters
  local max = Meter.get_max()
  local screen_w = Config.screen.width
  local screen_h = Config.screen.height
  local bar_w = screen_w * 0.25
  local bar_h = 2
  local edge = math.max(2, math.floor(screen_w * 0.03))
  local bar_x = screen_w - bar_w - edge
  local line_h = 3
  local start_y = screen_h * 0.05


  local meter_list = {
    { key = "wpm", label = "WPM", color = Meter.COLOR_WPM, row = 0 },
    { key = "ism", label = "ISM", color = Meter.COLOR_ISM, row = 1 },
    { key = "bm", label = "BM", color = Meter.COLOR_BM, row = 2 },
  }

  for _, meter in ipairs(meter_list) do
    local label_y = start_y + meter.row * line_h
    local bar_y = label_y
    local fill_w = math.max(0, math.floor((m[meter.key] / max) * bar_w))
    rect(bar_x - 1, bar_y - 1, bar_w + 2, bar_h + 2, Meter.COLOR_CONTOUR)
    rect(bar_x, bar_y, bar_w, bar_h, Meter.COLOR_BG)
    if fill_w > 0 then
      rect(bar_x, bar_y, fill_w, bar_h, meter.color)
    end
    ---print(meter.label, label_x, label_y, meter.color, false, 1, true)
  end

  local ascension_y = start_y + 3 * line_h + 1
  Ascension.draw(bar_x, ascension_y, { spacing = 8 })
end
