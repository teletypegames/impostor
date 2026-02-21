function GameWindow.draw()
  local screen = Context.screens[Context.current_screen]
  Map.draw(screen.background)
  UI.draw_top_bar(screen.name)
  if screen and screen.decisions and #screen.decisions > 0 then
    local available_decisions = {}
    for _, decision_id in ipairs(screen.decisions) do
      local decision = Decision.get(decision_id)
      if decision and decision.condition() then
        table.insert(available_decisions, decision)
      end
    end
        if #available_decisions > 0 then
      UI.draw_decision_selector(available_decisions, Context.selected_decision_index)
    end
  end
end

function GameWindow.update()
  if Input.menu_back() then
    Context.active_window = WINDOW_MENU
    MenuWindow.refresh_menu_items()
    return
  end

    if Input.up() then
    Context.current_screen = Context.current_screen - 1
    if Context.current_screen < 1 then
      Context.current_screen = #Context.screens
    end
    Context.selected_decision_index = 1   elseif Input.down() then
    Context.current_screen = Context.current_screen + 1
    if Context.current_screen > #Context.screens then
      Context.current_screen = 1
    end
    Context.selected_decision_index = 1   end

  local screen = Context.screens[Context.current_screen]
  if screen and screen.decisions and #screen.decisions > 0 then
    local available_decisions = {}
    for _, decision_id in ipairs(screen.decisions) do
      local decision = Decision.get(decision_id)
      if decision and decision.condition() then         table.insert(available_decisions, decision)
      end
    end

        if #available_decisions == 0 then return end

        local new_selected_decision_index = UI.update_decision_selector(
      available_decisions,
      Context.selected_decision_index
    )

        if new_selected_decision_index ~= Context.selected_decision_index then
      Context.selected_decision_index = new_selected_decision_index
    end

        if Input.select() then
      local selected_decision = available_decisions[Context.selected_decision_index]
      if selected_decision and selected_decision.handle then         Audio.sfx_select()         selected_decision.handle()
      end
    end
  end
end

function GameWindow.set_state(new_state)
  Context.active_window = new_state
  end