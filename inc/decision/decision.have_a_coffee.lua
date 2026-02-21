Decision.register({
  id = "have_a_coffee",
  label = "Have a Coffee",
  handle = function()
    Situation.apply("drink_coffee")
  end,
  condition = function() return true end
})
