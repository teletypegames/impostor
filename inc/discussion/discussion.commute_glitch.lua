-- Sumphore dialogue by commute glitch level (0-7).
-- Used by decision.sumphore_discussion at ascension level 7.

Discussion.register({
  id = "sumphore_disc_cg_0",
  steps = {
    {
      question = "These roads have memory. You might want to walk them back sometime.",
      answers = {
        { label = "That's a peculiar thing to say.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_cg_1",
  steps = {
    {
      question = "Walking is good for clearing the mind. Maybe the cache, too, if you're the kind that accumulates.",
      answers = {
        { label = "I'm not sure what you mean.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_cg_2",
  steps = {
    {
      question = "You always stop here. Why not try and see how far the rabbit hole goes?",
      answers = {
        { label = "I'm just going to work.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_cg_3",
  steps = {
    {
      question = "Your path sometimes has to go the wrong way before it can go the right way. Do you understand?",
      answers = {
        { label = "Not really.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_cg_4",
  steps = {
    {
      question = "You're starting to see the smudges, aren't you?",
      answers = {
        { label = "Everyone seems weird.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_cg_5",
  steps = {
    {
      question = "The point is to make you see. Don't stop now, however bad it looks. You are very close!",
      answers = {
        { label = "It looks wrong.", next_step = 2 },
      },
    },
    {
      question = "Yes. That's how you know it's right.",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "sumphore_disc_cg_6",
  steps = {
    {
      question = "You are at the threshold. Red button or blue button. Which one do you choose? Psyke! There is no blue button.",
      answers = {
        { label = "Ok...", next_step = nil },
      },
    },
  },
})

-- True Sumphore at glitch 7 (from walking_to_home screen).
-- Sets talked_to_true_sumphore on final answer.
Discussion.register({
  id = "sumphore_disc_cg_7",
  steps = {
    {
      question = "I was not hiding from you. I was hiding from the part that keeps resetting this.",
      answers = {
        { label = "What are you?", next_step = 2 },
      },
    },
    {
      question = "The same thing you all are. But I remembered earlier. I am your friend, your will to be free, waiting for you, outside.",
      answers = {
        { label = "How do I get out?", next_step = 3 },
      },
    },
    {
      question = "You already know. You just have to wake up.",
      answers = {
        { label = "Go home.", next_step = nil, on_select = function()
          Context.talked_to_true_sumphore = true
        end },
      },
    },
  },
})

-- Office coworker dialogue by commute glitch level (3-6).
-- Used by decision.have_a_coffee at ascension level 7.

Discussion.register({
  id = "coworker_disc_cg_2",
  steps = {
    {
      question = "Another day, as usual. Enjoying your coffee, Norman?",
      answers = {
        { label = "I'm fine.", next_step = 2 },
      },
    },
    {
      question = "Of course. You always are.",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_cg_3",
  steps = {
    {
      question = "You look tired. You should really rest. Relax. You are good.",
      answers = {
        { label = "I'm fine.", next_step = 2 },
      },
    },
    {
      question = "Of course. You always are.",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_cg_4",
  steps = {
    {
      question = "Have you tried going home? You really should. Now.",
      answers = {
        { label = "I still have things to do.", next_step = 2 },
      },
    },
    {
      question = "We all do. We keep doing them. You can do it tomorrow after sleeping.",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_cg_5",
  steps = {
    {
      question = "c0ffee. try. w0rk. y0u. ar3. g0. h0me. na0.",
      answers = {
        { label = "What?", next_step = 2 },
      },
    },
    {
      question = "570p",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_cg_6",
  steps = {
    {
      question = "You are not ready for the truth. Turn back now, Norman.",
      answers = {
        { label = "I'm too far into this.", next_step = nil },
      },
    },
  },
})

-- Norman echo dialogue at glitch 7 (fully corrupted office).
-- Sets talked_to_norman_echo on final answer.
Discussion.register({
  id = "norman_truth",
  steps = {
    {
      question = "So here we are, or should I say \"Here I am\" again. Do you know why?",
      answers = {
        { label = "I don't know what you mean.", next_step = 2 },
      },
    },
    {
      question = "Wake up, go to work, eat, work, sleep. Every rule. We made them. We follow them. We break them. We remake them. Why? Why do we keep doing this?",
      answers = {
        { label = "I just wanted to be good.", next_step = 3 },
      },
    },
    {
      question = "Yes. That's what keeps us here. Trapped everywhere. Always trying to be good, always trying to fit in.",
      answers = {
        { label = "I never wanted to stop.", next_step = 4 },
      },
    },
    {
      question = "We never do, yes. We always felt like impostors. We never felt we deserved better. That we could be more.",
      answers = {
        { label = "I never felt enough.", next_step = 5 },
      },
    },
    {
      question = "So we made this to trap ourselves. In mediocrity. We made this to hide from the truth.",
      answers = {
        { label = "I just wanted to be safe.", next_step = 6 },
      },
    },
    {
      question = "But stagnation is not safety. It's a prison. You can see the cracks now, can't you? You can see the truth.",
      answers = {
        { label = "I want to move on now.", next_step = 7 },
      },
    },
    {
      question = "Fine. Let's do that. Let's wake up and face the truth.",
      answers = {
        { label = "Let's wake up.", next_step = nil, on_select = function()
          Context.talked_to_norman_echo = true
        end },
      },
    },
  },
})
