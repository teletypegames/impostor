Actions = {}

function Actions.start_dialog(dialog_data, active_entity_name, start_node)
  -- This function will handle initiating a dialog.
  -- It needs access to the full dialog structure, the entity that owns it (for display), and the starting node.
  -- The active_entity_name is just for display purposes; the full dialog_data should contain all nodes.
  
  -- Create a dummy entity for PopupWindow.show_menu_dialog (which expects an entity)
  local dummy_entity = { name = active_entity_name, dialog = dialog_data }
  
  -- This is a temporary solution. The final refactor will remove show_menu_dialog.
  -- For now, we'll mimic the old behavior as much as possible for dialogs.
  Context.dialog.active_entity = dummy_entity
  PopupWindow.set_dialog_node(start_node)
end

function Actions.start_minigame_mash()
  MinigameButtonMashWindow.start(WINDOW_GAME)
end

function Actions.start_minigame_rhythm()
  MinigameRhythmWindow.start(WINDOW_GAME)
end

function Actions.start_minigame_ddr(song_key)
  MinigameDDRWindow.start(WINDOW_GAME, song_key)
end

function Actions.examine_item(item_data)
  PopupWindow.show_description_dialog(item_data, item_data.desc)
end