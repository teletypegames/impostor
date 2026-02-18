function MenuWindow.draw()
  UI.draw_top_bar("Main Menu")
  UI.draw_menu(Context.menu_items, Context.selected_menu_item, 108, 70)
end

function MenuWindow.update()
  Context.selected_menu_item = UI.update_menu(Context.menu_items, Context.selected_menu_item)

  if Input.menu_confirm() then
    local selected_item = Context.menu_items[Context.selected_menu_item]
    if selected_item and selected_item.decision then
      Audio.sfx_select()
      selected_item.decision()
    end
  end
end

function MenuWindow.new_game()
  Context.new_game()   GameWindow.set_state(WINDOW_GAME)
end

function MenuWindow.load_game()
  Context.load_game()   GameWindow.set_state(WINDOW_GAME)
end

function MenuWindow.save_game()
  Context.save_game() end

function MenuWindow.resume_game()
  GameWindow.set_state(WINDOW_GAME)
end

function MenuWindow.exit()
  exit()
end

function MenuWindow.configuration()
  ConfigurationWindow.init()
  GameWindow.set_state(WINDOW_CONFIGURATION)
end

function MenuWindow.audio_test()
  AudioTestWindow.init()
  GameWindow.set_state(WINDOW_AUDIOTEST)
end

function MenuWindow.refresh_menu_items()
  Context.menu_items = {}
  if Context.game_in_progress then
    table.insert(Context.menu_items, {label = "Resume Game", decision = MenuWindow.resume_game})
    table.insert(Context.menu_items, {label = "Save Game", decision = MenuWindow.save_game})
  end

  table.insert(Context.menu_items, {label = "New Game", decision = MenuWindow.new_game})
  table.insert(Context.menu_items, {label = "Load Game", decision = MenuWindow.load_game})
  table.insert(Context.menu_items, {label = "Configuration", decision = MenuWindow.configuration})
  table.insert(Context.menu_items, {label = "Audio Test", decision = MenuWindow.audio_test})
  table.insert(Context.menu_items, {label = "Exit", decision = MenuWindow.exit})

  Context.selected_menu_item = 1 end
