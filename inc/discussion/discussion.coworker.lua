Discussion.register({
  id = "coworker_disc_0",
  steps = {
    {
      question = "Good morning Normal, enjoying your coffee as usual, huh?",
      answers = {
        { label = "The name is Norman, not Normal", next_step = 2 },
      },
    },
    {
      question = "Can't work without some good coffee, no? ",
      answers = {
        { label = "Mhmm", next_step = nil },
      },
    },
  },
});

Discussion.register({
  id = "coworker_disc_1",
  steps = {
    {
      question = "Norman, you look confused, what's up?",
      answers = {
        { label = "Just some bugs I noticed", next_step = 2 },
      },
    },
    {
      question = "Your coffee also seems whiter than usual!",
      answers = {
        { label = "I feel like latte today", next_step = nil },
      },
    },
  },
});

Discussion.register({
  id = "coworker_disc_asc_1",
  steps = {
    {
      question = "Normann you look weird and unfocused. You are usually locked in and not like this, what's up?",
      answers = {
        { label = "Some bugs I noticed, maybe...", next_step = 2 },
      },
    },
    {
      question = "Are you fixing bugs nobody noticed before?",
      answers = {
        { label = "Maybe", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_2",
  steps = {
    {
      question = "Hey Norman, do you have new socks on? That's a weird color!",
      answers = {
        { label = "Huh? True ...", next_step = 2 },
      },
    },
    {
      question = "You look strange today, Normal, you put your tie on backwards, is everything ok? ",
      answers = {
        { label = "Get it right, Norman ... NORMAN!", next_step = 3 },
      },
    },
    {
      question = "Yo Normann, text goes from left to right, not right to left, these parts!",
      answers = {
        { label = "Uhm...why?", next_step = nil },
      },
    },
  },
});


Discussion.register({
  id = "coworker_disc_asc_2",
  steps = {
    {
      question = "Normann, are you ok? You were doing weird things while typing?",
      answers = {
        { label = "Naw", next_step = 2 },
      },
    },
    {
      question = "Oh, it's ok, I'm not wathcing you. Noone really is. *giggle*",
      answers = {
        { label = "Huh ?", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_3",
  steps = {
    {
      question = "You look so happy, did you catch a bull or something?",
      answers = {
        { label =  "What do you mean?", next_step = 2 },
      },
    },
    {
      question = "Most people catch colds! You are so strange!",
      answers = {
        { label =  "An apple a day keeps the cold away", next_step = 3 },
      },
    },
    {
      question = "You look like you don't really want to work today, are you ok?",
      answers = {
        { label =  "Oh brother", next_step = nil },
      },
    },
  },
})
Discussion.register({
  id = "coworker_disc_asc_3",
  steps = {
    {
      question = "Normal, you should take a break, you don't live up to your name today",
      answers = {
        { label =  "Norman is the name ...", next_step = 2 },
      },
    },
    {
      question = "You aren't as enthusiastic as you were before!",
      answers = {
        { label =  "Burnout comes for everyone", next_step = nil },
      },
    },
  },
})