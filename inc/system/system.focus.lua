--- @section Focus

local FOCUS_DEFAULT_SPEED = 5

local active = false
local closing = false
local driven = false
local center_x = 0
local center_y = 0
local radius = 0
local speed = FOCUS_DEFAULT_SPEED
local on_complete = nil
local driven_initial_r = 0
local driven_max_r = 0

local function max_radius(cx, cy)
  local dx = math.max(cx, Config.screen.width - cx)
  local dy = math.max(cy, Config.screen.height - cy)
  return math.sqrt(dx * dx + dy * dy)
end

--- Starts a focus overlay that reveals content through an expanding circle.
--- @within Focus
--- @param center_x number The x-coordinate of the circle center.
--- @param center_y number The y-coordinate of the circle center.
--- @param[opt] params table Optional parameters: `speed` (number) expansion rate in pixels/frame, `initial_radius` (number) starting radius in pixels (default 0), `on_complete` (function) callback when overlay disperses.
function Focus.start(cx, cy, params)
  params = params or {}
  active = true
  closing = false
  driven = false
  center_x = cx
  center_y = cy
  radius = params.initial_radius or 0
  speed = params.speed or FOCUS_DEFAULT_SPEED
  on_complete = params.on_complete
end

--- Starts a closing focus overlay that hides content by shrinking the visible circle.
--- @within Focus
--- @param center_x number The x-coordinate of the circle center.
--- @param center_y number The y-coordinate of the circle center.
--- @param[opt] params table Optional parameters: `speed` (number) shrink rate in pixels/frame, `on_complete` (function) callback when screen is fully covered.
function Focus.close(cx, cy, params)
  params = params or {}
  active = true
  closing = true
  driven = false
  center_x = cx
  center_y = cy
  radius = max_radius(cx, cy)
  speed = params.speed or FOCUS_DEFAULT_SPEED
  on_complete = params.on_complete
end

--- Starts a driven focus overlay whose radius is controlled externally via Focus.set_percentage().
--- The radius maps linearly from initial_radius (at 0%) to the screen corner distance (at 100%).
--- @within Focus
--- @param center_x number The x-coordinate of the circle center.
--- @param center_y number The y-coordinate of the circle center.
--- @param[opt] params table Optional parameters: `initial_radius` (number) radius at 0% (default 0).
function Focus.start_driven(cx, cy, params)
  params = params or {}
  active = true
  closing = false
  driven = true
  center_x = cx
  center_y = cy
  driven_initial_r = params.initial_radius or 0
  driven_max_r = max_radius(cx, cy)
  radius = driven_initial_r
  on_complete = nil
end

--- Sets the visible radius as a percentage of the full screen extent.
--- Only has effect when the overlay is in driven mode (started via Focus.start_driven).
--- @within Focus
--- @param pct number A value from 0 to 1 (0 = initial_radius, 1 = full screen).
function Focus.set_percentage(pct)
  if not driven then return end
  radius = driven_initial_r + pct * (driven_max_r - driven_initial_r)
end

--- Checks whether the focus overlay is currently active.
--- @within Focus
--- @return boolean Whether the focus overlay is active.
function Focus.is_active()
  return active
end

--- Stops the focus overlay immediately.
--- @within Focus
function Focus.stop()
  active = false
  closing = false
  driven = false
  radius = 0
  on_complete = nil
end

--- Updates the focus overlay animation. No-op in driven mode.
--- @within Focus
function Focus.update()
  if not active then return end
  if driven then return end

  if closing then
    radius = radius - speed
    if radius <= 0 then
      local cb = on_complete
      Focus.stop()
      if cb then cb() end
    end
  else
    radius = radius + speed
    if radius >= max_radius(center_x, center_y) then
      local cb = on_complete
      Focus.stop()
      if cb then cb() end
    end
  end
end

--- Draws the focus overlay (black screen with circular cutout).
--- Must be called after all other drawing to appear on top of every visual layer.
--- @within Focus
function Focus.draw()
  if not active then return end

  local cx = center_x
  local cy = center_y
  local r = radius
  local w = Config.screen.width
  local h = Config.screen.height
  local color = Config.colors.black

  if closing and r <= 0 then
    rect(0, 0, w, h, color)
    return
  end

  local top = math.max(0, math.floor(cy - r))
  local bottom = math.min(h - 1, math.ceil(cy + r))

  if top > 0 then
    rect(0, 0, w, top, color)
  end

  if bottom < h - 1 then
    rect(0, bottom + 1, w, h - bottom - 1, color)
  end

  for y = top, bottom do
    local dy = y - cy
    local half_w = math.sqrt(math.max(0, r * r - dy * dy))
    local left = math.floor(cx - half_w)
    local right = math.ceil(cx + half_w)

    if left > 0 then
      rect(0, y, left, 1, color)
    end
    if right < w then
      rect(right, y, w - right, 1, color)
    end
  end
end
