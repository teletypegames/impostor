Screen.register({
  id = "walking_to_home",
  name = "Walking to home",
  decisions = {
    "go_to_home",
    "go_to_office",
  },
  background = "street",
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",               7 * 8,  3 * 8)
      Sprite.draw_at("pizza_vendor",        19 * 8,  1 * 8)
      Sprite.draw_at("dev_guard",           22 * 8,  2 * 8)
    end
  end
})
