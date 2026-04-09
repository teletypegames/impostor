--- @section Sprite
local _sprites = {}
local _active_sprites = {}

local function draw_sprite_instance(sprite_data, params)
  local colorkey = params.colorkey or sprite_data.colorkey or Config.colors.transparent
  local scale = params.scale or sprite_data.scale or 1
  local flip_x = params.flip_x or sprite_data.flip_x or 0
  local flip_y = params.flip_y or sprite_data.flip_y or 0
  local rot = params.rot or sprite_data.rot or 0

  if sprite_data.sprites then
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
  else
    spr(sprite_data.s, params.x, params.y, colorkey, scale, flip_x, flip_y, rot)
  end
end

--- Registers a sprite definition.
--- @within Sprite
--- @param sprite_data table A table containing the sprite definition.
--- @param sprite_data.id string Unique sprite identifier.<br/>
--- @param[opt] sprite_data.s number Sprite index for single-sprite mode.<br/>
--- @param[opt] sprite_data.colorkey number Default color index for transparency.<br/>
--- @param[opt] sprite_data.scale number Default scaling factor.<br/>
--- @param[opt] sprite_data.flip_x number Set to 1 to flip horizontally by default.<br/>
--- @param[opt] sprite_data.flip_y number Set to 1 to flip vertically by default.<br/>
--- @param[opt] sprite_data.rot number Default rotation in degrees.<br/>
--- @param[opt] sprite_data.sprites table Array of sub-sprite tables for composite sprites. Each entry has: `s` (number) sprite index, `x_offset` (number) horizontal offset, `y_offset` (number) vertical offset, and optional `colorkey`, `scale`, `flip_x`, `flip_y`, `rot` overrides.<br/>
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

--- Generates a sprites table for a rectangular composite sprite.
--- @within Sprite
--- @param width number The number of sprites wide.<br/>
--- @param height number The number of sprites tall.<br/>
--- @param starting_s number The sprite index of the top-left tile.<br/>
--- @param x_base number The base x-offset for the leftmost column.<br/>
--- @param y_base number The base y-offset for the topmost row.<br/>
--- @param x_step number The x-offset increment per column.<br/>
--- @param y_step number The y-offset increment per row.<br/>
--- @return table The sprites table array.
function Sprite.generate_table(width, height, starting_s, x_base, y_base, x_step, y_step)
  local sprites = {}
  for row = 0, height - 1 do
    for col = 0, width - 1 do
      local s = starting_s + row * 16 + col
      local x_offset = x_base + col * x_step
      local y_offset = y_base + row * y_step
      table.insert(sprites, { s = s, x_offset = x_offset, y_offset = y_offset })
    end
  end
  return sprites
end

--- Schedules a sprite for drawing.
--- @within Sprite
--- @param id string The unique identifier of the sprite.<br/>
--- @param x number The x-coordinate.<br/>
--- @param y number The y-coordinate.<br/>
--- @param[opt] colorkey number The color index for transparency.<br/>
--- @param[opt] scale number The scaling factor.<br/>
--- @param[opt] flip_x number Set to 1 to flip horizontally.<br/>
--- @param[opt] flip_y number Set to 1 to flip vertically.<br/>
--- @param[opt] rot number The rotation in degrees.<br/>
function Sprite.show(id, x, y, colorkey, scale, flip_x, flip_y, rot)
  if not _sprites[id] then
    trace("Error: Attempted to show non-registered sprite with id: " .. id)
    return
  end

  _active_sprites[id] = {
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

--- Hides a displayed sprite.
--- @within Sprite
--- @param id string The unique identifier of the sprite.<br/>
function Sprite.hide(id)
  _active_sprites[id] = nil
end

--- Draws a sprite immediately without scheduling it.
--- @within Sprite
--- @param id string The unique identifier of the sprite.<br/>
--- @param x number The x-coordinate.<br/>
--- @param y number The y-coordinate.<br/>
--- @param[opt] colorkey number The color index for transparency.<br/>
--- @param[opt] scale number The scaling factor.<br/>
--- @param[opt] flip_x number Set to 1 to flip horizontally.<br/>
--- @param[opt] flip_y number Set to 1 to flip vertically.<br/>
--- @param[opt] rot number The rotation in degrees.<br/>
function Sprite.draw_at(id, x, y, colorkey, scale, flip_x, flip_y, rot)
  local sprite_data = _sprites[id]
  if not sprite_data then
    trace("Error: Attempted to draw non-registered sprite with id: " .. id)
    return
  end

  draw_sprite_instance(sprite_data, {
    x = x,
    y = y,
    colorkey = colorkey,
    scale = scale,
    flip_x = flip_x,
    flip_y = flip_y,
    rot = rot,
  })
end

--- Draws all scheduled sprites.
--- @within Sprite
function Sprite.draw()
  for id, params in pairs(_active_sprites) do
    local sprite_data = _sprites[id]
    if not sprite_data then
      trace("Error: Sprite id " .. id .. " in _active_sprites is not registered.")
      _active_sprites[id] = nil
    end
    if sprite_data then
      draw_sprite_instance(sprite_data, params)
    end
  end
end
