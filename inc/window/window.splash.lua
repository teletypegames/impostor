function SplashWindow.draw()
  for y, row in ipairs(MapBedroom) do
    for x = 1, #row, 2 do
      local tile_id_hex = string.sub(row, x, x + 1)
      local tile_id = tonumber(tile_id_hex, 16)
      local screen_x = (x - 1) / 2 * 8
      local screen_y = (y - 1) * 8
      spr(tile_id, screen_x, screen_y, -1, 1, 0, 0, 1, 1)
    end
  end
end

function SplashWindow.update()
  Context.splash_timer = Context.splash_timer - 1
  if Context.splash_timer <= 0 or Input.menu_confirm() then
    GameWindow.set_state(WINDOW_INTRO)
  end
end
