local INPUT_KEY_UP = 0
local INPUT_KEY_DOWN = 1
local INPUT_KEY_LEFT = 2
local INPUT_KEY_RIGHT = 3
local INPUT_KEY_A = 4 local INPUT_KEY_B = 5 local INPUT_KEY_Y = 7
local INPUT_KEY_SPACE = 48
local INPUT_KEY_BACKSPACE = 51
local INPUT_KEY_ENTER = 50

function Input.up() return btnp(INPUT_KEY_UP) end
function Input.down() return btnp(INPUT_KEY_DOWN) end
function Input.left() return btnp(INPUT_KEY_LEFT) end
function Input.right() return btnp(INPUT_KEY_RIGHT) end
function Input.select() return btnp(INPUT_KEY_A) or keyp(INPUT_KEY_SPACE) end
function Input.menu_confirm() return btnp(INPUT_KEY_A) or keyp(INPUT_KEY_ENTER) end
function Input.player_interact() return btnp(INPUT_KEY_B) or keyp(INPUT_KEY_ENTER) end function Input.menu_back() return btnp(INPUT_KEY_Y) or keyp(INPUT_KEY_BACKSPACE) end
function Input.toggle_popup() return keyp(INPUT_KEY_ENTER) end
