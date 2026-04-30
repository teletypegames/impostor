-- Norman echo: same tile indices as norman.
-- Color remap is applied by CommuteGlitch.draw_sprite_list via pal().
-- Implementer: set ECHO_SRC/ECHO_DST in logic.commute_glitch.lua after inspecting the palette.
Sprite.register({
  id = "norman_echo",
  sprites = {
    { s = 272, x_offset = -4, y_offset = -4 },
    { s = 273, x_offset =  4, y_offset = -4 },
    { s = 288, x_offset = -4, y_offset =  4 },
    { s = 289, x_offset =  4, y_offset =  4 },
    { s = 304, x_offset = -4, y_offset = 12 },
    { s = 305, x_offset =  4, y_offset = 12 },
  }
})
