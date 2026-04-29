--- @section PlayerNameWindow

local _frame       = 0
local _on_confirm  = nil
local MAX_LEN  = 3
local BOX_W    = 24
local BOX_H    = 24
local BOX_GAP  = 12
local BOX_Y    = 50
local WARN_Y   = 104

local function box_start_x()
  return math.floor((Config.screen.width - (MAX_LEN * BOX_W + (MAX_LEN - 1) * BOX_GAP)) / 2)
end

local function box_x(i)
  return box_start_x() + (i - 1) * (BOX_W + BOX_GAP)
end

--- Initialises the player name window.
--- @within PlayerNameWindow
--- @param on_confirm function Called with the entered name when the player saves.
function PlayerNameWindow.init(on_confirm)
  _frame      = 0
  _on_confirm = on_confirm
  TextInput.init(MAX_LEN)
end

local function draw_boxes()
  local cursor = TextInput.get_position()
  local blink  = math.floor(_frame / 18) % 2 == 0

  for i = 1, MAX_LEN do
    local x      = box_x(i)
    local is_cur = (i == cursor)
    local done   = TextInput.is_done()

    local fill   = (is_cur and not done) and Config.colors.blue or Config.colors.black
    local border = (is_cur and not done) and Config.colors.white
                or done                 and Config.colors.light_blue
                or Config.colors.dark_grey

    rect (x, BOX_Y, BOX_W, BOX_H, fill)
    rectb(x, BOX_Y, BOX_W, BOX_H, border)

    local show = not (is_cur and blink and not done)
    if show then
      local ch = TextInput.get_letter(i)
      local cw = print(ch, 0, -100, 0, false, 2)
      local cx = x + math.floor((BOX_W - cw) / 2)
      local cy = BOX_Y + math.floor((BOX_H - 11) / 2)
      local col = (is_cur and not done) and Config.colors.white or Config.colors.light_grey
      print(ch, cx, cy, col, false, 2)
    end
  end

  -- caret arrow below active box
  if not TextInput.is_done() then
    local cx = box_x(cursor) + math.floor(BOX_W / 2)
    local ay = BOX_Y + BOX_H + 4
    line(cx - 4, ay,     cx,     ay + 4, Config.colors.white)
    line(cx + 4, ay,     cx,     ay + 4, Config.colors.white)
  end
end

--- Draws the player name window.
--- @within PlayerNameWindow
function PlayerNameWindow.draw()
  cls(Config.colors.black)

  Print.text_center("Player Name", Config.screen.width / 2, 14, Config.colors.white, false, 2)

  draw_boxes()

  if TextInput.is_done() then
    Print.text_center("Z: save name   B: edit", Config.screen.width / 2, BOX_Y + BOX_H + 12, Config.colors.light_blue)
  else
    Print.text_center("Up/Dn: letter   Lft/Rgt: move   Z: ok", Config.screen.width / 2, BOX_Y + BOX_H + 12, Config.colors.dark_grey)
  end

  -- Warning section
  rect(0, WARN_Y, Config.screen.width, Config.screen.height - WARN_Y, Config.colors.blue)
  rectb(0, WARN_Y, Config.screen.width, Config.screen.height - WARN_Y, Config.colors.light_blue)
  Print.text_center("Remember your name!",              Config.screen.width / 2, WARN_Y + 8,  Config.colors.white)
  Print.text_center("You will need it to load the game.", Config.screen.width / 2, WARN_Y + 20, Config.colors.light_grey)
end

--- Updates player name window logic.
--- @within PlayerNameWindow
function PlayerNameWindow.update()
  _frame = _frame + 1

  if TextInput.is_done() then
    if Input.select() then
      Context.player_name = TextInput.get_name()
      if _on_confirm then _on_confirm() else Window.set_current("menu") end
    elseif Input.back() then
      TextInput.prev_position()
    end
    return
  end

  if Input.up_repeat()   then TextInput.next_letter()   end
  if Input.down_repeat() then TextInput.prev_letter()   end
  if Input.right()       then TextInput.next_position() end
  if Input.select()      then TextInput.select_letter() end

  if Input.left() or Input.back() then
    if TextInput.get_position() > 1 then
      TextInput.prev_position()
    else
      Window.set_current("menu")
    end
  end
end
