-- Simplified PopupWindow module
local POPUP_X = 40
local POPUP_Y = 40
local POPUP_WIDTH = 160
local POPUP_HEIGHT = 80
local TEXT_MARGIN_X = POPUP_X + 10
local TEXT_MARGIN_Y = POPUP_Y + 10
local LINE_HEIGHT = 8 -- Assuming 8 pixels per line for default font

function PopupWindow.show(content_strings)
  Context.popup.show = true
  Context.popup.content = content_strings or {} -- Ensure it's a table
  GameWindow.set_state(WINDOW_POPUP) -- Set active window to popup
end

function PopupWindow.hide()
  Context.popup.show = false
  Context.popup.content = {} -- Clear content
  GameWindow.set_state(WINDOW_GAME) -- Return to game window
end

function PopupWindow.update()
  if Context.popup.show then
    if Input.menu_confirm() or Input.menu_back() then -- Allow either A or B to close
      PopupWindow.hide()
    end
  end
end

function PopupWindow.draw()
  if Context.popup.show then
    rect(POPUP_X, POPUP_Y, POPUP_WIDTH, POPUP_HEIGHT, Config.colors.black)
    rectb(POPUP_X, POPUP_Y, POPUP_WIDTH, POPUP_HEIGHT, Config.colors.green)

    local current_y = TEXT_MARGIN_Y
    for _, line in ipairs(Context.popup.content) do
      Print.text(line, TEXT_MARGIN_X, current_y, Config.colors.light_grey)
      current_y = current_y + LINE_HEIGHT
    end

    -- Instruction to close
    Print.text("[A] Close", TEXT_MARGIN_X, POPUP_Y + POPUP_HEIGHT - LINE_HEIGHT - 2, Config.colors.green)
  end
end
