--- @section Mouse
local _mx, _my = 0, 0
local _mleft, _mleft_prev = false, false
local _consumed = false

--- Updates mouse state. Call once per frame.
--- @within Mouse
function Mouse.update()
  _mleft_prev = _mleft
  _consumed = false
  local mt = {mouse()}
  _mx, _my, _mleft = mt[1], mt[2], mt[3]
end

--- Returns current mouse X position.
--- @within Mouse
function Mouse.x() return _mx end

--- Returns current mouse Y position.
--- @within Mouse
function Mouse.y() return _my end

--- Returns true if the mouse button was just pressed this frame (and not yet consumed).
--- @within Mouse
function Mouse.clicked() return _mleft and not _mleft_prev and not _consumed end

--- Returns true if the mouse button is held down.
--- @within Mouse
function Mouse.held() return _mleft end

--- Marks the current click as consumed so Mouse.clicked() won't fire again this frame.
--- @within Mouse
function Mouse.consume() _consumed = true end

--- Returns true if the mouse is within the given rectangle.
--- @within Mouse
--- @param x number Left edge.
--- @param y number Top edge.
--- @param w number Width.
--- @param h number Height.
function Mouse.in_rect(x, y, w, h)
  return _mx >= x and _mx < x + w and _my >= y and _my < y + h
end
