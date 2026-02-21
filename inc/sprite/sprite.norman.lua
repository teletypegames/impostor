Sprite.register({
  id = "norman",
  sprites = {
    -- Body
    { s = 0, x_offset = 0, y_offset = 0 },
    -- Head
    { s = 1, x_offset = 0, y_offset = -8 },
    -- Left Arm
    { s = 2, x_offset = -4, y_offset = 4 },
    -- Right Arm
    { s = 3, x_offset = 4, y_offset = 4, flip_x = 1 }, -- Flipped arm
    -- Left Leg
    { s = 4, x_offset = -2, y_offset = 8 },
    -- Right Leg
    { s = 5, x_offset = 2, y_offset = 8, flip_x = 1 } -- Flipped leg
  }
})
