Screen.register({
  id = "office",
  name = "Office",
  decisions = {
    "do_work",
    "go_to_walking_to_home",
    "have_a_coffee",
    "talk_to_truth",
  },
  init = function()
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

    if CommuteGlitch.is_max() then
      Audio.music_play_mystery()
      Context.office_sprites = { "norman_echo" }
    else
      Audio.music_play_room_work(CommuteGlitch.music_speed())
      Context.office_sprites = Sprite.list_randomize(possible_sprites, possible_positions)
      if CommuteGlitch.is_active() then
        Context.office_sprites = CommuteGlitch.corrupt_sprite_list(Context.office_sprites)
      end
    end
  end,
  background = function()
    return CommuteGlitch.is_max() and "" or "office"
  end,
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",              13 * 8,  9 * 8)

      if CommuteGlitch.is_max() then
        Sprite.draw_at("norman_echo",              15 * 8,  9 * 8)
        CommuteGlitch.draw_background_flicker()
      else
        CommuteGlitch.draw_sprite_list(Context.office_sprites)
      end

      if CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 6 then
        Glitch.draw()
      end

      if Ascension.get_level() == 8 then
        CommuteGlitch.draw_background_flicker()
        Glitch.draw()
      end
    end
  end
})
