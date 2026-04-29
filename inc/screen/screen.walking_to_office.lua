Screen.register({
  id = "walking_to_office",
  name = "Walking to office",
  decisions = {
    "go_to_home",
    "go_to_office",
    "sumphore_discussion",
    "eating_fast_food",
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
      Context.walking_to_office_sprites = Sprite.list_randomize(possible_sprites, possible_positions)
      Context.walking_to_office_sprites = CommuteGlitch.corrupt_sprite_list(Context.walking_to_office_sprites)
    else
      Audio.music_play_room_work()
      Context.walking_to_office_sprites = Sprite.list_randomize(possible_sprites, possible_positions)
    end
  end,
  background = function()
    return CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 7 and "" or "street"
  end,
  update = function()
  end,
  draw = function()
    local w = Window.get_current_id()
    if w == "game" or w == "discussion" then
      local norman_x = Context.fast_food_approaching and (19 * 8) or (7 * 8)
      Sprite.draw_at("norman",               norman_x,  3 * 8)
      Sprite.draw_at("sumphore",              9 * 8,    2 * 8)

      if CommuteGlitch.is_active() and CommuteGlitch.get_level() >= 7 then
        Sprite.draw_at("norman_echo",        norman_x,  3 * 8)
        CommuteGlitch.draw_sprite_list(Context.walking_to_office_sprites)
        CommuteGlitch.draw_background_flicker()
        Glitch.draw()
      else
        if Context.fast_food_eaten_today < 3 then
          Sprite.draw_at("pizza_vendor",     19 * 8,    1 * 8)
        end
        Sprite.draw_at("dev_guard",          22 * 8,    3 * 8)
        Sprite.draw_list(Context.walking_to_office_sprites)
      end
    end
  end
})
