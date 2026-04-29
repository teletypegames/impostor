Decision.register({
  id = "eating_fast_food",
  label = "Eat Fast Food",
  condition = function()
    return Context.fast_food_eaten_today < 3
  end,
  handle = function()
    Context.fast_food_approaching = true
    Discussion.start("pizza_vendor_disc", "game")
  end,
})
