Discussion.register({
  id = "pizza_vendor_disc",
  on_end = function()
    Context.fast_food_approaching = false
  end,
  steps = {
    {
      question = "Hey friend! Hot slice, fresh out of the oven. You look like a man who knows good food!",
      answers = {
        {
          label = "Devour a juicy one",
          next_step = nil,
          on_select = function()
            local max = Meter.get_max()
            Meter.add("wpm", math.floor(max * 0.05))
            Meter.add("ism", math.floor(max * -0.05))
            Meter.add("bm", math.floor(max * -0.05))
            Context.fast_food_eaten_today = Context.fast_food_eaten_today + 1
          end,
        },
        {
          label = "Stay lean and sharp",
          next_step = nil,
        },
      },
    },
  },
})
