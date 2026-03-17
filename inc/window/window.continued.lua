--- @section ContinuedWindow
ContinuedWindow.timer = 300 -- 5 seconds at 60fps
ContinuedWindow.text = [[
### ###     ### ###
 #  # #     # # #
 #  # #     ### ##
 #  # #     # # #
 #  ###     ### ###

### ### #  # ### ### #  # # # ### ##
#   # # ## #  #   #  ## # # # #   # #
#   # # # ##  #   #  # ## # # ##  # #
#   # # #  #  #   #  #  # # # #   # #
### ### #  #  #  ### #  # ### ### ##

]]

--- Draws the continued window.
--- @within ContinuedWindow
function ContinuedWindow.draw()
  cls(Config.colors.black)
  AsciiArt.draw(ContinuedWindow.text, {})
end

--- Updates the continued window logic.
--- @within ContinuedWindow
function ContinuedWindow.update()
  ContinuedWindow.timer = ContinuedWindow.timer - 1
  if ContinuedWindow.timer <= 0 or Input.select() or Input.menu_confirm() then
    Window.set_current("menu")
    MenuWindow.refresh_menu_items()
  end
end
