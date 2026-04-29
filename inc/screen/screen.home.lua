Screen.register({
  id = "home",
  name = "Home",
  decisions = {
    "go_to_toilet",
    "go_to_walking_to_office",
    "go_to_sleep",
  },
  init = function()
    if CommuteGlitch.is_max() then
      Audio.music_play_mystery()
      Glitch.show()
    else
      Audio.music_play_room_work()
    end
  end,
  background = "bedroom",
  draw = function()
    if Window.get_current_id() ~= "game" then return end
    if CommuteGlitch.is_max() or Ascension.get_level() == 8 then
      CommuteGlitch.draw_background_flicker()
      Glitch.draw()
    end
    if Context.home_norman_visible then
      Sprite.draw_at("norman", 100, 80)
    end
  end
})
