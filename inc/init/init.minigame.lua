-- Manages minigame configurations and initial states.
--- @section Minigame

--- Applies parameters to defaults
--- @within Minigame
-- @param defaults table The default configuration table.
-- @param params table The parameters to apply.
-- @return table The updated configuration table.
local function apply_params(defaults, params)
  if not params then return defaults end
  for k, v in pairs(params) do
    defaults[k] = v
  end
  return defaults
end

--- Gets default DDR minigame configuration.
--- @within Minigame
-- @return table The default DDR minigame configuration.
function Minigame.get_default_ddr()
  local arrow_size = 12
  local arrow_spacing = 30
  local total_width = (4 * arrow_size) + (3 * arrow_spacing)
  local start_x = (Config.screen.width - total_width) / 2
  return {
    bar_fill = 0,
    max_fill = 100,
    fill_per_hit = 10,
    miss_penalty = 5,
    bar_x = 20,
    bar_y = 10,
    bar_width = 200,
    bar_height = 12,
    arrow_size = arrow_size,
    arrow_spawn_timer = 0,
    arrow_spawn_interval = 45,
    arrow_fall_speed = 1.5,
    arrows = {},
    target_y = 115,
    target_arrows = {
      { dir = "left", x = start_x },
      { dir = "down", x = start_x + arrow_size + arrow_spacing },
      { dir = "up", x = start_x + (arrow_size + arrow_spacing) * 2 },
      { dir = "right", x = start_x + (arrow_size + arrow_spacing) * 3 }
    },
    hit_threshold = 8,
    button_pressed_timers = {},
    button_press_duration = 8,
    input_cooldowns = { left = 0, down = 0, up = 0, right = 0 },
    input_cooldown_duration = 10,
    frame_counter = 0,
    current_song = nil,
    pattern_index = 1,
    use_pattern = false,
    return_window = nil
  }
end

--- Gets default button mash minigame configuration.
--- @within Minigame
-- @return table The default button mash minigame configuration.
function Minigame.get_default_button_mash()
  return {
    bar_fill = 0,
    max_fill = 100,
    fill_per_press = 8,
    base_degradation = 0.15,
    degradation_multiplier = 0.006,
    button_pressed_timer = 0,
    button_press_duration = 8,
    return_window = nil,
    bar_x = 20,
    bar_y = 10,
    bar_width = 200,
    bar_height = 12,
    button_x = 20,
    button_y = 110,
    button_size = 12
  }
end

--- Gets default rhythm minigame configuration.
--- @within Minigame
-- @return table The default rhythm minigame configuration.
function Minigame.get_default_rhythm()
  return {
    line_position = 0,
    line_speed = 0.015,
    line_direction = 1,
    target_center = 0.5,
    target_width = 0.3,
    initial_target_width = 0.3,
    min_target_width = 0.08,
    target_shrink_rate = 0.9,
    score = 0,
    max_score = 10,
    button_pressed_timer = 0,
    button_press_duration = 10,
    return_window = nil,
    bar_x = 20,
    bar_y = 10,
    bar_width = 200,
    bar_height = 12,
    button_x = 210,
    button_y = 110,
    button_size = 10,
    press_cooldown = 0,
    press_cooldown_duration = 15
  }
end

--- Configures DDR minigame.
--- @within Minigame
-- @param params table Optional parameters to override defaults.
-- @return table The configured DDR minigame state.
function Minigame.configure_ddr(params)
  return apply_params(Minigame.get_default_ddr(), params)
end

--- Configures button mash minigame.
--- @within Minigame
-- @param params table Optional parameters to override defaults.
-- @return table The configured button mash minigame state.
function Minigame.configure_button_mash(params)
  return apply_params(Minigame.get_default_button_mash(), params)
end

--- Configures rhythm minigame.
--- @within Minigame
-- @param params table Optional parameters to override defaults.
-- @return table The configured rhythm minigame state.
function Minigame.configure_rhythm(params)
  return apply_params(Minigame.get_default_rhythm(), params)
end
