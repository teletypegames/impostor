function GameWindow.draw()
  local currentScreenData = Context.screens[Context.current_screen]

  UI.draw_top_bar(currentScreenData.name)
  
  if currentScreenData and currentScreenData.decisions and #currentScreenData.decisions > 0 then
    local available_desitions = {}
    for _, desition_id in ipairs(currentScreenData.decisions) do
      local desition_obj = DesitionManager.get(desition_id)
      if desition_obj and desition_obj.condition() then -- Check condition directly
        table.insert(available_desitions, desition_obj)
      end
    end
    -- If no available desitions, display nothing or a message
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

  -- Handle screen changing using up/down
  if Input.up() then
    Context.current_screen = Context.current_screen - 1
    if Context.current_screen < 1 then
      Context.current_screen = #Context.screens
    end
    Context.selected_desition_index = 1 -- Reset selected decision on screen change
  elseif Input.down() then
    Context.current_screen = Context.current_screen + 1
    if Context.current_screen > #Context.screens then
      Context.current_screen = 1
    end
    Context.selected_desition_index = 1 -- Reset selected decision on screen change
  end

  local currentScreenData = Context.screens[Context.current_screen]
  
  if currentScreenData and currentScreenData.decisions and #currentScreenData.decisions > 0 then
    local available_desitions = {}
    for _, desition_id in ipairs(currentScreenData.decisions) do
      local desition_obj = DesitionManager.get(desition_id)
      if desition_obj and desition_obj.condition() then -- Check condition directly
        table.insert(available_desitions, desition_obj)
      end
    end

    -- If no available desitions, we can't update or execute
    if #available_desitions == 0 then return end

    -- Update selected decision using left/right inputs
    local new_selected_desition_index = UI.update_desition_selector(
      available_desitions,
      Context.selected_desition_index
    )

    -- Only update Context if the selection actually changed to avoid unnecessary re-assignment
    if new_selected_desition_index ~= Context.selected_desition_index then
      Context.selected_desition_index = new_selected_desition_index
    end

    -- Execute selected decision on Input.select()
    if Input.select() then
      local selected_desition = available_desitions[Context.selected_desition_index]
      if selected_desition and selected_desition.handle then -- Call handle directly
        Audio.sfx_select() -- Play sound for selection
        selected_desition.handle()
      end
    end
  end
end

function GameWindow.set_state(new_state)
  Context.active_window = new_state
  -- Add any state-specific initialization/cleanup here later if needed
end
