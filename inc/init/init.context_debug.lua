-- Debug helper: start the game at a specific ascension level.
-- Set enabled = true and asc_level = 0..Ascension.get_max_level() before launching.
ContextDebug = {
  enabled   = false,
  asc_level = 0,
}

local _level_overrides = {
  [0] = {
    day_count            = 1,
    home_norman_visible  = true,
    have_been_to_office  = false,
    have_done_work_today = false,
    have_met_sumphore    = false,
  },
}
for i = 1, Ascension.get_max_level() do
  _level_overrides[i] = {
    day_count            = i + 3,
    home_norman_visible  = true,
    have_been_to_office  = false,
    have_done_work_today = false,
    have_met_sumphore    = true,
  }
end

--- Returns Context.initial_data() overridden for the given ascension level.
--- @within Context
--- @param level number Target ascension level (0..Ascension.get_max_level()).
--- @return table Debug-patched initial context data.
function Context.initial_data_debug_asc(level)
  local data = Context.initial_data()
  data.test_mode        = true
  data.game_in_progress = true
  data.ascension        = { level = level }
  local overrides = _level_overrides[level] or _level_overrides[0]
  for k, v in pairs(overrides) do
    data[k] = v
  end
  return data
end

for i = 0, Ascension.get_max_level() do
  Context["initial_data_debug_asc_" .. i] = function()
    return Context.initial_data_debug_asc(i)
  end
end

--- Starts the game at the given ascension level (defaults to ContextDebug.asc_level).
--- Wire this to a key or call it directly; do not use Context.new_game() when debugging.
--- @within Context
--- @param level number|nil Target ascension level.
function Context.new_game_debug(level)
  ContextDebug.enabled   = true
  ContextDebug.asc_level = level or ContextDebug.asc_level

  local data = Context["initial_data_debug_asc_" .. ContextDebug.asc_level]()
  for k in pairs(Context) do
    if type(Context[k]) ~= "function" then Context[k] = nil end
  end
  for k, v in pairs(data) do Context[k] = v end

  MenuWindow.refresh_menu_items()
  Screen.get_by_id(Context.game.current_screen).init()
end
