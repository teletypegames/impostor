-- DDR Arrow Spawn Patterns
-- Each song defines when arrows should spawn, synced to music beats

Songs = {
  -- Example song pattern
  test_song = {
    name = "Test Song",
    bpm = 120, -- Beats per minute (for reference)
    fps = 60, -- Frames per second (TIC-80 default)
    end_frame = 570, -- Frame when song ends (last note)
    
    -- Arrow spawn pattern
    -- Each entry defines when (in frames) and which direction arrow spawns
    -- Formula: frame = (beat / bpm) * 60 * fps
    -- For 120 BPM: 1 beat = 30 frames, 2 beats = 60 frames, etc.
    pattern = {
      -- Beat 1-4 (intro)
      {frame = 30, dir = "left"},
      {frame = 60, dir = "down"},
      {frame = 90, dir = "up"},
      {frame = 120, dir = "right"},
      
      -- Beat 5-8 (faster)
      {frame = 135, dir = "left"},
      {frame = 150, dir = "right"},
      {frame = 165, dir = "left"},
      {frame = 180, dir = "right"},
      
      -- Beat 9-12 (complex pattern)
      {frame = 210, dir = "left"},
      {frame = 210, dir = "right"}, -- simultaneous
      {frame = 240, dir = "up"},
      {frame = 240, dir = "down"}, -- simultaneous
      {frame = 270, dir = "left"},
      {frame = 300, dir = "right"},
      
      -- Beat 13-16 (rapid sequence)
      {frame = 330, dir = "left"},
      {frame = 345, dir = "down"},
      {frame = 360, dir = "up"},
      {frame = 375, dir = "right"},
      {frame = 390, dir = "left"},
      {frame = 405, dir = "down"},
      {frame = 420, dir = "up"},
      {frame = 435, dir = "right"},
      
      -- Beat 17-20 (finale)
      {frame = 465, dir = "up"},
      {frame = 465, dir = "down"},
      {frame = 495, dir = "left"},
      {frame = 495, dir = "right"},
      {frame = 525, dir = "up"},
      {frame = 540, dir = "down"},
      {frame = 555, dir = "left"},
      {frame = 570, dir = "right"}
    }
  },
  test_song_2 = {
    name = "Test Song 2",
    bpm = 120, -- Beats per minute (for reference)
    fps = 60, -- Frames per second (TIC-80 default)
    end_frame = 570, -- Frame when song ends (last note)
    
    -- Arrow spawn pattern
    -- Each entry defines when (in frames) and which direction arrow spawns
    -- Formula: frame = (beat / bpm) * 60 * fps
    -- For 120 BPM: 1 beat = 30 frames, 2 beats = 60 frames, etc.
    pattern = {
      -- Beat 1-4 (intro)
      {frame = 30, dir = "left"},
      {frame = 60, dir = "down"},
      {frame = 90, dir = "up"},
      {frame = 120, dir = "right"},
      
      -- Beat 5-8 (faster)
      {frame = 135, dir = "left"},
      {frame = 150, dir = "right"},
      {frame = 165, dir = "left"},
      {frame = 180, dir = "right"},
      
      -- Beat 9-12 (complex pattern)
      {frame = 210, dir = "left"},
      {frame = 210, dir = "right"}, -- simultaneous
      {frame = 240, dir = "up"},
      {frame = 240, dir = "down"}, -- simultaneous
      {frame = 270, dir = "left"},
      {frame = 300, dir = "right"},
      
      -- Beat 13-16 (rapid sequence)
      {frame = 330, dir = "left"},
      {frame = 345, dir = "down"},
      {frame = 360, dir = "up"},
      {frame = 375, dir = "right"},
      {frame = 390, dir = "left"},
      {frame = 405, dir = "down"},
      {frame = 420, dir = "up"},
      {frame = 435, dir = "right"},
      
      -- Beat 17-20 (finale)
      {frame = 465, dir = "up"},
      {frame = 465, dir = "down"},
      {frame = 495, dir = "left"},
      {frame = 495, dir = "right"},
      {frame = 525, dir = "up"},
      {frame = 540, dir = "down"},
      {frame = 555, dir = "left"},
      {frame = 570, dir = "right"}
    }
  },
  -- Random mode (no predefined pattern, spawns randomly)
  random = {
    name = "Random Mode",
    bpm = 0, -- Not applicable for random mode
    fps = 60,
    end_frame = nil, -- No end frame for random mode
    pattern = {} -- Empty, will spawn randomly in game
  }
}

-- Helper function to calculate frame from beat
-- Usage: frame_from_beat(beat_number, bpm, fps)
function frame_from_beat(beat, bpm, fps)
  fps = fps or 60
  local seconds_per_beat = 60 / bpm
  local frames_per_beat = seconds_per_beat * fps
  return math.floor(beat * frames_per_beat)
end

-- Helper function to convert simple beat notation to frame pattern
-- Usage: beats_to_pattern({{1, "left"}, {2, "down"}}, 120)
function beats_to_pattern(beats, bpm, fps)
  fps = fps or 60
  local pattern = {}
  for _, beat_data in ipairs(beats) do
    local beat = beat_data[1]
    local dir = beat_data[2]
    table.insert(pattern, {
      frame = frame_from_beat(beat, bpm, fps),
      dir = dir
    })
  end
  return pattern
end

-- Example of creating a song using beat notation:
--[[
Songs.custom_song = {
  name = "Custom Song",
  bpm = 130,
  fps = 60,
  pattern = beats_to_pattern({
    {1, "left"},
    {2, "down"},
    {3, "up"},
    {4, "right"},
    {4.5, "left"},
    {5, "right"}
  }, 130)
}
]]
