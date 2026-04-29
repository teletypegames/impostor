Decision.register({
  id = "eating_fast_food",
  label = "Eat Fast Food",
  condition = function()
    return
      (not CommuteGlitch.is_active() and Context.fast_food_eaten_today < 3) or
      (CommuteGlitch.is_active() and CommuteGlitch.get_level() <= 4)
  end,
  handle = function()
    Context.fast_food_approaching = true
    Discussion.start("pizza_vendor_disc", "game")
  end,
})
