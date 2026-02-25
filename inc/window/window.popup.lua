--- @section PopupWindow
local POPUP_X = 40
local POPUP_Y = 40
local POPUP_WIDTH = 160
local POPUP_HEIGHT = 80
local TEXT_MARGIN_X = POPUP_X + 10
local TEXT_MARGIN_Y = POPUP_Y + 10
local LINE_HEIGHT = 8

--- Displays a popup window.
--- @within PopupWindow
-- @param content_strings table A table of strings to display in the popup.
function PopupWindow.show(content_strings)
  Context.popup.show = true
  Context.popup.content = content_strings or {}
  GameWindow.set_state("popup")
end

--- Hides the popup window.
--- @within PopupWindow
function PopupWindow.hide()
  Context.popup.show = false
  Context.popup.content = {}
  GameWindow.set_state("game")
end

--- Updates popup window logic.
--- @within PopupWindow
function PopupWindow.update()
  if Context.popup.show then
    if Input.menu_confirm() or Input.menu_back() then
      PopupWindow.hide()
    end
  end
end

--- Draws the popup window.
--- @within PopupWindow
function PopupWindow.draw()
  if Context.popup.show then
    rect(POPUP_X, POPUP_Y, POPUP_WIDTH, POPUP_HEIGHT, Config.colors.black)
    rectb(POPUP_X, POPUP_Y, POPUP_WIDTH, POPUP_HEIGHT, Config.colors.green)

    local current_y = TEXT_MARGIN_Y
    for _, line in ipairs(Context.popup.content) do
      Print.text(line, TEXT_MARGIN_X, current_y, Config.colors.light_grey)
      current_y = current_y + LINE_HEIGHT
    end

    Print.text("[A] Close", TEXT_MARGIN_X, POPUP_Y + POPUP_HEIGHT - LINE_HEIGHT - 2, Config.colors.green)
  end
end
