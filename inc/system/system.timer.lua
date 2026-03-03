--- @section Timer

local timer_duration = 1800
local timer_decay_per_revolution = 20

--- Gets initial timer values.
--- @within Timer
--- @return result table Initial timer values. </br>
--- Fields: </br>
--- * progress (number) Clock timer revolution progress (0 to 1).
function Timer.get_initial()
  return {
    progress = 0,
  }
end

--- Sets the number of frames for one full timer revolution.
--- @within Timer
--- @param frames number Frames per revolution.
function Timer.set_duration(frames)
  timer_duration = frames
end

--- Sets the decay amount applied to all meters per revolution.
--- @within Timer
--- @param amount number Amount to subtract from each meter.
function Timer.set_decay(amount)
  timer_decay_per_revolution = amount
end

--- Gets the timer decay as a percentage of the max meter value.
--- @within Timer
--- @return number The decay percentage per revolution.
function Timer.get_decay_percentage()
  return math.floor(timer_decay_per_revolution / Meter.get_max() * 100)
end

--- Updates the timer and handles revolution events.
--- @within Timer
function Timer.update()
  if not Context or not Context.game_in_progress or not Context.meters or not Context.timer then return end
  local m = Context.meters
  local t = Context.timer
  local in_minigame = string.find(Window.get_current_id(), "^minigame_") ~= nil

  if not in_minigame then
    t.progress = t.progress + (1 / timer_duration)
    if t.progress >= 1 then
      Day.increase()
      t.progress = t.progress - 1
      m.ism = math.max(0, m.ism - timer_decay_per_revolution)
      m.wpm = math.max(0, m.wpm - timer_decay_per_revolution)
      m.bm = math.max(0, m.bm - timer_decay_per_revolution)
    end
  end
end

--- Draws the clock timer indicator as a circular progress bar.
--- @within Timer
function Timer.draw()
  if not Context or not Context.game_in_progress or not Context.meters or not Context.timer then return end
  if Context.meters.hidden and not Context.stat_screen_active then return end

  local cx = 10
  local cy = 20
  local r_outer = 5
  local r_inner = 3
  local progress = Context.timer.progress

  local fg_color
  if progress <= 0.25 then
    fg_color = Config.colors.white
  elseif progress <= 0.5 then
    fg_color = Config.colors.light_blue
  elseif progress <= 0.75 then
    fg_color = Config.colors.blue
  elseif progress <= 1 then
    fg_color = Config.colors.red
  end

  local bg_color = Config.colors.dark_grey
  local start_angle = -math.pi * 0.5
  local progress_angle = progress * 2 * math.pi
  local r_outer_sq = r_outer * r_outer
  local r_inner_sq = r_inner * r_inner

  for dy = -r_outer, r_outer do
    for dx = -r_outer, r_outer do
      local dist_sq = dx * dx + dy * dy
      if dist_sq <= r_outer_sq and dist_sq > r_inner_sq then
        local angle = math.atan(dy, dx)
        local relative = angle - start_angle
        if relative < 0 then relative = relative + 2 * math.pi end
        if relative <= progress_angle then
          pix(cx + dx, cy + dy, fg_color)
        else
          pix(cx + dx, cy + dy, bg_color)
        end
      end
    end
  end

  local hand_angle = start_angle + progress_angle
  local hand_x = math.floor(cx + math.cos(hand_angle) * (r_inner - 1) + 0.5)
  local hand_y = math.floor(cy + math.sin(hand_angle) * (r_inner - 1) + 0.5)
  line(cx, cy, hand_x, hand_y, Config.colors.white)
end
