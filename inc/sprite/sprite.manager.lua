local _sprites = {}

function Sprite.register(sprite_data)
  if not sprite_data or not sprite_data.id then
    trace("Error: Invalid sprite object registered (missing id)!")
    return
  end
  if _sprites[sprite_data.id] then
    trace("Warning: Overwriting sprite with id: " .. sprite_data.id)
  end
  _sprites[sprite_data.id] = sprite_data
end

function Sprite.show(id, x, y, colorkey, scale, flip_x, flip_y, rot)
  -- Ensure the sprite exists before attempting to show it
  if not _sprites[id] then
    trace("Error: Attempted to show non-registered sprite with id: " .. id)
    return
  end

  Context.sprites[id] = {
    id = id,
    x = x,
    y = y,
    colorkey = colorkey,
    scale = scale,
    flip_x = flip_x,
    flip_y = flip_y,
    rot = rot,
  }
end

function Sprite.hide(id)
  Context.sprites[id] = nil
end

function Sprite.draw()
  for id, params in pairs(Context.sprites) do
    local sprite_data = _sprites[id]
    if not sprite_data then
      trace("Error: Sprite id " .. id .. " in Context.sprites is not registered.")
      Context.sprites[id] = nil -- Clean up invalid entry
      -- We should probably continue to the next sprite instead of returning
      -- so that other valid sprites can still be drawn.
    end

    -- Use parameters from Context.sprites, or fall back to sprite_data, then to defaults
    local colorkey = params.colorkey or sprite_data.colorkey or 0
    local scale = params.scale or sprite_data.scale or 1
    local flip_x = params.flip_x or sprite_data.flip_x or 0
    local flip_y = params.flip_y or sprite_data.flip_y or 0
    local rot = params.rot or sprite_data.rot or 0

    if sprite_data.sprites then -- Complex sprite
      for i = 1, #sprite_data.sprites do
        local sub_sprite = sprite_data.sprites[i]
        spr(
          sub_sprite.s,
          params.x + (sub_sprite.x_offset or 0),
          params.y + (sub_sprite.y_offset or 0),
          sub_sprite.colorkey or colorkey,
          sub_sprite.scale or scale,
          sub_sprite.flip_x or flip_x,
          sub_sprite.flip_y or flip_y,
          sub_sprite.rot or rot
        )
      end
    else -- Simple sprite
      spr(sprite_data.s, params.x, params.y, colorkey, scale, flip_x, flip_y, rot)
    end
  end
end
