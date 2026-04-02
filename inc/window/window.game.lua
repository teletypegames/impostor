--- @section GameWindow
local _available_decisions = {}
local _selected_decision_index = 1

local function draw_game_scene(underlay_draw)
  local screen = Screen.get_by_id(Context.game.current_screen)
  if not screen then return end
  if screen.background then
    Map.draw(screen.background)
  elseif screen.background_color then
    rect(0, 0, Config.screen.width, Config.screen.height, screen.background_color)
  end
  if underlay_draw then
    underlay_draw()
  end
  if not Context.stat_screen_active and #_available_decisions > 0 then
    Decision.draw(_available_decisions, _selected_decision_index)
  end
  Sprite.draw()
  Focus.draw()
  screen.draw()
end

--- Draws the game window.
--- @within GameWindow
function GameWindow.draw()
  draw_game_scene()
end

--- Draws the game window with a custom underlay.
--- @within GameWindow
--- @param underlay_draw function A draw callback rendered after the background but before overlays.<br/>
function GameWindow.draw_with_underlay(underlay_draw)
  draw_game_scene(underlay_draw)
end

--- Updates the game window logic.
--- @within GameWindow
function GameWindow.update()
  Focus.update()
  if Input.back() then
    Window.set_current("menu")
    MenuWindow.refresh_menu_items()
    return
  end

  local screen = Screen.get_by_id(Context.game.current_screen)
  if not screen or not screen.update then return end
  screen.update()

  if Context.stat_screen_active then return end

  -- Fetch and filter decisions locally
  local all_decisions_for_screen = Decision.get_for_screen(screen)
  _available_decisions = Decision.filter_available(all_decisions_for_screen)

  if #_available_decisions == 0 then return end

  if _selected_decision_index > #_available_decisions then
    _selected_decision_index = 1
  end

  local new_selected_decision_index, mouse_confirmed = Decision.update(
    _available_decisions,
    _selected_decision_index
  )

  if new_selected_decision_index ~= _selected_decision_index then
    _selected_decision_index = new_selected_decision_index
  end

  if Input.select() or mouse_confirmed then
    local selected_decision = _available_decisions[_selected_decision_index]
    if selected_decision and selected_decision.handle then
      Audio.sfx_select()
      selected_decision.handle()
    end
  end


end

--- Sets the active window.
--- @within GameWindow
--- @param new_state string The ID of the new active window.</br>
function GameWindow.set_state(new_state)
  Window.set_current(new_state)
end
