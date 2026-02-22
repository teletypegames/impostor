local _menu_items = {}

--- Draws the menu window.
function MenuWindow.draw()
  UI.draw_top_bar("Main Menu")
  UI.draw_menu(_menu_items, Context.current_menu_item, 108, 70)
end

--- Updates the menu window logic.
function MenuWindow.update()
  Context.current_menu_item = UI.update_menu(_menu_items, Context.current_menu_item)

  if Input.menu_confirm() then
    local selected_item = _menu_items[Context.current_menu_item]
    if selected_item and selected_item.decision then
      Audio.sfx_select()
      selected_item.decision()
    end
  end
end

--- Starts a new game from the menu.
function MenuWindow.new_game()
  Context.new_game()   GameWindow.set_state("game")
end

--- Loads a game from the menu.
function MenuWindow.load_game()
  Context.load_game()   GameWindow.set_state("game")
end

--- Saves the current game from the menu.
function MenuWindow.save_game()
  Context.save_game() end

--- Resumes the game from the menu.
function MenuWindow.resume_game()
  GameWindow.set_state("game")
end

--- Exits the game.
function MenuWindow.exit()
  exit()
end

--- Opens the configuration menu.
function MenuWindow.configuration()
  ConfigurationWindow.init()
  GameWindow.set_state("configuration")
end

--- Opens the audio test menu.
function MenuWindow.audio_test()
  AudioTestWindow.init()
  GameWindow.set_state("audiotest")
end

--- Refreshes menu items.
function MenuWindow.refresh_menu_items()
  _menu_items = {}
  if Context.game_in_progress then
    table.insert(_menu_items, {label = "Resume Game", decision = MenuWindow.resume_game})
    table.insert(_menu_items, {label = "Save Game", decision = MenuWindow.save_game})
  end

  table.insert(_menu_items, {label = "New Game", decision = MenuWindow.new_game})
  table.insert(_menu_items, {label = "Load Game", decision = MenuWindow.load_game})
  table.insert(_menu_items, {label = "Configuration", decision = MenuWindow.configuration})
  table.insert(_menu_items, {label = "Audio Test", decision = MenuWindow.audio_test})
  table.insert(_menu_items, {label = "Exit", decision = MenuWindow.exit})

  Context.current_menu_item = 1
end
