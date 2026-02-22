local _available_decisions = {}
local _selected_decision_index = 1

--- Draws the game window.
function GameWindow.draw()
  local screen = Screen.get_by_id(Context.game.current_screen)
  Map.draw(screen.background)
  UI.draw_top_bar(screen.name)
  if #_available_decisions > 0 then
    UI.draw_decision_selector(_available_decisions, _selected_decision_index)
  end
  Sprite.draw()
end

--- Updates the game window logic.
function GameWindow.update()
  if Input.menu_back() then
    Context.current_window = "menu"
    MenuWindow.refresh_menu_items()
    return
  end

  local screen = Screen.get_by_id(Context.game.current_screen)
  screen.update()

  -- Handle situations (Context.game.current_situation is still present)
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
-- @param new_state number The ID of the new active window.
function GameWindow.set_state(new_state)
  Context.current_window = new_state
end
