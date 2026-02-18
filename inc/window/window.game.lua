function GameWindow.draw()
  local screen = Context.screens[Context.current_screen]
  MapManager.draw(screen.background)
  UI.draw_top_bar(screen.name)
  if screen and screen.decisions and #screen.decisions > 0 then
    local available_desitions = {}
    for _, desition_id in ipairs(screen.decisions) do
      local desition = DesitionManager.get(desition_id)
      if desition and desition.condition() then
        table.insert(available_desitions, desition)
      end
    end
        if #available_desitions > 0 then
      UI.draw_desition_selector(available_desitions, Context.selected_desition_index)
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
    Context.selected_desition_index = 1   elseif Input.down() then
    Context.current_screen = Context.current_screen + 1
    if Context.current_screen > #Context.screens then
      Context.current_screen = 1
    end
    Context.selected_desition_index = 1   end

  local screen = Context.screens[Context.current_screen]
  if screen and screen.decisions and #screen.decisions > 0 then
    local available_desitions = {}
    for _, desition_id in ipairs(screen.decisions) do
      local desition = DesitionManager.get(desition_id)
      if desition and desition.condition() then         table.insert(available_desitions, desition)
      end
    end

        if #available_desitions == 0 then return end

        local new_selected_desition_index = UI.update_desition_selector(
      available_desitions,
      Context.selected_desition_index
    )

        if new_selected_desition_index ~= Context.selected_desition_index then
      Context.selected_desition_index = new_selected_desition_index
    end

        if Input.select() then
      local selected_desition = available_desitions[Context.selected_desition_index]
      if selected_desition and selected_desition.handle then         Audio.sfx_select()         selected_desition.handle()
      end
    end
  end
end

function GameWindow.set_state(new_state)
  Context.active_window = new_state
  end