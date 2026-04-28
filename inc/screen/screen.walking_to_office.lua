Screen.register({
  id = "walking_to_office",
  name = "Walking to office",
  decisions = {
    "go_to_home",
    "go_to_office",
    "sumphore_discussion"
  },
  init = function()
    local possible_sprites = {
      "matrix_trinity",
      "matrix_neo",
      {id="matrix_oraculum", y_correct=1 * 8},
      "matrix_architect"
    }

    local possible_positions = {
      {x = 5 * 8, y = 11 * 8},
      {x = 7 * 8, y = 11 * 8},
      {x = 9 * 8, y = 11 * 8},
      {x = 11 * 8, y = 11 * 8},
      {x = 13 * 8, y = 11 * 8},
      {x = 15 * 8, y = 11 * 8},
      {x = 18 * 8, y = 11 * 8},
      {x = 21 * 8, y = 11 * 8},
      {x = 24 * 8, y = 11 * 8},
      {x = 27 * 8, y = 11 * 8},
    }

    Audio.music_play_room_work()
    Context.walking_to_office_sprites = Sprite.list_randomize(possible_sprites, possible_positions)
  end,
  background = "street",
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",               7 * 8,  3 * 8)
      Sprite.draw_at("sumphore",             9 * 8,  2 * 8)
      Sprite.draw_at("pizza_vendor",        19 * 8,  1 * 8)
      Sprite.draw_at("dev_guard",           22 * 8,  2 * 8)

      Sprite.draw_list(Context.walking_to_office_sprites)
    end
  end
})
