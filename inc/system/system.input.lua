local INPUT_KEY_UP = 0
local INPUT_KEY_DOWN = 1
local INPUT_KEY_LEFT = 2
local INPUT_KEY_RIGHT = 3
local INPUT_KEY_A = 4 local INPUT_KEY_B = 5 local INPUT_KEY_Y = 7
local INPUT_KEY_SPACE = 48
local INPUT_KEY_BACKSPACE = 51
local INPUT_KEY_ENTER = 50

--- Checks if Up is pressed.
function Input.up() return btnp(INPUT_KEY_UP) end
--- Checks if Down is pressed.
function Input.down() return btnp(INPUT_KEY_DOWN) end
--- Checks if Left is pressed.
function Input.left() return btnp(INPUT_KEY_LEFT) end
--- Checks if Right is pressed.
function Input.right() return btnp(INPUT_KEY_RIGHT) end
--- Checks if Select is pressed.
function Input.select() return btnp(INPUT_KEY_A) or keyp(INPUT_KEY_SPACE) end
--- Checks if Menu Confirm is pressed.
function Input.menu_confirm() return btnp(INPUT_KEY_A) or keyp(INPUT_KEY_ENTER) end
--- Checks if Player Interact is pressed.
function Input.player_interact() return btnp(INPUT_KEY_B) or keyp(INPUT_KEY_ENTER) end
--- Checks if Menu Back is pressed.
function Input.menu_back() return btnp(INPUT_KEY_Y) or keyp(INPUT_KEY_BACKSPACE) end
--- Checks if Toggle Popup is pressed.
function Input.toggle_popup() return keyp(INPUT_KEY_ENTER) end
