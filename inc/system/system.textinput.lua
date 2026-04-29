--- @section TextInput

TextInput = {}

local LETTERS  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local _pos     = {}
local _cursor  = 1
local _max_len = 3

--- Initialises a new text input session.
--- @within TextInput
--- @param max_len number Maximum character count (default 3).
function TextInput.init(max_len)
  _max_len = max_len or 3
  _pos     = {}
  for i = 1, _max_len do _pos[i] = 1 end
  _cursor = 1
end

--- Advances to the next letter at the cursor position (wraps Z→A).
--- @within TextInput
function TextInput.next_letter()
  _pos[_cursor] = (_pos[_cursor] % #LETTERS) + 1
end

--- Goes back to the previous letter at the cursor position (wraps A→Z).
--- @within TextInput
function TextInput.prev_letter()
  _pos[_cursor] = ((_pos[_cursor] - 2) % #LETTERS) + 1
end

--- Confirms the current letter and advances the cursor to the next position.
--- When called on the last position the cursor moves into the done state.
--- @within TextInput
function TextInput.select_letter()
  if _cursor <= _max_len then _cursor = _cursor + 1 end
end

--- Moves the cursor one position to the right (stops at last position).
--- @within TextInput
function TextInput.next_position()
  if _cursor < _max_len then _cursor = _cursor + 1 end
end

--- Moves the cursor one position to the left (stops at first position).
--- Also steps back out of the done state.
--- @within TextInput
function TextInput.prev_position()
  if _cursor > 1 then _cursor = _cursor - 1 end
end

--- Returns the assembled name string.
--- @within TextInput
--- @return string
function TextInput.get_name()
  local s = ""
  for i = 1, _max_len do s = s .. LETTERS:sub(_pos[i], _pos[i]) end
  return s
end

--- Returns the current 1-based cursor position.
--- @within TextInput
--- @return number
function TextInput.get_position()
  return _cursor
end

--- Returns the letter at the given 1-based position.
--- @within TextInput
--- @param i number
--- @return string
function TextInput.get_letter(i)
  return LETTERS:sub(_pos[i], _pos[i])
end

--- Returns true when all positions have been confirmed.
--- @within TextInput
--- @return boolean
function TextInput.is_done()
  return _cursor > _max_len
end
