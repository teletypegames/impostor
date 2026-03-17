Screen.register({
  id = "home",
  name = "Home",
  decisions = {
    "go_to_toilet",
    "go_to_walking_to_office",
    "go_to_sleep",
  },
  background = "bedroom",
  draw = function()
    if Context.home_norman_visible and Window.get_current_id() == "game" then
      Sprite.draw_at("norman", 100, 80)
    end
  end
})
