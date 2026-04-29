--- @section Meter
local METER_MAX = 1000
local BM_METER_DEFAULT = 200
local ISM_METER_DEFAULT = 500
local WPM_METER_DEFAULT = 200
local METER_GAIN_PER_CHORE = 100
local METER_DECAY_PER_DAY = 20
local COMBO_BASE_BONUS = 0.02
local COMBO_MAX_BONUS = 0.16
local COMBO_TIMEOUT_FRAMES = 600
local METER_FLASH_DURATION = 2.0
local FLASH_COLOR = 4

-- Internal meters for tracking game progress and player stats.
Meter.COLOR_ISM = Config.colors.orange
Meter.COLOR_WPM = Config.colors.blue
Meter.COLOR_BM = Config.colors.red
Meter.COLOR_BG = Config.colors.meter_bg
Meter.COLOR_CONTOUR = Config.colors.white

local _flash = {
  wpm = { timer = 0, delta = 0 },
  ism = { timer = 0, delta = 0 },
  bm  = { timer = 0, delta = 0 },
}

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
    ism = ISM_METER_DEFAULT,
    wpm = WPM_METER_DEFAULT,
    bm = BM_METER_DEFAULT,
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
  local dt = Context.delta_time or 0
  for _, key in ipairs({ "wpm", "ism", "bm" }) do
    if _flash[key].timer > 0 then
      _flash[key].timer = _flash[key].timer - dt
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
    if amount > 0 and (key == "ism" or key == "bm") and m[key] >= METER_MAX then
      GameOverWindow.show(key)
      return
    end
    local prev_wpm = (key == "wpm") and m.wpm or nil
    local old_val = m[key]
    m[key] = math.max(0, math.min(METER_MAX, m[key] + amount))
    local actual_delta = m[key] - old_val
    if actual_delta ~= 0 and _flash[key] then
      _flash[key].delta = actual_delta
      _flash[key].timer = METER_FLASH_DURATION
    end
    if prev_wpm and prev_wpm > 0 and m.wpm == 0 and Context.game_in_progress
        and Ascension.get_level() == 5 then
      Context.should_ascend = true
    end
  end
end

--- Called on minigame completion.
--- @within Meter
--- @param is_work boolean If true (work-style minigame), apply combo to WPM/ISM/BM and advance combo. DDR uses `Meter.apply_ddr_reward` instead. Otherwise flat equal gain, combo unchanged.
function Meter.on_minigame_complete(is_work)
  local m = Context.meters
  if is_work then
    local mult = Meter.get_combo_multiplier()
    local wpm_delta = math.floor(METER_GAIN_PER_CHORE / mult)
    local ism_bm_delta = math.floor(METER_GAIN_PER_CHORE * mult)
    Meter.add("wpm", wpm_delta)
    Meter.add("ism", ism_bm_delta)
    Meter.add("bm", ism_bm_delta)
    m.combo = m.combo + 1
    m.combo_timer = 0
  else
    local flat = METER_GAIN_PER_CHORE
    Meter.add("wpm", flat)
    Meter.add("ism", flat)
    Meter.add("bm", flat)
  end
end

--- Meter changes after DDR: uses max-meter percentages; combo advances like other work minigames.
--- 0 mistakes: WPM −10%, ISM +5%, BM +5%. 1–3: WPM −5%, ISM +10%, BM +10%. More than 3: WPM unchanged, ISM +10%, BM +10%.
--- @within Meter
--- @param mistake_count number Total mistakes (missed arrows, wrong inputs, and special-mode rule violations).
function Meter.apply_ddr_reward(mistake_count)
  if not Context or not Context.meters then return end
  local max = Meter.get_max()
  local m = Context.meters
  local wpm_pct, ism_pct, bm_pct
  if mistake_count == 0 then
    wpm_pct, ism_pct, bm_pct = -0.10, 0.05, 0.05
  elseif mistake_count <= 3 then
    wpm_pct, ism_pct, bm_pct = -0.05, 0.10, 0.10
  else
    wpm_pct, ism_pct, bm_pct = 0, 0.10, 0.10
  end
  if wpm_pct ~= 0 then
    Meter.add("wpm", math.floor(max * wpm_pct))
  end
  if ism_pct ~= 0 then
    Meter.add("ism", math.floor(max * ism_pct))
  end
  if bm_pct ~= 0 then
    Meter.add("bm", math.floor(max * bm_pct))
  end
  m.combo = m.combo + 1
  m.combo_timer = 0
end

--- Meter changes for the wake-up button mash: faster completion is better for WPM.
--- Perfect: under 2s — WPM +20%. Good: 2–3s — WPM +10%, ISM +5%, BM +5%. Bad: over 3s — WPM −5%, ISM +10%, BM +10%.
--- @within Meter
--- @param elapsed_sec number Seconds from minigame start until the bar was filled.
function Meter.apply_wakeup_reward(elapsed_sec)
  if not Context or not Context.meters then return end
  local max = Meter.get_max()
  local wpm_pct, ism_pct, bm_pct
  if elapsed_sec < 2 then
    wpm_pct, ism_pct, bm_pct = 0.20, 0, 0
  elseif elapsed_sec <= 3 then
    wpm_pct, ism_pct, bm_pct = 0.10, 0.05, 0.05
  else
    wpm_pct, ism_pct, bm_pct = -0.05, 0.10, 0.10
  end
  if wpm_pct ~= 0 then
    Meter.add("wpm", math.floor(max * wpm_pct))
  end
  if ism_pct ~= 0 then
    Meter.add("ism", math.floor(max * ism_pct))
  end
  if bm_pct ~= 0 then
    Meter.add("bm", math.floor(max * bm_pct))
  end
end

--- Random single meter shift after finishing a coworker discussion: ISM +10%, WPM −10%, or BM +10%.
--- @within Meter
function Meter.apply_coworker_discussion_reward()
  if not Context or not Context.meters then return end
  if Context.coworker_discussion_meter_applied_today then return end
  local max = Meter.get_max()
  local delta = math.floor(max * 0.10)
  local roll = math.random(1, 3)
  if roll == 1 then
    Meter.add("ism", delta)
  elseif roll == 2 then
    Meter.add("wpm", -delta)
  else
    Meter.add("bm", delta)
  end
  Context.coworker_discussion_meter_applied_today = true
end

--- After finishing a sumphore discussion: reduce whichever of ISM / WPM / BM is highest by 10% of max (stable tie to ISM, then WPM, then BM).
--- @within Meter
function Meter.apply_sumphore_discussion_reward()
  if not Context or not Context.meters then return end
  if Context.sumphore_discussion_meter_applied_today then return end
  local m = Context.meters
  local max = Meter.get_max()
  local delta = math.floor(max * 0.10)
  local biggest_val_key = "ism"
  local biggest_val = m.ism
  for _, key in ipairs({ "wpm", "bm" }) do
    if m[key] > biggest_val then
      biggest_val = m[key]
      biggest_val_key = key
    end
  end
  Meter.add(biggest_val_key, -delta)
  Context.sumphore_discussion_meter_applied_today = true
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
    local flash = _flash[meter.key]
    if flash and flash.timer > 0 then
      local old_val = m[meter.key] - flash.delta
      local old_fill_w = math.max(0, math.floor((old_val / max) * bar_w))
      local stable_w = math.min(fill_w, old_fill_w)
      if stable_w > 0 then
        rect(bar_x, bar_y, stable_w, bar_h, meter.color)
      end
      if flash.delta > 0 then
        local hi_w = fill_w - stable_w
        if hi_w > 0 then
          rect(bar_x + stable_w, bar_y, hi_w, bar_h, FLASH_COLOR)
        end
      else
        local hi_w = old_fill_w - fill_w
        if hi_w > 0 then
          rect(bar_x + fill_w, bar_y, hi_w, bar_h, FLASH_COLOR)
        end
      end
    elseif fill_w > 0 then
      rect(bar_x, bar_y, fill_w, bar_h, meter.color)
    end
    ---print(meter.label, label_x, label_y, meter.color, false, 1, true)
  end

  local ascension_y = start_y + 3 * line_h + 1
  Ascension.draw(bar_x - 4, ascension_y, { spacing = 8 })
end

--- Draws only the ascension letters at the same position as in Meter.draw().
--- Used when meters are hidden but ascension letters still need to be visible.
--- @within Meter
function Meter.draw_ascension_only()
  local screen_w = Config.screen.width
  local screen_h = Config.screen.height
  local bar_w = screen_w * 0.25
  local edge = math.max(2, math.floor(screen_w * 0.03))
  local bar_x = screen_w - bar_w - edge
  local line_h = 3
  local start_y = screen_h * 0.05
  local ascension_y = start_y + 3 * line_h + 1
  Ascension.draw(bar_x - 4, ascension_y, { spacing = 8 })
end

