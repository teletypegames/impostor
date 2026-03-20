Discussion.register({
  id = "coworker_asc_1",
  steps = {
    {
      question = "Normann you look weird and unfocused. You are usually locked in and not like this, what's up?",
      answers = {
        { label = "Nothing it's just, I noticed some bugs in the simulation, maybe.", next_step = 2 },
        { label = "Same old - same old", next_step = nil },
      },
    },
    {
      question = "What kind of bugs?",
      answers = {
        { label = "Some of the data is not being processed correctly, I think.", next_step = nil },
        { label = "I don't know, I'm not a programmer.", next_step = nil, on_select = function()
          Meter.add("ism", 10)
        end },
      },
    },
  },
})