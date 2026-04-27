Screen.register({
  id = "walking_to_home",
  name = "Walking to home",
  decisions = {
    "go_to_home",
    "go_to_office",
    "eating_fast_food",
  },
  init = function()
    Audio.music_play_room_work()
  end,
  background = "street",
  draw = function()
    local w = Window.get_current_id()
    if w == "game" or w == "discussion" then
      local norman_x = Context.fast_food_approaching and (19 * 8) or (7 * 8)
      Sprite.draw_at("norman",               norman_x,  3 * 8)
      if Context.fast_food_eaten_today < 3 then
        Sprite.draw_at("pizza_vendor",      19 * 8,  1 * 8)
      end
      Sprite.draw_at("dev_guard",           22 * 8,  2 * 8)
    end
  end
})
