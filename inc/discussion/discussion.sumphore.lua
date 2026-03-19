Discussion.register({
  id = "sumphore_day_3",
  steps = {
    {
      question = "Are you still seeking the ox?",
      answers = {
        { label = "Huh? What ox?", next_step = 2 },
        { label = "Are you drunk, old man?", next_step = nil },
      },
    },
    {
      question = "Did you never think there would be more to this?",
      answers = {
        { label = "I'm not sure what you mean.", next_step = nil },
      },
    },
  },
})


Discussion.register({
  id = "homeless_guy",
  steps = {
    {
      question = "Sup bro, how are you?",
      answers = {
        { label = "I'm doing great, thanks!", next_step = 2 },
        { label = "Not as good as you", next_step = nil },
      },
    },
    {
      question = "What's your name?",
      answers = {
        { label = "Norman Reds, nice to meet you.", next_step = 3 },
        { label = "Mom told me not to talk to strangers.", next_step = nil },
      },
    },
    {
      question = "That name ... could it be? I know a guy with that name...",
      answers = {
        { label = "Never met you before.", next_step = 4 },
        { label = "I'm not sure what you mean.", next_step = nil },

      },
    },
    {
      question = "My name is Sumphore, nice to meet you.",
      answers = {
        { label = "Nice to meet you, Sumphore.", next_step = 5, on_select = function()
          Context.have_met_sumphore = true
        end },
      },
    },
    {
      question = "You're a good guy, I can tell. You abide by the rules. Life would be so much easier if more people were like you ...",
      answers = {
        { label = "Thanks, I try my best.", next_step = nil },
      },
    },
  },
})