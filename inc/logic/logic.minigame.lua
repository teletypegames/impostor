-- Manages minigame configurations and initial states.
--- @section Minigame

--- Draws a unified win message overlay.
--- @within Minigame
function Minigame.draw_win_overlay(win_text)
  local text = win_text or "SUCCESS"
  local tw = #text * 6
  local th = 6
  local padding = 4
  local box_w = tw + padding * 2
  local box_h = th + padding * 2
  local box_x = (Config.screen.width - box_w) / 2
  local box_y = (Config.screen.height - box_h) / 2
  local text_x = Config.screen.width / 2
  rect(box_x, box_y, box_w, box_h, Config.colors.dark_grey)
  rectb(box_x, box_y, box_w, box_h, Config.colors.white)
  Print.text_center_contour(text, text_x, box_y + padding, Config.colors.black, false, 1, Config.colors.white)
end

