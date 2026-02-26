--- @section GameWindow
local _available_decisions = {}
local _selected_decision_index = 1

--- Draws the game window.
--- @within GameWindow
function GameWindow.draw()
  local screen = Screen.get_by_id(Context.game.current_screen)
  if screen.background then
    Map.draw(screen.background)
  elseif screen.background_color then
    rect(0, 0, Config.screen.width, Config.screen.height, screen.background_color)
  end
  UI.draw_top_bar(screen.name)
  if #_available_decisions > 0 then
    UI.draw_decision_selector(_available_decisions, _selected_decision_index)
  end
  Sprite.draw()
  Focus.draw()
end

--- Updates the game window logic.
--- @within GameWindow
function GameWindow.update()
  Focus.update()
  if Input.menu_back() then
    Window.set_current("menu")
    MenuWindow.refresh_menu_items()
    return
  end

  local screen = Screen.get_by_id(Context.game.current_screen)
  screen.update()

  -- Handle current situation updates
  if Context.game.current_situation then
    local current_situation_obj = Situation.get_by_id(Context.game.current_situation)
    if current_situation_obj and current_situation_obj.update then
      current_situation_obj.update()
    end
  end

  -- Fetch and filter decisions locally
  local all_decisions_for_screen = Decision.get_for_screen(screen)
  _available_decisions = Decision.filter_available(all_decisions_for_screen)

  if #_available_decisions == 0 then return end

  if _selected_decision_index > #_available_decisions then
    _selected_decision_index = 1
  end

  local new_selected_decision_index = UI.update_decision_selector(
    _available_decisions,
    _selected_decision_index
  )

  if new_selected_decision_index ~= _selected_decision_index then
    _selected_decision_index = new_selected_decision_index
  end

  if Input.select() then
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
