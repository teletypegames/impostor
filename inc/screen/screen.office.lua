Screen.register({
  id = "office",
  name = "Office",
  decisions = {
    "do_work",
    "go_to_walking_to_home",
    "have_a_coffee",
  },
  init = function()
    Audio.music_play_room_work()
    Context.have_been_to_office = true

    local possible_sprites = {
      "dev_project_manager",
      "dev_hr_girl",
      "dev_introvert",
      "dev_extrovert",
      "dev_guru",
      "dev_operator",
      {id="dev_buddy", y_correct=1 * 8},
      {id="dev_boy", y_correct=1 * 8},
      {id="dev_girl", y_correct=1 * 8}
    }

    local possible_positions = {
      {x = 6 * 8, y = 4 * 8},
      {x = 10 * 8, y = 11 * 8 + 4},
      {x = 12 * 8, y = 4 * 8},
      {x = 15 * 8, y = 9 * 8},
      {x = 16 * 8, y = 4 * 8},
      {x = 17 * 8, y = 8 * 8},
      {x = 17 * 8, y = 11 * 8},
      {x = 20 * 8, y = 4 * 8},
      {x = 23 * 8, y = 5 * 8},
      {x = 22 * 8, y = 10 * 8 + 4},
      {x = 27 * 8, y = 10 * 8 + 4},
      {x = -4 + 5 * 8, y = 9 * 8}
    }

    Context.office_sprites = Sprite.list_randomize(possible_sprites, possible_positions)
  end,
  background = "office",
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",              13 * 8,  9 * 8)

      Sprite.draw_list(Context.office_sprites)
    end
  end
})
