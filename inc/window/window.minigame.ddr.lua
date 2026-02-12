function MinigameDDRWindow.init()
  -- Calculate evenly spaced arrow positions
  local arrow_size = 12
  local arrow_spacing = 30
  local total_width = (4 * arrow_size) + (3 * arrow_spacing)
  local start_x = (Config.screen.width - total_width) / 2
  
  Context.minigame_ddr = {
    -- Progress bar (matching button mash style)
    bar_fill = 0, -- 0 to 100
    max_fill = 100,
    fill_per_hit = 10, -- Points gained per perfect hit
    miss_penalty = 5, -- Points lost per miss
    bar_x = 20,
    bar_y = 10,
    bar_width = 200,
    bar_height = 12,
    
    -- Arrow settings
    arrow_size = arrow_size,
    arrow_spawn_timer = 0,
    arrow_spawn_interval = 45, -- Frames between arrow spawns (for random mode)
    arrow_fall_speed = 1.5, -- Pixels per frame
    arrows = {}, -- Active falling arrows {dir, x, y}
    
    -- Target arrows at bottom (evenly spaced, centered on screen)
    target_y = 115, -- Y position of target arrows
    target_arrows = {
      {dir = "left", x = start_x},
      {dir = "down", x = start_x + arrow_size + arrow_spacing},
      {dir = "up", x = start_x + (arrow_size + arrow_spacing) * 2},
      {dir = "right", x = start_x + (arrow_size + arrow_spacing) * 3}
    },
    
    -- Hit detection
    hit_threshold = 8, -- Pixels of tolerance for perfect hit
    button_pressed_timers = {}, -- Visual feedback per arrow
    button_press_duration = 8,
    
    -- Input cooldown per direction
    input_cooldowns = {
      left = 0,
      down = 0,
      up = 0,
      right = 0
    },
    input_cooldown_duration = 10,
    
    -- Song/Pattern system
    frame_counter = 0, -- Tracks frames since start
    current_song = nil, -- Current song data
    pattern_index = 1, -- Current position in pattern
    use_pattern = false, -- If true, use song pattern; if false, use random spawning
    
    return_window = WINDOW_GAME
  }
end

function MinigameDDRWindow.start(return_window, song_key)
  MinigameDDRWindow.init()
  Context.minigame_ddr.return_window = return_window or WINDOW_GAME
  
  -- Debug: Store song_key for display
  Context.minigame_ddr.debug_song_key = song_key
  
  -- Load song pattern if specified
  if song_key and Songs and Songs[song_key] then
    Context.minigame_ddr.current_song = Songs[song_key]
    Context.minigame_ddr.use_pattern = true
    Context.minigame_ddr.pattern_index = 1
    Context.minigame_ddr.debug_status = "Pattern loaded: " .. song_key
  else
    -- Default to random spawning
    Context.minigame_ddr.use_pattern = false
    if song_key then
      Context.minigame_ddr.debug_status = "Song not found: " .. tostring(song_key)
    else
      Context.minigame_ddr.debug_status = "Random mode"
    end
  end
  
  Context.active_window = WINDOW_MINIGAME_DDR
end

-- Spawn a new arrow (random direction)
local function spawn_arrow()
  local mg = Context.minigame_ddr
  local target = mg.target_arrows[math.random(1, 4)]
  table.insert(mg.arrows, {
    dir = target.dir,
    x = target.x,
    y = mg.bar_y + mg.bar_height + 10 -- Start below progress bar
  })
end

-- Spawn an arrow with specific direction
local function spawn_arrow_dir(direction)
  local mg = Context.minigame_ddr
  -- Find the target arrow for this direction
  for _, target in ipairs(mg.target_arrows) do
    if target.dir == direction then
      table.insert(mg.arrows, {
        dir = direction,
        x = target.x,
        y = mg.bar_y + mg.bar_height + 10
      })
      break
    end
  end
end

-- Check if arrow is close enough for a hit
local function check_hit(arrow)
  local mg = Context.minigame_ddr
  local distance = math.abs(arrow.y - mg.target_y)
  return distance <= mg.hit_threshold
end

-- Check if arrow has passed the target
local function check_miss(arrow)
  local mg = Context.minigame_ddr
  return arrow.y > mg.target_y + mg.hit_threshold
end

-- Draw a single arrow sprite
local function draw_arrow(x, y, direction, color)
  local size = 12
  local half = size / 2
  
  -- Draw arrow shape based on direction
  if direction == "left" then
    -- Triangle pointing left
    tri(x + half, y, x, y + half, x + half, y + size, color)
    rect(x + half, y + half - 2, half, 4, color)
  elseif direction == "right" then
    -- Triangle pointing right
    tri(x + half, y, x + size, y + half, x + half, y + size, color)
    rect(x, y + half - 2, half, 4, color)
  elseif direction == "up" then
    -- Triangle pointing up
    tri(x, y + half, x + half, y, x + size, y + half, color)
    rect(x + half - 2, y + half, 4, half, color)
  elseif direction == "down" then
    -- Triangle pointing down
    tri(x, y + half, x + half, y + size, x + size, y + half, color)
    rect(x + half - 2, y, 4, half, color)
  end
end

function MinigameDDRWindow.update()
  local mg = Context.minigame_ddr
  
  -- Check for completion
  if mg.bar_fill >= mg.max_fill then
    Context.active_window = mg.return_window
    return
  end
  
  -- Increment frame counter
  mg.frame_counter = mg.frame_counter + 1
  
  -- Spawn arrows based on mode (pattern or random)
  if mg.use_pattern and mg.current_song and mg.current_song.pattern then
    -- Pattern-based spawning (synced to song)
    local pattern = mg.current_song.pattern
    
    -- Check if current frame matches any pattern entry
    while mg.pattern_index <= #pattern do
      local spawn_entry = pattern[mg.pattern_index]
      
      if mg.frame_counter >= spawn_entry.frame then
        -- Time to spawn this arrow!
        spawn_arrow_dir(spawn_entry.dir)
        mg.pattern_index = mg.pattern_index + 1
      else
        -- Not time yet, break the loop
        break
      end
    end
    
    -- If we've finished the pattern, check if we should loop or end
    if mg.pattern_index > #pattern then
      -- Pattern complete - could loop or switch to random mode
      -- For now, keep playing but stop spawning new arrows
      -- Optionally: mg.pattern_index = 1 to loop
    end
  else
    -- Random spawning mode (original behavior)
    mg.arrow_spawn_timer = mg.arrow_spawn_timer + 1
    if mg.arrow_spawn_timer >= mg.arrow_spawn_interval then
      spawn_arrow()
      mg.arrow_spawn_timer = 0
    end
  end
  
  -- Update falling arrows
  local arrows_to_remove = {}
  for i, arrow in ipairs(mg.arrows) do
    arrow.y = arrow.y + mg.arrow_fall_speed
    
    -- Check if arrow went off-screen (miss)
    if check_miss(arrow) then
      table.insert(arrows_to_remove, i)
      -- Penalty for missing
      mg.bar_fill = mg.bar_fill - mg.miss_penalty
      if mg.bar_fill < 0 then
        mg.bar_fill = 0
      end
    end
  end
  
  -- Remove off-screen arrows (iterate backwards to avoid index issues)
  for i = #arrows_to_remove, 1, -1 do
    table.remove(mg.arrows, arrows_to_remove[i])
  end
  
  -- Update input cooldowns
  for dir, _ in pairs(mg.input_cooldowns) do
    if mg.input_cooldowns[dir] > 0 then
      mg.input_cooldowns[dir] = mg.input_cooldowns[dir] - 1
    end
  end
  
  -- Update button press timers
  for dir, _ in pairs(mg.button_pressed_timers) do
    if mg.button_pressed_timers[dir] > 0 then
      mg.button_pressed_timers[dir] = mg.button_pressed_timers[dir] - 1
    end
  end
  
  -- Check for arrow key inputs
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
      
      -- Check if any arrow matches this direction and is in hit range
      local hit = false
      for i, arrow in ipairs(mg.arrows) do
        if arrow.dir == dir and check_hit(arrow) then
          -- Perfect hit!
          mg.bar_fill = mg.bar_fill + mg.fill_per_hit
          if mg.bar_fill > mg.max_fill then
            mg.bar_fill = mg.max_fill
          end
          table.remove(mg.arrows, i)
          hit = true
          break
        end
      end
      
      -- If pressed but no arrow to hit, apply small penalty
      if not hit then
        mg.bar_fill = mg.bar_fill - 2
        if mg.bar_fill < 0 then
          mg.bar_fill = 0
        end
      end
    end
  end
end

function MinigameDDRWindow.draw()
  local mg = Context.minigame_ddr
  
  -- Safety check
  if not mg then
    cls(0)
    print("DDR ERROR: Context not initialized", 10, 10, 12)
    print("Press Z to return", 10, 20, 12)
    if Input.select() then
      Context.active_window = WINDOW_GAME
    end
    return
  end
  
  -- Draw the underlying window first (for overlay effect)
  if mg.return_window == WINDOW_GAME then
    GameWindow.draw()
  end
  
  -- Draw semi-transparent overlay background
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  
  -- Draw progress bar background
  rect(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.light_grey)
  rectb(mg.bar_x - 2, mg.bar_y - 2, mg.bar_width + 4, mg.bar_height + 4, Config.colors.dark_grey)
  
  -- Draw progress bar fill
  local fill_width = (mg.bar_fill / mg.max_fill) * mg.bar_width
  if fill_width > 0 then
    -- Color changes as bar fills
    local bar_color = Config.colors.green
    if mg.bar_fill > 66 then
      bar_color = Config.colors.item -- yellow
    elseif mg.bar_fill > 33 then
      bar_color = Config.colors.npc
    end
    
    rect(mg.bar_x, mg.bar_y, fill_width, mg.bar_height, bar_color)
  end
  
  -- Draw progress percentage
  local percentage = math.floor((mg.bar_fill / mg.max_fill) * 100)
  Print.text_center(percentage .. "%", mg.bar_x + mg.bar_width / 2, mg.bar_y + 2, Config.colors.black)
  
  -- Draw target arrows at bottom (light grey when not pressed)
  if mg.target_arrows then
    for _, target in ipairs(mg.target_arrows) do
      local is_pressed = mg.button_pressed_timers[target.dir] and mg.button_pressed_timers[target.dir] > 0
      local color = is_pressed and Config.colors.green or Config.colors.light_grey
      draw_arrow(target.x, mg.target_y, target.dir, color)
    end
  end
  
  -- Draw falling arrows (blue)
  if mg.arrows then
    for _, arrow in ipairs(mg.arrows) do
      draw_arrow(arrow.x, arrow.y, arrow.dir, Config.colors.npc) -- blue color
    end
  end
  
  -- Draw instruction text
  Print.text_center("Hit the arrows!", Config.screen.width / 2, mg.bar_y + mg.bar_height + 10, Config.colors.light_grey)
  
  -- Debug info (large and visible)
  local debug_y = 60
  if mg.debug_status then
    Print.text_center(mg.debug_status, Config.screen.width / 2, debug_y, Config.colors.item)
    debug_y = debug_y + 10
  end
  if mg.use_pattern then
    Print.text_center("PATTERN MODE - Frame:" .. mg.frame_counter, Config.screen.width / 2, debug_y, Config.colors.green)
    if mg.current_song and mg.current_song.pattern then
      Print.text_center("Pattern Len:" .. #mg.current_song.pattern .. " Index:" .. mg.pattern_index, Config.screen.width / 2, debug_y + 10, Config.colors.green)
    end
  else
    Print.text_center("RANDOM MODE", Config.screen.width / 2, debug_y, Config.colors.npc)
  end
end
