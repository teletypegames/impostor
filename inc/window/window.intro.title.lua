--- @section TitleIntroWindow
TitleIntroWindow.timer = 180 -- 3 seconds at 60fps
TitleIntroWindow.text = [[
##  ### ### ### ### ### ### ### ##  # #
# # #   #    #  # #  #   #  #   # # # #
# # ### ###  #  # #  #   #  ### # #  #
# # #   #    #  # #  #   #  #   # #  #
##  ### #   ### # # ###  #  ### ##   #

    #  # ### ###     ##  #  #
    ## # # #  #     #  # ## #
    # ## # #  #     #### # ##
    #  # # #  #     #  # #  #
    #  # ###  #     #  # #  #

### #   # ### #### ### ### #### ###
 #  ## ## # # #  # #    #  #  # #  #
 #  # # # ### #  # ###  #  #  # ###
 #  #   # #   #  #   #  #  #  # # #
### #   # #   #### ###  #  #### #  #
]]

--- Draws the title intro window.
--- @within TitleIntroWindow
function TitleIntroWindow.draw()
  AsciiArt.draw(TitleIntroWindow.text, {})
end

--- Updates the title intro window logic.
--- @within TitleIntroWindow
function TitleIntroWindow.update()
  TitleIntroWindow.timer = TitleIntroWindow.timer - 1
  if TitleIntroWindow.timer <= 0 or Input.select() or Input.menu_confirm() then
    Window.set_current("intro_ttg")
  end
end
