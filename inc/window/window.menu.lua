--- @section MenuWindow
local _menu_items = {}

--- Draws the menu window.
--- @within MenuWindow
function MenuWindow.draw()
  UI.draw_top_bar("Definitely not an Impostor")

  local menu_h = #_menu_items * 10
  local y = 10 + (Config.screen.height - 10 - 10 - menu_h) / 2
  UI.draw_menu(_menu_items, Context.current_menu_item, 0, y, true)

  local ttg_text = "TTG"
  local ttg_w = print(ttg_text, 0, -10, 0, false, 1, false)
  Print.text(ttg_text, Config.screen.width - ttg_w - 5, Config.screen.height - 10, Config.colors.light_blue)
end

--- Updates the menu window logic.
--- @within MenuWindow
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
--- @within MenuWindow
function MenuWindow.new_game()
  Context.new_game()
end

--- Loads a game from the menu.
--- @within MenuWindow
function MenuWindow.load_game()
  Context.load_game()
  GameWindow.set_state("game")
end

--- Saves the current game from the menu.
--- @within MenuWindow
function MenuWindow.save_game()
  Context.save_game()
end

--- Resumes the game from the menu.
--- @within MenuWindow
function MenuWindow.resume_game()
  GameWindow.set_state("game")
end

--- Exits the game.
--- @within MenuWindow
function MenuWindow.exit()
  exit()
end

--- Opens the configuration menu.
--- @within MenuWindow
function MenuWindow.configuration()
  ConfigurationWindow.init()
  GameWindow.set_state("configuration")
end

--- Opens the audio test menu.
--- @within MenuWindow
function MenuWindow.audio_test()
  AudioTestWindow.init()
  GameWindow.set_state("audiotest")
end

--- Opens the continued screen.
--- @within MenuWindow
function MenuWindow.continued()
  ContinuedWindow.timer = 300
  GameWindow.set_state("continued")
end

--- Opens the minigame ddr test menu.
--- @within MenuWindow
function MenuWindow.ddr_test()
  AudioTestWindow.init()
  GameWindow.set_state("minigame_ddr")
  MinigameDDRWindow.start("menu", nil)
end

--- Refreshes menu items.
--- @within MenuWindow
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
  table.insert(_menu_items, {label = "To Be Continued...", decision = MenuWindow.continued})
  table.insert(_menu_items, {label = "DDR Test", decision = MenuWindow.ddr_test})
  table.insert(_menu_items, {label = "Exit", decision = MenuWindow.exit})

  Context.current_menu_item = 1
end
