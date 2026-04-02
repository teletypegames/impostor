-- .luacheckrc
-- Configuration for luacheck

globals = {
  "Focus",
  "Day",
  "Timer",
  "Glitch",
  "Trigger",
  "Discussion",
  "Util",
  "Decision",
  "Screen",
  "Sprite",
  "UI",
  "Print",
  "Input",
  "Audio",
  "AsciiArt",
  "Ascension",
  "Config",
  "Context",
  "Meter",
  "Minigame",
  "Window",
  "ContinuedWindow",
  "TTGIntroWindow",
  "BriefIntroWindow",
  "TitleIntroWindow",
  "MenuWindow",
  "GameWindow",
  "PopupWindow",
  "AudioTestWindow",
  "MinigameButtonMashWindow",
  "MinigameRhythmWindow",
  "MinigameDDRWindow",
  "MysteriousManScreen",
  "DiscussionWindow",
  "EndWindow",
  "mset",
  "mget",
  "btnp",
  "keyp",
  "music",
  "sfx",
  "spr",
  "rect",
  "rectb",
  "circ",
  "circb",
  "cls",
  "tri",
  "pix",
  "line",
  "Songs",
  "frame_from_beat",
  "beats_to_pattern",
  "MapBedroom",
  "TIC",
  "exit",
  "trace",
  "index_menu",
  "Map",
  "map",
  "time",
  "RLE",
  "mouse",
  "Mouse",
  "print",
  "musicator_generate_pattern",
}



-- Exclude certain warnings globally
exclude_warnings = {
    "undefined_global", -- Will be covered by 'globals' table
    "redefined_loop_variable", -- Common in Lua for iterators
}

-- Options for unused variables
std = "lua51" -- Assuming Lua 5.1, common for TIC-80