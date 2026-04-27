--- @section Input
local INPUT_KEY_UP = 0
local INPUT_KEY_DOWN = 1
local INPUT_KEY_LEFT = 2
local INPUT_KEY_RIGHT = 3
local INPUT_KEY_A = 4
local INPUT_KEY_B = 5
local INPUT_KEY_SPACE = 48
local INPUT_KEY_ENTER = 50
local INPUT_KEY_BACKSPACE = 51

--- Checks if Up is pressed.
--- @within Input
function Input.up() return btnp(INPUT_KEY_UP) end
--- Checks if Down is pressed.
--- @within Input
function Input.down() return btnp(INPUT_KEY_DOWN) end
--- Checks if Left is pressed.
--- @within Input
function Input.left() return btnp(INPUT_KEY_LEFT) end
--- Checks if Right is pressed.
--- @within Input
function Input.right() return btnp(INPUT_KEY_RIGHT) end
--- Checks if Select is pressed.
--- @within Input
function Input.select() return btnp(INPUT_KEY_A) or keyp(INPUT_KEY_SPACE) or Mouse.clicked() end
--- Checks if Back is pressed.
--- @within Input
function Input.back() return btnp(INPUT_KEY_B) or keyp(INPUT_KEY_BACKSPACE) end
--- Checks if Enter is pressed.
--- @within Input
function Input.enter() return keyp(INPUT_KEY_ENTER) end
--- Checks if Up is pressed or held (with repeat).
--- @within Input
function Input.up_repeat()   return btnp(INPUT_KEY_UP,   20, 4) end
--- Checks if Down is pressed or held (with repeat).
--- @within Input
function Input.down_repeat() return btnp(INPUT_KEY_DOWN, 20, 4) end
