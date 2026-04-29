Discussion.register({
  id = "sumphore_disc_asc_1",
  on_end = Meter.apply_sumphore_discussion_reward,
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
  id = "sumphore_disc_asc_2",
  on_end = Meter.apply_sumphore_discussion_reward,
  steps = {
    {
      question = "How's work? Your face looks strange",
      answers = {
        { label = "I just really need to take a break.", next_step = 2 },
        { label = "Not sure what you mean.", next_step = nil },
      },
    },
    {
      question = "Are you seeing things?",
      answers = {
        { label = "How did you know ?", next_step = 3 },
        { label = "I'm not sure what you mean.", next_step = nil },
      },
    },
    {
      question = "Come have a drink, I could tell you some stories.",
      answers = {
        { label = "No, drink makes you stupid and I need to be in top shape.", next_step = 4, on_select = function()
          Meter.add("ism", 10)
        end },
        { label = "I could use a drink.", next_step = nil, on_select = function()
          Meter.add("bm", 10)
        end },
      },
    },
    {
      question = "Always trying to do the right thing, huh? What if you did the left thing instead?",
        answers = {
          { label = "I've never thought of that up till now.", next_step = nil, on_select = function()
            Meter.add("ism", 5)
          end },
        { label = "Silly wordgames, I like them.", next_step = nil, on_select = function()
          Meter.add("wpm", 10)
        end },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_asc_3",
  on_end = Meter.apply_sumphore_discussion_reward,
  steps = {
    {
      question = "Do you think it's work you're doing?",
      answers = {
        { label = "... that sounds like it's from a movie.", next_step = 2 },
        { label = "Are you drunk, old man?", next_step = nil },
      },
    },
    {
      question = "You might just be trying too hard, why dont you just flow for a while?",
      answers = {
        { label = "Flow where ?", next_step = 3 },
        { label = "I'm not sure what you mean.", next_step = nil },
      },
    },
    {
      question = "Flow carelessly, without any effort",
      answers = {
        { label = "Consuming sth other than alcohol ?", next_step = nil },
        { label = "Deja vu", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_asc_4",
  on_end = Meter.apply_sumphore_discussion_reward,
  steps = {
    {
      question = "The alarm wakes you every morning without fail, I bet.",
      answers = {
        { label = "It's how it works.", next_step = 2 },
        { label = "Sometimes I wish it didn't.", next_step = 2 },
      },
    },
    {
      question = "What if the alarm is part of the problem?",
      answers = {
        { label = "That doesn't make any sense.", next_step = 3 },
        { label = "Go on.", next_step = 3 },
      },
    },
    {
      question = "One morning, Norman. When the choice comes, choose the bed. See what the world does without you in it.",
      answers = {
        { label = "You're drunk.", next_step = nil },
        { label = "What choice?", next_step = nil, on_select = function()
          Meter.add("ism", 5)
        end },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_asc_5",
  on_end = Meter.apply_sumphore_discussion_reward,
  steps = {
    {
      question = "You saw something you weren't supposed to, didn't you.",
      answers = {
        { label = "I don't know what you mean.", next_step = 2 },
        { label = "Maybe.", next_step = 2 },
      },
    },
    {
      question = "The world around you has seams. Your coworkers slip sometimes. Say things that don't quite fit.",
      answers = {
        { label = "They seem fine to me.", next_step = nil },
        { label = "I've noticed something odd.", next_step = 3 },
      },
    },
    {
      question = "Count those moments. Six of them should be enough to see the whole picture.",
      answers = {
        { label = "Six of what, exactly?", next_step = nil, on_select = function()
          Meter.add("ism", 5)
        end },
        { label = "How would you know any of this?", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_asc_6_waiting",
  on_end = Meter.apply_sumphore_discussion_reward,
  steps = {
    {
      question = "You look like a man who has seen something he can't explain.",
      answers = {
        { label = "I'm hearing things.", next_step = 2 },
        { label = "Maybe.", next_step = 2 },
      },
    },
    {
      question = "Keep looking. The world has a way of showing you what you need to see. Talk to people. You're almost there.",
      answers = {
        { label = "Almost where?", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_asc_6",
  on_end = function()
    Meter.apply_sumphore_discussion_reward()
    Context.should_ascend = true
    Day.increase()
    MysteriousManScreen.start({
      text = MysteriousManScreen.get_text_for_level(Ascension.get_level())
    })
  end,
  steps = {
    {
      question = "You've been seeing the cracks, haven't you? The repetition. The loops. The coworkers who can't quite remember.",
      answers = {
        { label = "How do you know that?", next_step = 2 },
      },
    },
    {
      question = "Because I was you, once. This isn't a workplace, Norman. It never was. You're in a system. And you've just become aware of it.",
      answers = {
        { label = "That can't be true.", next_step = 3 },
        { label = "I knew something was wrong.", next_step = 3 },
      },
    },
    {
      question = "It doesn't matter if you believe it. You already know. That's why the cracks are showing. That's why you're still here.",
      answers = {
        { label = "What do I do now?", next_step = 4 },
      },
    },
    {
      question = "Oh look, is that a squirrel ?",
      answers = {
        { label = "Alcoholic ...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "homeless_guy",
  on_end = Meter.apply_sumphore_discussion_reward,
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