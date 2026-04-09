--- @section Sprite
local _sprites = {}
local _active_sprites = {}

local function draw_sprite_instance(sprite_data, params)
  local colorkey = params.colorkey or sprite_data.colorkey or 0
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

--- Immediately draws a list of sprites
--- @within Sprite
--- @param sprite_list table An array of tables, each containing: `id` (string) sprite identifier, `x` (number) x-coordinate, `y` (number) y-coordinate, and optional `colorkey`, `scale`, `flip_x`, `flip_y`, `rot` parameters.
function Sprite.draw_list(sprite_list)
  for _, sprite_info in ipairs(sprite_list) do
    local sprite_data = _sprites[sprite_info.id]
    if not sprite_data then
      trace("Error: Attempted to draw non-registered sprite with id: " .. sprite_info.id)
    else
      draw_sprite_instance(sprite_data, sprite_info)
    end
  end
end

--- Given a list of sprite IDs (or sprite entries with correction offsets) and a list of possible positions, randomly assigns each sprite to a unique position and returns a drawable list.
--- @within Sprite
--- @param sprite_ids table An array of sprite identifier values or tables.
---                  Each entry may be either:
---                  - string: sprite ID to draw.
---                  - table: { sprite_id = string, x_correct = number, y_correct = number }.
--- @param positions table An array of tables, each containing `x` and `y` fields for possible sprite positions.
function Sprite.list_randomize(sprite_ids, positions)
  if #sprite_ids > #positions then
    trace("Error: More sprite IDs than available positions in Sprite.draw_randomized")
    return
  end

  local shuffled_positions = {}
  for i, pos in ipairs(positions) do
    shuffled_positions[i] = pos
  end
  for i = #shuffled_positions, 2, -1 do
    local j = math.random(i)
    shuffled_positions[i], shuffled_positions[j] = shuffled_positions[j], shuffled_positions[i]
  end

  local drawable_list = {}
  for i, sprite_entry in ipairs(sprite_ids) do
    local sprite_id = sprite_entry
    local x_correct = 0
    local y_correct = 0

    if type(sprite_entry) == "table" then
      sprite_id = sprite_entry.sprite_id or sprite_entry.id
      x_correct = sprite_entry.x_correct or 0
      y_correct = sprite_entry.y_correct or 0
    end

    local sprite_data = _sprites[sprite_id]
    if not sprite_data then
      trace("Error: Attempted to draw non-registered sprite with id: " .. tostring(sprite_id))
    else
      local pos = shuffled_positions[i]
      table.insert(drawable_list, {
        id = sprite_id,
        x = pos.x + x_correct,
        y = pos.y + y_correct
      })
    end
  end

  return drawable_list
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
