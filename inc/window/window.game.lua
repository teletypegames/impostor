function GameWindow.draw()
  local currentScreenData = Context.screens[Context.current_screen]

  UI.draw_top_bar(currentScreenData.name)
end

function GameWindow.update()
  if Input.menu_back() then
    Context.active_window = WINDOW_MENU
    MenuWindow.refresh_menu_items()
    return
  end
  if Input.select() then
    if Context.current_screen == #Context.screens then
      Context.current_screen = 1
    else
      Context.current_screen = Context.current_screen + 1
    end
  end

  if Input.player_interact() then
      PopupWindow.show_menu_dialog(npc, {
        {label = "Talk to", action = NPC.talk_to},
        {label = "Fight", action = NPC.fight},
        {label = "Go back", action = NPC.go_back}
      }, WINDOW_POPUP)
  end
end

function GameWindow.set_state(new_state)
  Context.active_window = new_state
  -- Add any state-specific initialization/cleanup here later if needed
end