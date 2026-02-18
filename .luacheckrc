-- .luacheckrc
-- Configuration for luacheck

globals = {
  "Util",
  "DesitionManager",
  "ScreenManager",
  "UI",
  "Print",
  "Input",
  "Audio",
  "Context",
  "mset",
  "mget",
  "btnp",
  "keyp",
  "music",
  "sfx",
  "rect",
  "rectb",
  "circ",
  "circb",
  "cls",
  "tri",
  "Songs",
  "frame_from_beat",
  "beats_to_pattern",
  "MapBedroom",
  "TIC",
  "exit",
  "trace",
  "index_menu",
  "MapManager",
  "map",
}



-- Exclude certain warnings globally
exclude_warnings = {
    "undefined_global", -- Will be covered by 'globals' table
    "redefined_loop_variable", -- Common in Lua for iterators
}

-- Options for unused variables
std = "lua51" -- Assuming Lua 5.1, common for TIC-80