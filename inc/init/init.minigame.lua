-- Manages minigame configurations and initial states.
--- @section Minigame

--- Applies parameters to defaults
--- @within Minigame
--- @param defaults table The default configuration table.
--- @param params table The parameters to apply.
--- @return table The updated configuration table.
local function apply_params(defaults, params)
  if not params then return defaults end
  for k, v in pairs(params) do
    defaults[k] = v
  end
  return defaults
end

--- Gets default DDR minigame configuration.
--- @within Minigame
--- @return result table The default DDR minigame configuration. </br>
--- Fields: </br>
--- * bar_fill (number) Current fill level of the progress bar.<br/>
--- * max_fill (number) Maximum fill value to win.<br/>
--- * fill_per_hit (number) Fill gained per successful hit.<br/>
--- * miss_penalty (number) Fill lost per miss.<br/>
--- * bar_x (number) Progress bar X position.<br/>
--- * bar_y (number) Progress bar Y position.<br/>
--- * bar_width (number) Progress bar width.<br/>
--- * bar_height (number) Progress bar height.<br/>
--- * arrow_size (number) Size of arrow sprites.<br/>
--- * arrow_spawn_timer (number) Timer for arrow spawning.<br/>
--- * arrow_spawn_interval (number) Frames between arrow spawns.<br/>
--- * arrow_fall_speed (number) Speed of falling arrows.<br/>
--- * arrows (table) Array of active arrow objects.<br/>
--- * target_y (number) Y position of the target line.<br/>
--- * target_arrows (table) Array of target arrow positions. Each entry has: `dir` (string) arrow direction, `x` (number) X position.<br/>
--- * hit_threshold (number) Pixel distance for a valid hit.<br/>
--- * button_pressed_timers (table) Per-button press animation timers.<br/>
--- * button_press_duration (number) Duration of button press animation.<br/>
--- * input_cooldowns (table) Per-direction cooldown timers (left, down, up, right).<br/>
--- * input_cooldown_duration (number) Frames of input cooldown.<br/>
--- * frame_counter (number) Global frame counter.<br/>
--- * current_song (table) Currently playing song data.<br/>
--- * pattern_index (number) Current index in song pattern.<br/>
--- * use_pattern (boolean) Whether to use song pattern for spawning.<br/>
--- * return_window (string) Window ID to return to after minigame.
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
    return_window = nil,
    win_timer = 0
  }
end

--- Gets default button mash minigame configuration.
--- @within Minigame
--- @return result table The default button mash minigame configuration. </br>
--- Fields: </br>
--- * bar_fill (number) Current fill level of the progress bar.<br/>
--- * max_fill (number) Maximum fill value to win.<br/>
--- * fill_per_press (number) Fill gained per button press.<br/>
--- * base_degradation (number) Base rate of bar degradation per frame.<br/>
--- * degradation_multiplier (number) Multiplier for degradation scaling.<br/>
--- * button_pressed_timer (number) Button press animation timer.<br/>
--- * button_press_duration (number) Duration of button press animation.<br/>
--- * return_window (string) Window ID to return to after minigame.<br/>
--- * bar_x (number) Progress bar X position.<br/>
--- * bar_y (number) Progress bar Y position.<br/>
--- * bar_width (number) Progress bar width.<br/>
--- * bar_height (number) Progress bar height.<br/>
--- * button_x (number) Button indicator X position.<br/>
--- * button_y (number) Button indicator Y position.<br/>
--- * button_size (number) Button indicator size.<br/>
--- * win_timer (number) Timer for the win message overlay.<br/>
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
    button_size = 12,
    focus_center_x = nil,
    focus_center_y = nil,
    focus_initial_radius = 0,
    win_timer = 0
  }
end

--- Gets default rhythm minigame configuration.
--- @within Minigame
--- @return result table The default rhythm minigame configuration. </br>
--- Fields: </br>
--- * line_position (number) Current position of the moving line (0-1).<br/>
--- * line_speed (number) Speed of the moving line per frame.<br/>
--- * line_direction (number) Direction of line movement (1 or -1).<br/>
--- * target_center (number) Center of the target zone (0-1).<br/>
--- * target_width (number) Current width of the target zone.<br/>
--- * initial_target_width (number) Starting width of the target zone.<br/>
--- * min_target_width (number) Minimum width the target zone can shrink to.<br/>
--- * target_shrink_rate (number) Multiplier applied to target width after each hit.<br/>
--- * score (number) Current score.<br/>
--- * max_score (number) Score needed to win.<br/>
--- * button_pressed_timer (number) Button press animation timer.<br/>
--- * button_press_duration (number) Duration of button press animation.<br/>
--- * return_window (string) Window ID to return to after minigame.<br/>
--- * bar_x (number) Progress bar X position.<br/>
--- * bar_y (number) Progress bar Y position.<br/>
--- * bar_width (number) Progress bar width.<br/>
--- * bar_height (number) Progress bar height.<br/>
--- * button_x (number) Button indicator X position.<br/>
--- * button_y (number) Button indicator Y position.<br/>
--- * button_size (number) Button indicator size.<br/>
--- * press_cooldown (number) Current cooldown timer.<br/>
--- * press_cooldown_duration (number) Frames of press cooldown.<br/>
--- * win_timer (number) Timer for the win message overlay.<br/>
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
    press_cooldown_duration = 15,
    focus_center_x = nil,
    focus_center_y = nil,
    focus_initial_radius = 0,
    win_timer = 0
  }
end

--- Draws a unified win message overlay.
--- @within Minigame
function Minigame.draw_win_overlay()
  local text = "WELL DONE!"
  local tw = #text * 4
  local th = 6
  local padding = 4
  local box_w = tw + padding * 2
  local box_h = th + padding * 2
  local box_x = (Config.screen.width - box_w) / 2
  local box_y = (Config.screen.height - box_h) / 2

  rect(box_x, box_y, box_w, box_h, Config.colors.dark_grey)
  rectb(box_x, box_y, box_w, box_h, Config.colors.white)
  Print.text_center(text, Config.screen.width / 2, box_y + padding, Config.colors.white)
end

--- Configures DDR minigame.
--- @within Minigame
--- @param params table Optional parameters to override defaults (see Minigame.get_default_ddr).
--- @param[opt] params.bar_fill number Current fill level of the progress bar.
--- @param[opt] params.max_fill number Maximum fill value to win.
--- @param[opt] params.fill_per_hit number Fill gained per successful hit.
--- @param[opt] params.miss_penalty number Fill lost per miss.
--- @param[opt] params.bar_x number Progress bar X position.
--- @param[opt] params.bar_y number Progress bar Y position.
--- @param[opt] params.bar_width number Progress bar width.
--- @param[opt] params.bar_height number Progress bar height.
--- @param[opt] params.arrow_size number Size of arrow sprites.
--- @param[opt] params.arrow_spawn_timer number Timer for arrow spawning.
--- @param[opt] params.arrow_spawn_interval number Frames between arrow spawns.
--- @param[opt] params.arrow_fall_speed number Speed of falling arrows.
--- @param[opt] params.arrows table Array of active arrow objects.
--- @param[opt] params.target_y number Y position of the target line.
--- @param[opt] params.target_arrows table Array of target arrow positions with dir and x fields.
--- @param[opt] params.hit_threshold number Pixel distance for a valid hit.
--- @param[opt] params.button_pressed_timers table Per-button press animation timers.
--- @param[opt] params.button_press_duration number Duration of button press animation.
--- @param[opt] params.input_cooldowns table Per-direction cooldown timers (left, down, up, right).
--- @param[opt] params.input_cooldown_duration number Frames of input cooldown.
--- @param[opt] params.frame_counter number Global frame counter.
--- @param[opt] params.current_song table Currently playing song data.
--- @param[opt] params.pattern_index number Current index in song pattern.
--- @param[opt] params.use_pattern boolean Whether to use song pattern for spawning.
--- @param[opt] params.return_window string Window ID to return to after minigame.
--- @return result table The configured DDR minigame state (see Minigame.get_default_ddr for fields).
function Minigame.configure_ddr(params)
  return apply_params(Minigame.get_default_ddr(), params)
end

--- Configures button mash minigame.
--- @within Minigame
--- @param params table Optional parameters to override defaults (see Minigame.get_default_button_mash).
--- @param[opt] params.bar_fill number Current fill level of the progress bar.
--- @param[opt] params.max_fill number Maximum fill value to win.
--- @param[opt] params.fill_per_press number Fill gained per button press.
--- @param[opt] params.base_degradation number Base rate of bar degradation per frame.
--- @param[opt] params.degradation_multiplier number Multiplier for degradation scaling.
--- @param[opt] params.button_pressed_timer number Button press animation timer.
--- @param[opt] params.button_press_duration number Duration of button press animation.
--- @param[opt] params.return_window string Window ID to return to after minigame.
--- @param[opt] params.bar_x number Progress bar X position.
--- @param[opt] params.bar_y number Progress bar Y position.
--- @param[opt] params.bar_width number Progress bar width.
--- @param[opt] params.bar_height number Progress bar height.
--- @param[opt] params.button_x number Button indicator X position.
--- @param[opt] params.button_y number Button indicator Y position.
--- @param[opt] params.button_size number Button indicator size.
--- @return result table The configured button mash minigame state (see Minigame.get_default_button_mash for fields).
function Minigame.configure_button_mash(params)
  return apply_params(Minigame.get_default_button_mash(), params)
end

--- Configures rhythm minigame.
--- @within Minigame
--- @param params table Optional parameters to override defaults (see Minigame.get_default_rhythm).
--- @param[opt] params.line_position number Current position of the moving line (0-1).
--- @param[opt] params.line_speed number Speed of the moving line per frame.
--- @param[opt] params.line_direction number Direction of line movement (1 or -1).
--- @param[opt] params.target_center number Center of the target zone (0-1).
--- @param[opt] params.target_width number Current width of the target zone.
--- @param[opt] params.initial_target_width number Starting width of the target zone.
--- @param[opt] params.min_target_width number Minimum width the target zone can shrink to.
--- @param[opt] params.target_shrink_rate number Multiplier applied to target width after each hit.
--- @param[opt] params.score number Current score.
--- @param[opt] params.max_score number Score needed to win.
--- @param[opt] params.button_pressed_timer number Button press animation timer.
--- @param[opt] params.button_press_duration number Duration of button press animation.
--- @param[opt] params.return_window string Window ID to return to after minigame.
--- @param[opt] params.bar_x number Progress bar X position.
--- @param[opt] params.bar_y number Progress bar Y position.
--- @param[opt] params.bar_width number Progress bar width.
--- @param[opt] params.bar_height number Progress bar height.
--- @param[opt] params.button_x number Button indicator X position.
--- @param[opt] params.button_y number Button indicator Y position.
--- @param[opt] params.button_size number Button indicator size.
--- @param[opt] params.press_cooldown number Current cooldown timer.
--- @param[opt] params.press_cooldown_duration number Frames of press cooldown.
--- @return result table The configured rhythm minigame state (see Minigame.get_default_rhythm for fields).
function Minigame.configure_rhythm(params)
  return apply_params(Minigame.get_default_rhythm(), params)
end
