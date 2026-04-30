--- @section AscendDebugWindow
local _level = 0

--- Initialises the ASCEND debug start window.
--- @within AscendDebugWindow
function AscendDebugWindow.init()
  _level = 0
end

--- Draws the ASCEND debug start window.
--- @within AscendDebugWindow
function AscendDebugWindow.draw()
  UI.draw_top_bar("ASCEND Debug Start")

  local cx = Config.screen.width / 2
  local cy = Config.screen.height / 2

  local left_arrow  = _level > 0                        and "<- " or "   "
  local right_arrow = _level < Ascension.get_max_level() and " ->" or "   "
  local label = left_arrow .. "Start at: " .. _level .. right_arrow
  Print.text_center(label, cx, cy - 4, Config.colors.white, false, 1)

  Print.text_center("Z/select: start   X/back: menu", cx, Config.screen.height - 10, Config.colors.dark_grey, false, 1)
end

--- Updates the ASCEND debug start window logic.
--- @within AscendDebugWindow
function AscendDebugWindow.update()
  if Input.left() then
    _level = math.max(0, _level - 1)
  elseif Input.right() then
    _level = math.min(Ascension.get_max_level(), _level + 1)
  elseif Input.select() then
    Audio.sfx_select()
    Context.new_game_debug(_level)
    GameWindow.set_state("game")
  elseif Input.back() then
    Audio.sfx_deselect()
    GameWindow.set_state("menu")
  end
end
