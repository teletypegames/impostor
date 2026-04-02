--- @section Input
local INPUT_KEY_UP = 0
local INPUT_KEY_DOWN = 1
local INPUT_KEY_LEFT = 2
local INPUT_KEY_RIGHT = 3
local INPUT_KEY_Y = 7
local INPUT_KEY_SPACE = 48
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
function Input.select() return btnp(INPUT_KEY_Y) or keyp(INPUT_KEY_SPACE) or Mouse.clicked() end
--- Checks if Back is pressed.
--- @within Input
function Input.back() return keyp(INPUT_KEY_BACKSPACE) end
