--- @section MinigameDDRWindow

--- Background drawing for DDR minigame.
--- @witin MinigameDDRWindow
function MinigameDDRWindow.draw_background()
  local img_values = {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1}
  local img_runs = {213,27,213,27,212,28,212,28,211,29,212,28,212,28,212,28,211,29,211,29,126,16,69,29,136,9,66,29,210,30,80,1,129,30,80,1,78,1,51,29,80,1,78,1,51,29,80,2,77,1,51,28,81,2,76,2,51,28,81,2,76,2,50,29,81,2,76,2,51,28,81,2,76,2,50,29,81,2,76,2,50,28,82,2,75,3,50,28,81,4,74,3,50,28,81,4,74,3,51,27,81,4,74,3,50,27,82,4,74,3,50,27,82,4,74,3,51,26,82,4,73,4,50,27,82,4,73,4,51,25,83,4,73,4,50,26,83,4,2,2,69,4,50,26,83,5,1,2,27,7,35,4,50,26,83,9,23,13,28,1,3,4,50,26,83,9,5,2,15,15,27,2,2,4,50,25,84,9,3,5,14,16,26,3,1,4,51,24,84,9,3,6,13,16,26,8,51,24,85,8,3,5,15,14,27,8,50,25,85,8,26,9,29,8,50,25,85,8,63,9,51,23,86,8,63,9,51,23,86,8,63,9,51,23,86,8,12,3,13,5,30,9,51,23,86,8,12,3,12,7,29,8,52,22,87,8,28,5,30,8,53,21,87,8,63,8,52,22,87,8,63,8,52,22,87,8,62,9,52,21,88,8,62,9,52,21,88,8,62,9,52,21,88,8,62,9,52,21,88,8,62,9,51,22,88,8,62,9,51,21,89,8,62,9,52,20,89,8,62,9,52,20,89,8,62,9,52,20,89,8,62,9,52,20,89,8,62,9,52,19,90,9,61,9,53,18,90,9,61,9,53,18,90,9,61,8,53,19,90,9,61,8,53,18,91,9,61,8,53,18,91,9,60,9,52,19,91,10,59,9,52,19,91,10,59,9,51,20,91,16,1,2,48,11,51,19,93,77,51,19,93,77,52,18,93,77,51,19,93,77,51,19,93,77,50,19,94,76,51,19,94,12,1,63,51,19,94,75,52,19,94,4,12,46,2,9,54,19,94,2,33,24,68,19,220,20,220,19,220,20,220,20,220,20,89,6,125,19,88,9,76,4,43,20,87,11,74,6,42,20,86,12,73,8,39,22,86,69,15,10,37,23,85,82,3,11,36,22,85,98,35,22,84,100,33,23,83,102,31,24,82,104,29,25,81,106,27,26,80,108,26,25,80,110,25,25,79,112,24,25,78,113,24,25,77,115,23,25,77,116,22,24,78,2,11,104,20,25,78,1,65,51,20,25,78,1,115,1,21,23,79,1,115,1,21,23,79,1,115,1,20,24,79,1,115,1,20,24,79,1,115,1,20,24,79,1,74,10,6,1,24,1,21,22,80,1,75,9,4,7,20,1,21,22,80,1,75,9,4,7,20,1,20,23,80,1,76,8,4,7,20,1,21,22,80,1,115,1,22,20,81,1,115,1,23,19,197,1,24,18,197,1,25,17,223,17,224,16,226,13,228,12,228,12,229,11,81,4,145,9,80,9,137,3,3,8,73,3,8,122,21,3,3,7,72,3,129,4,19,4,3,6,71,3,131,4,19,4,3,5,71,2,13,8,5,8,99,4,18,5,4,2,71,3,11,10,5,8,100,3,17,7,4,1,71,2,8,30,97,4,16,8,74,3,136,4,14,10,72,3,138,3,14,11,71,3,10,3,9,3,3,3,3,3,4,2,95,4,13,12,69,3,10,4,8,4,3,3,3,3,3,3,7,4,2,4,2,4,2,4,6,4,2,4,2,4,2,4,2,4,5,4,2,4,2,4,2,4,6,3,12,13,69,2,10,5,8,4,2,4,2,4,3,3,7,4,2,4,2,4,2,4,6,4,2,4,2,4,2,4,2,4,5,4,2,4,2,4,2,4,6,4,11,13,68,3,10,5,1,2,5,4,3,3,2,4,3,3,7,4,2,3,3,4,2,4,6,4,2,4,2,4,2,4,2,4,5,4,2,5,1,4,3,3,7,4,10,13,68,2,11,5,1,2,20,1,5,1,7,3,5,1,6,1,2,1,1,1,9,2,3,3,3,3,3,3,2,1,1,2,6,3,4,2,3,3,5,1,7,4,9,13,68,3,10,6,1,2,33,2,1,1,3,1,4,3,2,9,4,3,3,3,3,3,2,5,1,5,6,2,4,3,4,3,2,3,7,4,8,13,67,3,13,4,3,2,19,1,5,1,5,1,4,3,4,2,4,3,3,2,4,3,3,3,3,3,2,5,2,4,6,3,3,3,4,3,3,2,8,4,7,13,67,3,13,4,17,1,11,2,5,1,4,3,4,2,4,2,4,2,4,3,3,3,4,2,3,4,2,4,6,3,4,3,3,3,3,3,7,4,7,13,66,3,14,4,29,1,12,1,4,1,1,1,4,2,4,2,4,2,4,3,4,3,2,4,2,4,6,3,4,2,4,3,3,3,8,4,6,13,66,2,14,5,83,11,21,1,14,4,7,12,65,3,14,5,31,1,1,1,10,2,5,2,5,1,6,1,5,1,5,2,4,11,8,2,4,2,5,1,5,2,8,4,6,11,66,2,14,6,1,2,8,3,4,2,4,3,4,3,3,3,4,3,3,3,3,4,3,3,4,3,4,2,2,11,10,2,4,3,4,2,4,2,8,5,5,11,65,3,14,6,1,2,1,3,4,3,4,2,4,3,4,3,3,3,4,3,3,3,3,4,3,3,3,4,3,16,10,2,4,3,4,2,4,3,8,4,5,11,64,3,15,9,42,1,4,2,4,3,4,3,4,2,5,16,15,1,12,3,9,4,4,11,64,3,10,2,3,8,31,1,18,2,4,2,19,13,11,2,5,1,6,1,15,4,4,11,63,3,9,4,2,7,1,1,11,1,5,2,5,2,5,1,5,2,4,3,4,3,3,3,5,2,4,3,1,12,2,2,11,3,4,2,5,2,2,4,9,4,4,9,64,2,10,4,2,7,1,2,3,1,4,3,4,3,4,3,5,1,4,3,4,3,3,4,3,3,4,3,4,15,3,2,11,3,5,2,4,9,8,5,4,8,63,3,9,5,2,8,4,2,4,3,4,3,3,4,3,3,4,3,4,3,3,4,3,3,4,3,3,17,2,3,10,3,4,3,3,11,8,5,4,7,62,3,10,4,2,10,30,2,4,3,4,3,3,4,3,3,4,3,3,4,1,12,1,4,10,3,4,4,2,4,3,5,7,5,4,7,62,3,10,3,3,9,76,11,1,4,10,2,4,4,6,1,3,5,8,5,1,9,61,3,9,5,3,8,2,2,46,1,5,2,5,2,10,18,10,3,3,5,5,1,3,6,8,14,61,3,9,5,2,9,1,4,8,3,4,3,4,3,4,3,5,2,4,3,4,3,4,3,5,2,2,13,1,5,10,3,3,6,5,2,1,6,8,13,61,3,10,5,2,13,9,3,4,3,4,3,4,3,11,3,4,3,4,3,9,19,11,2,2,7,4,2,2,7,8,12,60,3,11,5,2,13,58,1,11,20,10,12,3,11,8,12,60,3,24,6,71,20,11,1,8,2,9,5,9,11,59,3,40,4,3,5,2,6,1,35,17,9,45,11,59,3,36,61,16,9,46,10,58,3,37,60,17,10,46,8,58,4,114,10,46,8,58,3,116,9,47,7,57,4,172,6,58,3,174,5,57,5,173,6,55,60,73,52,55,4,118,64,53,4,119,64,53,4,120,63,53,4,120,63,53,6,10,3,104,64,53,187,54,186,55,184,59,180,82,7,25,63,2,5,6,5,16,4,9,14,214,2,238,1,239,3,776}
  -- pal = {255,255,255,0,0,0}
  -- pal = ffffff000000
  RLE.draw(img_values, img_runs)
end

--- Gets initial DDR minigame configuration.
--- @within MinigameDDRWindow
--- @return result table The default DDR minigame configuration.
function MinigameDDRWindow.init_context()
  local arrow_size = 12
  local arrow_spacing = 30
  local total_width = (4 * arrow_size) + (3 * arrow_spacing)
  local start_x = (Config.screen.width - total_width) / 2
  return {
    special_mode = "normal", -- "normal", "only_special", "only_left", "only_nothing"
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
    generated_length = 30,
    return_window = nil,
    win_timer = 0,
    on_win = nil,
    total_misses = 0,
    total_hits = 0,
    special_mode_condition = true,
    special_mode_counter = 0
  }
end

function MinigameDDRWindow.prepareSong(song, generated_length, special_mode)
    local current_song = Util.deepcopy(song)


    if current_song.generated then
      local pattern = musicator_generate_pattern(generated_length, current_song.bpm, current_song.spd * 4)
      current_song.pattern = pattern
      current_song.end_frame = pattern[#pattern].frame

      if special_mode == "only_special" then
        for i, _ in ipairs(current_song.pattern) do
          current_song.pattern[i].special = (i % 5 == 0)
        end
      end
    end

    return current_song
end

function MinigameDDRWindow.on_arrow_hit_special(arrow, game_context)
  local special_mode = game_context.special_mode

  if special_mode == "normal" then
    Audio.sfx_arrowhit(arrow.note)
  elseif special_mode == "only_special" then
    if arrow.special then
      Audio.sfx_arrowhit(arrow.note)
      game_context.special_mode_counter = game_context.special_mode_counter + 1
    else
      if game_context.special_mode_condition then Audio.sfx_bloop() end
      game_context.special_mode_condition = false
    end
  elseif special_mode == "only_left" then
    if arrow.dir == "left" then
      Audio.sfx_arrowhit(arrow.note)
      game_context.special_mode_counter = game_context.special_mode_counter + 1
      if game_context.max_fill <= game_context.bar_fill + game_context.fill_per_hit then
        game_context.bar_fill = game_context.bar_fill - game_context.fill_per_hit
      end
    else
      if game_context.special_mode_condition then Audio.sfx_bloop() end
      game_context.special_mode_condition = false
    end
  elseif special_mode == "only_nothing" then
    if game_context.special_mode_condition then Audio.sfx_bloop() end
    game_context.special_mode_condition = false
  end
end

function MinigameDDRWindow.on_end(game_context)
  Audio.sfx_select()

  game_context.win_timer = Config.timing.minigame_win_duration

  local num_special = 0
  for _,v in ipairs(game_context.current_song.pattern) do
    if game_context.special_mode == "only_left" then
      num_special = num_special + ((v.dir == "left" and 1) or 0)
    else
      num_special = num_special + ((v.special and 1) or 0)
    end
  end

  local was_ok = true
  if game_context.special_mode == "normal" then
    was_ok = game_context.special_mode_counter == num_special
  elseif game_context.special_mode == "only_special" then
    was_ok = game_context.special_mode_counter == num_special
  elseif game_context.special_mode == "only_left" then
    was_ok = game_context.special_mode_counter == num_special
  end

  game_context.special_mode_condition = game_context.special_mode_condition and was_ok
end

--- Initializes DDR minigame state.
--- @within MinigameDDRWindow
--- @param params table Optional parameters for configuration.<br/>
function MinigameDDRWindow.init(params)
  local defaults = MinigameDDRWindow.init_context()
  if params then
    for k, v in pairs(params) do
      defaults[k] = v
    end
  end
  Context.minigame_ddr = defaults
end

--- Starts the DDR minigame.
--- @within MinigameDDRWindow
--- @param return_window string The window ID to return to after the minigame.</br>
--- @param[opt] song_key string The key of the song to play.</br>
--- @param[opt] params table Optional parameters for minigame configuration.</br>
function MinigameDDRWindow.start(return_window, song_key, params)
  MinigameDDRWindow.init(params)

  Audio.music_play_activity_work()

  Context.minigame_ddr.return_window = return_window or "game"
  Context.minigame_ddr.debug_song_key = song_key
  if song_key and Songs and Songs[song_key] then
    Context.minigame_ddr.use_pattern = true
    Context.minigame_ddr.pattern_index = 1
    Context.minigame_ddr.debug_status = "Pattern loaded: " .. song_key

    Context.minigame_ddr.current_song = MinigameDDRWindow.prepareSong(
      Songs[song_key],
      Context.minigame_ddr.generated_length,
      Context.minigame_ddr.special_mode
    )

  else
    Context.minigame_ddr.use_pattern = false
    if song_key then
      Context.minigame_ddr.debug_status = "Song not found: " .. tostring(song_key)
    else
      Context.minigame_ddr.debug_status = "Random mode"
    end
  end

  if not Context.test_mode then
    Context.minigame_ddr.debug_status = ""
  end

  Window.set_current("minigame_ddr")
end

--- Spawns a random arrow.
--- @within MinigameDDRWindow
local function spawn_arrow()
  trace("random arrow")

  local mg = Context.minigame_ddr
  local target = mg.target_arrows[math.random(1, 4)]
  table.insert(mg.arrows, {
    dir = target.dir,
    x = target.x,
    y = mg.bar_y + mg.bar_height + 10
  })
end

--- Spawns an arrow in a specific direction.
--- @within MinigameDDRWindow
--- @param direction string The direction of the arrow ("left", "down", "up", "right").
local function spawn_arrow_dir(direction, note, special)
  local mg = Context.minigame_ddr
  for _, target in ipairs(mg.target_arrows) do
    if target.dir == direction then
      table.insert(mg.arrows, {
        dir = direction,
        x = target.x,
        y = mg.bar_y + mg.bar_height + 10,
        note = note,
        special = special
      })
      break
    end
  end
end

--- Checks if an arrow is hit.
--- @within MinigameDDRWindow
--- @param arrow table The arrow data.
--- @return boolean True if the arrow is hit, false otherwise.
local function check_hit(arrow)
  local mg = Context.minigame_ddr
  local distance = math.abs(arrow.y - mg.target_y)
  return distance <= mg.hit_threshold
end

--- Checks if an arrow is missed.
--- @within MinigameDDRWindow
--- @param arrow table The arrow data.
--- @return boolean True if the arrow is missed, false otherwise.
local function check_miss(arrow)
  local mg = Context.minigame_ddr
  return arrow.y > mg.target_y + mg.hit_threshold
end

--- Draws an arrow.
--- @within MinigameDDRWindow
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
--- @param direction string The direction of the arrow.
--- @param color number The color of the arrow.
local function draw_arrow(x, y, direction, color)
  local size = 12
  local half = size / 2
  if direction == "left" then
    tri(x + half, y, x, y + half, x + half, y + size, color)
    rectb(x + half, y + half - 2, half, 4, color)
  elseif direction == "right" then
    tri(x + half, y, x + size, y + half, x + half, y + size, color)
    rectb(x, y + half - 2, half, 4, color)
  elseif direction == "up" then
    tri(x, y + half, x + half, y, x + size, y + half, color)
    rectb(x + half - 2, y + half, 4, half, color)
  elseif direction == "down" then
    tri(x, y + half, x + half, y + size, x + size, y + half, color)
    rectb(x + half - 2, y, 4, half, color)
  end
end

--- Updates DDR minigame logic.
--- @within MinigameDDRWindow
function MinigameDDRWindow.update()
  local mg = Context.minigame_ddr

  if mg.win_timer > 0 then
    mg.win_timer = mg.win_timer - 1
    if mg.win_timer == 0 then
      Audio.music_stop()
      Meter.on_minigame_complete()
      if mg.on_win then
        mg.on_win(mg)
      else
        Meter.show()
        Window.set_current(mg.return_window)
      end
    end
    return
  end

  if mg.bar_fill >= mg.max_fill then
    MinigameDDRWindow.on_end(mg)
    return
  end

  mg.frame_counter = mg.frame_counter + 1

  if mg.use_pattern and mg.current_song and mg.current_song.end_frame then
    if mg.frame_counter > mg.current_song.end_frame and #mg.arrows == 0 then
      MinigameDDRWindow.on_end(mg)
      return
    end
  end

  if mg.use_pattern and mg.current_song and mg.current_song.pattern then
    local pattern = mg.current_song.pattern
    while mg.pattern_index <= #pattern do
      local spawn_entry = pattern[mg.pattern_index]

      if mg.frame_counter >= spawn_entry.frame then
        spawn_arrow_dir(spawn_entry.dir, spawn_entry.note, spawn_entry.special)
        mg.pattern_index = mg.pattern_index + 1
      else
        break
      end
    end
  else
    mg.arrow_spawn_timer = mg.arrow_spawn_timer + 1
    if mg.arrow_spawn_timer >= mg.arrow_spawn_interval then
      spawn_arrow()
      mg.arrow_spawn_timer = 0
    end
  end

  -- move arrow downwards
  local arrows_to_remove = {}
  for i, arrow in ipairs(mg.arrows) do
    arrow.y = arrow.y + mg.arrow_fall_speed
    if check_miss(arrow) then
      table.insert(arrows_to_remove, i)
      mg.bar_fill = mg.bar_fill - mg.miss_penalty
      if mg.bar_fill < 0 then
        mg.bar_fill = 0
      end
      mg.total_misses = mg.total_misses + 1
    end
  end

  -- iterate backwards to avoid index shift issues
  for i = #arrows_to_remove, 1, -1 do
    table.remove(mg.arrows, arrows_to_remove[i])
  end

  for dir, _ in pairs(mg.input_cooldowns) do
    if mg.input_cooldowns[dir] > 0 then
      mg.input_cooldowns[dir] = mg.input_cooldowns[dir] - 1
    end
  end

  for dir, _ in pairs(mg.button_pressed_timers) do
    if mg.button_pressed_timers[dir] > 0 then
      mg.button_pressed_timers[dir] = mg.button_pressed_timers[dir] - 1
    end
  end

  local input_map = {
    left = Input.left(),
    down = Input.down(),
    up = Input.up(),
    right = Input.right()
  }

  for dir, pressed in pairs(input_map) do
    if pressed and mg.input_cooldowns[dir] == 0 then
      mg.input_cooldowns[dir] = mg.input_cooldown_duration
      mg.button_pressed_timers[dir] = mg.button_press_duration
      local hit = false
      for i, arrow in ipairs(mg.arrows) do
        if arrow.dir == dir and check_hit(arrow) then
          MinigameDDRWindow.on_arrow_hit_special(arrow, mg)

          mg.bar_fill = mg.bar_fill + mg.fill_per_hit
          if mg.bar_fill > mg.max_fill then
            mg.bar_fill = mg.max_fill
          end
          table.remove(mg.arrows, i)
          hit = true
          break
        end
      end
      if not hit then
        mg.bar_fill = mg.bar_fill - 2
        if mg.bar_fill < 0 then
          mg.bar_fill = 0
        end
        mg.total_misses = mg.total_misses + 1
      end
    end
  end
end

--- Draws DDR minigame.
--- @within MinigameDDRWindow
function MinigameDDRWindow.draw()
  local mg = Context.minigame_ddr
  if not mg then
    cls(0)
    print("DDR ERROR: Context not initialized", 10, 10, 12)
    print("Press Z to return", 10, 20, 12)
    if Input.select() then
      Window.set_current("game")
    end
    return
  end
  -- if mg.return_window == "game" then
  --   GameWindow.draw()
  -- end
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  local fill_width = (mg.bar_fill / mg.max_fill) * mg.bar_width
  MinigameDDRWindow.draw_background()
  if fill_width > 0 then
    local bar_color = Config.colors.light_blue
    if mg.bar_fill > 66 then
      bar_color = Config.colors.item
    elseif mg.bar_fill > 33 then
      bar_color = Config.colors.blue
    end
    rect(mg.bar_x, mg.bar_y, fill_width, mg.bar_height, bar_color)
  end
  local percentage = math.floor((mg.bar_fill / mg.max_fill) * 100)
  Print.text_center(percentage .. "%", mg.bar_x + mg.bar_width / 2, mg.bar_y + 2, Config.colors.black)
  if mg.target_arrows then
    for _, target in ipairs(mg.target_arrows) do
      local is_pressed = mg.button_pressed_timers[target.dir] and mg.button_pressed_timers[target.dir] > 0
      local color = is_pressed and Config.colors.light_blue or Config.colors.light_grey
      draw_arrow(target.x, mg.target_y, target.dir, color)
    end
  end
  if mg.arrows then
    for _, arrow in ipairs(mg.arrows) do
      local arrow_color = arrow.special and Config.colors.white or Config.colors.blue
      draw_arrow(arrow.x, arrow.y, arrow.dir, arrow_color)
    end
  end
  Print.text_center("Hit the arrows!", Config.screen.width / 2, mg.bar_y + mg.bar_height + 10, Config.colors.light_grey)
  local debug_y = 60
  if mg.debug_status then
    Print.text_center(mg.debug_status, Config.screen.width / 2, debug_y, Config.colors.item)
    debug_y = debug_y + 10
  end
  if mg.use_pattern and Context.test_mode then
    Print.text_center(
      "PATTERN MODE - Frame:" .. mg.frame_counter,
      Config.screen.width / 2,
      debug_y,
      Config.colors.light_blue
    )
    if mg.current_song and mg.current_song.pattern then
      Print.text_center(
        "Pattern Len:" .. #mg.current_song.pattern .. " Index:" .. mg.pattern_index,
        Config.screen.width / 2,
        debug_y + 10,
        Config.colors.light_blue
      )
    end
  elseif Context.test_mode then
    Print.text_center("RANDOM MODE", Config.screen.width / 2, debug_y, Config.colors.blue)
  end
if mg.win_timer > 0 then
  if mg.special_mode_condition then
    Minigame.draw_win_overlay("SUCCESS...?")
  elseif mg.total_hits < 10 then
    Minigame.draw_win_overlay("MEH...")
  else
    Minigame.draw_win_overlay()
  end
end
end
