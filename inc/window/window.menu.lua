--- @section MenuWindow
local _menu_items = {}
local _click_timer = 0
local _anim = 0
local _menu_max_w = 0
local ANIM_SPEED = 2.5
local HEADER_H = 28

--- Calculates the animated x position of the menu block.
--- @within MenuWindow
--- @return number x The left edge x coordinate for the menu.
function MenuWindow.calc_menu_x()
  local center_start = Config.screen.width / 2
  local center_end   = Config.screen.width * 0.72
  local center = center_start + _anim * (center_end - center_start)
  return math.floor(center - _menu_max_w / 2)
end

--- Draws the header with title and separator.
--- @within MenuWindow
function MenuWindow.draw_header()
  rect(0, 0, Config.screen.width, HEADER_H, Config.colors.black)
  rect(0, HEADER_H - 2, Config.screen.width, 2, Config.colors.light_blue)

  local cx = Config.screen.width / 2
  local subtitle = "Definitely not an"
  if Context.test_mode then subtitle = subtitle .. "  [TEST]" end
  local sub_w = print(subtitle, 0, -6, 0, false, 1, true)
  print(subtitle, math.floor(cx - sub_w / 2) + 1, 5, Config.colors.dark_grey, false, 1, true)
  print(subtitle, math.floor(cx - sub_w / 2),     4, Config.colors.light_grey, false, 1, true)

  Print.text_center("IMPOSTOR", cx, 12, Config.colors.item, false, 2)
end

--- Draws the 4x scaled Norman sprite on the left side of the screen.
--- @within MenuWindow
function MenuWindow.draw_norman()
  local nx = math.floor(Config.screen.width * 0.45 / 2) - 32
  local ny = HEADER_H + math.floor((Config.screen.height - HEADER_H - 96) / 2)
  spr(272, nx,      ny,      Config.colors.transparent, 4)
  spr(273, nx + 32, ny,      Config.colors.transparent, 4)
  spr(288, nx,      ny + 32, Config.colors.transparent, 4)
  spr(289, nx + 32, ny + 32, Config.colors.transparent, 4)
  spr(304, nx,      ny + 64, Config.colors.transparent, 4)
  spr(305, nx + 32, ny + 64, Config.colors.transparent, 4)
end

--- Draws the menu window.
--- @within MenuWindow
function MenuWindow.draw()
  cls(Config.colors.blue
)
  MenuWindow.draw_header()

  if _anim > 0 then
    MenuWindow.draw_norman()
  end

  local menu_h = #_menu_items * 10
  local y = HEADER_H + math.floor((Config.screen.height - HEADER_H - 10 - menu_h) / 2)
  UI.draw_menu(_menu_items, Context.current_menu_item, MenuWindow.calc_menu_x(), y, false)

  local ttg_text = "TTG"
  local ttg_w = print(ttg_text, 0, -10, 0, false, 1, false)
  Print.text(ttg_text, Config.screen.width - ttg_w - 5, Config.screen.height - 10, Config.colors.light_blue)
end

--- Updates the menu window logic.
--- @within MenuWindow
function MenuWindow.update()
  if _anim < 1 then
    _anim = math.min(1, _anim + ANIM_SPEED * Context.delta_time)
  end

  local menu_h = #_menu_items * 10
  local y = HEADER_H + math.floor((Config.screen.height - HEADER_H - 10 - menu_h) / 2)

  if _click_timer > 0 then
    _click_timer = _click_timer - Context.delta_time
    if _click_timer <= 0 then
      _click_timer = 0
      local selected_item = _menu_items[Context.current_menu_item]
      if selected_item and selected_item.decision then
        selected_item.decision()
      end
    end
    return
  end

  local new_item, mouse_confirmed = UI.update_menu(_menu_items, Context.current_menu_item, MenuWindow.calc_menu_x(), y, false)
  Context.current_menu_item = new_item

  if mouse_confirmed then
    Audio.sfx_select()
    _click_timer = 0.5
  elseif Input.select() then
    local selected_item = _menu_items[Context.current_menu_item]
    if selected_item and selected_item.decision then
      Audio.sfx_select()
      selected_item.decision()
    end
  end
end

--- Opens player name entry then starts a new game.
--- @within MenuWindow
function MenuWindow.new_game()
  PlayerNameWindow.init(function()
    Context.new_game()
  end)
  Window.set_current("player_name")
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

--- Opens the controls screen.
--- @within MenuWindow
function MenuWindow.controls()
  Window.set_current("controls")
end

--- Opens the player name entry screen (test mode shortcut).
--- @within MenuWindow
function MenuWindow.player_name()
  PlayerNameWindow.init()
  Window.set_current("player_name")
end

--- Opens the credits screen.
--- @within MenuWindow
function MenuWindow.credits()
  CreditsWindow.init()
  Window.set_current("credits")
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

--- Opens the end screen for testing.
--- @within MenuWindow
function MenuWindow.end_screen()
  Context._end.state     = "ending"
  Context._end.selection = 1
  GameWindow.set_state("end")
end

--- Opens the DDR minigame test.
--- @within MenuWindow
function MenuWindow.ddr_test()
  AudioTestWindow.init()
  GameWindow.set_state("minigame_ddr")
  MinigameDDRWindow.start("menu", "generated", { special_mode = "only_nothing" })
end

--- Refreshes the list of menu items based on current game state.
--- @within MenuWindow
function MenuWindow.refresh_menu_items()
  _menu_items = {}
  if Context.game_in_progress then
    table.insert(_menu_items, {label = "Resume Game", decision = MenuWindow.resume_game})
    table.insert(_menu_items, {label = "Save Game",   decision = MenuWindow.save_game})
  end

  table.insert(_menu_items, {label = "New Game",  decision = MenuWindow.new_game})
  table.insert(_menu_items, {label = "Controls",  decision = MenuWindow.controls})
  table.insert(_menu_items, {label = "Credits",   decision = MenuWindow.credits})

  if Context.test_mode then
    table.insert(_menu_items, {label = "Audio Test",         decision = MenuWindow.audio_test})
    table.insert(_menu_items, {label = "To Be Continued...", decision = MenuWindow.continued})
    table.insert(_menu_items, {label = "DDR Test",           decision = MenuWindow.ddr_test})
    table.insert(_menu_items, {label = "End Screen",         decision = MenuWindow.end_screen})
    table.insert(_menu_items, {label = "Player Name",        decision = MenuWindow.player_name})
  end

  table.insert(_menu_items, {label = "Exit", decision = MenuWindow.exit})

  _menu_max_w = 0
  for _, item in ipairs(_menu_items) do
    local w = print(item.label, 0, -10, 0, false, 1, false)
    if w > _menu_max_w then _menu_max_w = w end
  end

  Context.current_menu_item = 1
  _click_timer = 0
  _anim = 0
end
