Screen.register({
  id = "walking_to_office",
  name = "Walking to office",
  decisions = {
    "go_to_home",
    "go_to_office",
    "sumphore_discussion",
  },
  init = function()
    Audio.music_play_room_work()
  end,
  background = "street",
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",               7 * 8,  3 * 8)
      Sprite.draw_at("sumphore",             9 * 8,  2 * 8)
      Sprite.draw_at("pizza_vendor",        19 * 8,  1 * 8)
      Sprite.draw_at("dev_guard",           22 * 8,  2 * 8)
      Sprite.draw_at("matrix_trinity",       5 * 8, 11 * 8)
      Sprite.draw_at("matrix_neo",           7 * 8, 11 * 8)
      Sprite.draw_at("matrix_oraculum",      9 * 8, 12 * 8)
      Sprite.draw_at("matrix_architect",    11 * 8, 11 * 8)
    end
  end
})
