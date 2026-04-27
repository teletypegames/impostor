--- @section GameOverWindow
local GAME_OVER_ART = [[
_###_ __#__ #___# #####
#____ _#_#_ ##_## #____
#_### ##### #_#_# ####_
#___# #___# #___# #____
_###_ #___# #___# #####

_###_ #___# ##### ####_
#___# #___# #____ #___#
#___# _#_#_ ####_ ####_
#___# __#__ #____ #_#__
_###_ __#__ ##### #__##
]]

local REASON_MESSAGES = {
  ism  = "Your impostor syndrome consumed you.",
  bm   = "You burned out like a cheap candle.",
  days = "100 days passed. The cycle never broke.",
}

--- Shows the game over screen.
--- @within GameOverWindow
--- @param reason string One of "ism", "bm", "days".
function GameOverWindow.show(reason)
  GameOverWindow.reason = reason
  Context.game_in_progress = false
  Glitch.show()
  Window.set_current("game_over")
end

--- Draws the game over screen.
--- @within GameOverWindow
function GameOverWindow.draw()
  cls(Config.colors.black)

  local cx = Config.screen.width / 2
  local bounds = AsciiArt.draw(GAME_OVER_ART, {
    char_w   = 4,
    char_h   = 6,
    line_gap = 1,
    word_gap = 10,
    color    = Config.colors.red,
  })

  local msg = REASON_MESSAGES[GameOverWindow.reason] or ""
  Print.text_center(msg, cx, bounds.bottom + 8, Config.colors.white)
  Print.text_center("Press Z to restart", cx, Config.screen.height - 10, Config.colors.light_grey)
end

--- Updates the game over screen logic.
--- @within GameOverWindow
function GameOverWindow.update()
  if Input.select() then
    Context.reset()
    MenuWindow.refresh_menu_items()
    Window.set_current("menu")
  end
end
