Sprite.register({
  id = "norman",
  sprites = {
    -- Body (sprite index 0)
    { s = 0, x_offset = 0, y_offset = 0 },
    -- Head (sprite index 1)
    { s = 1, x_offset = 0, y_offset = -8 },
    -- Left Arm (sprite index 2)
    { s = 2, x_offset = -4, y_offset = 4 },
    -- Right Arm (sprite index 3, flipped)
    { s = 3, x_offset = 4, y_offset = 4, flip_x = 1 }, -- Flipped arm
    -- Left Leg (sprite index 4)
    { s = 4, x_offset = -2, y_offset = 8 },
    -- Right Leg (sprite index 5, flipped)
    { s = 5, x_offset = 2, y_offset = 8, flip_x = 1 } -- Flipped leg
  }
})