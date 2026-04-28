Screen.register({
  id = "walking_to_home",
  name = "Walking to home",
  decisions = {
    "go_to_home",
    "go_to_office",
    "sumphore_discussion",
    "go_to_truth",
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

    if CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 7 then
      Audio.music_play_mystery()
      Context.walking_to_home_sprites = {}
    else
      Audio.music_play_room_work(CommuteGlitch.music_speed())
      Context.walking_to_home_sprites = Sprite.list_randomize(possible_sprites, possible_positions)
      if CommuteGlitch.is_active() then
        Context.walking_to_home_sprites = CommuteGlitch.corrupt_sprite_list(Context.walking_to_home_sprites)
      end
    end
  end,
  background = function()
    return CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 7 and "" or "street"
  end,
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",               7 * 8,  3 * 8)
      Sprite.draw_at("sumphore",             9 * 8,  2 * 8)

      if not (CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 7) then
        Sprite.draw_at("pizza_vendor",        19 * 8,  1 * 8)
        Sprite.draw_at("dev_guard",           22 * 8,  2 * 8)
      end

      CommuteGlitch.draw_sprite_list(Context.walking_to_home_sprites)

      if CommuteGlitch.is_active() then
        if CommuteGlitch.get_level() >= 7 then CommuteGlitch.draw_background_flicker() end
        if CommuteGlitch.get_level() >= 6 then Glitch.draw() end
      end
    end
  end
})
