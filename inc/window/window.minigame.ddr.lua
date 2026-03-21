--- @section MinigameDDRWindow

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
  if mg.return_window == "game" then
    GameWindow.draw()
  end
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  local fill_width = (mg.bar_fill / mg.max_fill) * mg.bar_width
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
