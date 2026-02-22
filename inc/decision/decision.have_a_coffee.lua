Decision.register({
  id = "have_a_coffee",
  label = "Have a Coffee",
  handle = function()
    local new_situation_id = Situation.apply("drink_coffee", Context.game.current_screen)
    Context.game.current_situation = new_situation_id
  end,
})
