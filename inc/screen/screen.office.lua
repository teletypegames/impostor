Screen.register({
  id = "office",
  name = "Office",
  decisions = {
    "do_work",
    "go_to_walking_to_home",
    "have_a_coffee",
  },
  situations = {
    "drink_coffee",
  },
  background = "office",
  draw = function()
    if Window.get_current_id() == "game" then
      Sprite.draw_at("norman",              13 * 8,  9 * 8)
      Sprite.draw_at("dev_buddy",           15 * 8,  9 * 8)
      Sprite.draw_at("dev_project_manager",  6 * 8,  4 * 8)
      Sprite.draw_at("dev_hr_girl",         12 * 8,  4 * 8)
      Sprite.draw_at("dev_introvert",   -4 + 5 * 8,  9 * 8)
      Sprite.draw_at("dev_extrovert",       20 * 8,  4 * 8)
      Sprite.draw_at("dev_girl",            23 * 8,  5 * 8)
      Sprite.draw_at("dev_boy",             10 * 8, 11 * 8 + 4)
      Sprite.draw_at("dev_guru",            22 * 8, 10 * 8 + 4)
      Sprite.draw_at("dev_operator",        27 * 8, 10 * 8 + 4)
    end
    Context.have_been_to_office = true
  end
})
