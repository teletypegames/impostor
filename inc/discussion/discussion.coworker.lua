Discussion.register({
  id = "coworker_disc_0",
  on_end = Meter.apply_coworker_discussion_reward,
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
  on_end = Meter.apply_coworker_discussion_reward,
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
  on_end = Meter.apply_coworker_discussion_reward,
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
  on_end = Meter.apply_coworker_discussion_reward,
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
  on_end = Meter.apply_coworker_discussion_reward,
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
  on_end = Meter.apply_coworker_discussion_reward,
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
  on_end = Meter.apply_coworker_discussion_reward,
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

Discussion.register({
  id = "coworker_disc_4",
  on_end = Meter.apply_coworker_discussion_reward,
  steps = {
    {
      question = "Normaaan! Same spot, same cup, same time. You're like a statue that drinks coffee!",
      answers = {
        { label = "I'm a person.", next_step = 2 },
        { label = "Yep. Still here.", next_step = 2 },
      },
    },
    {
      question = "I love that about you! So reliable! If the coffee machine breaks we still have Norman!",
      answers = {
        { label = "Please don't.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_4",
  on_end = Meter.apply_coworker_discussion_reward,
  steps = {
    {
      question = "Norman, you were seriously locked in today. What on earth were you building?",
      answers = {
        { label = "Just some things.", next_step = 2 },
        { label = "Nothing important.", next_step = 2 },
      },
    },
    {
      question = "So modest! I heard the seniors literally whispering your name!",
      answers = {
        { label = "Concerning.", next_step = 3 },
        { label = "That's... fine.", next_step = 3 },
      },
    },
    {
      question = "You should celebrate! Coffee's on me tomorrow!",
      answers = {
        { label = "Already have one.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_5",
  on_end = Meter.apply_coworker_discussion_reward,
  steps = {
    {
      question = "Morning! Funny thought — I feel like we do this exact same thing every single day!",
      answers = {
        { label = "We do.", next_step = 2 },
        { label = "Yes. We do.", next_step = 2 },
      },
    },
    {
      question = "Ha! Routine is such a comfort, right? Same coffee, same smile, same everything!",
      answers = {
        { label = "Sure. Very comforting.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_5",
  on_end = Meter.apply_coworker_discussion_reward,
  steps = {
    {
      question = "Norman! You were staring right THROUGH your screen today. What was going on up there?",
      answers = {
        { label = "Coffee was cold.", next_step = 2 },
        { label = "Maybe I was.", next_step = 2 },
      },
    },
    {
      question = "Were you meditating? Or doing your intense bug-stare thing?",
      answers = {
        { label = "Something like that.", next_step = 3 },
        { label = "Bug stare thing?", next_step = 3 },
      },
    },
    {
      question = "You're always somewhere else in your head, Norman. Must be nice up there!",
      answers = {
        { label = "It's complicated.", next_step = nil },
      },
    },
  },
})

local function _glitch_on_end()
  Meter.apply_coworker_discussion_reward()
  Context.glitch_conversation_count = Context.glitch_conversation_count + 1
  Glitch.hide()
end

Discussion.register({
  id = "coworker_disc_asc_6_1",
  on_end = _glitch_on_end,
  steps = {
    {
      question = "Hey Norman, good morning! Good morning! Good morning! ...Sorry. I don't know why I keep saying that.",
      answers = {
        { label = "Are you feeling ok?", next_step = 2 },
      },
    },
    {
      question = "Good morning. Good morning. Good— I can't stop. Why can't I stop?",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_6_2",
  on_end = _glitch_on_end,
  steps = {
    {
      question = "Hey... Marcus. How's it going?",
      answers = {
        { label = "My name is Norman.", next_step = 2 },
      },
    },
    {
      question = "Right, sorry. Marcus. You look tired today.",
      answers = {
        { label = "Norman. It's Norman.", next_step = 3 },
      },
    },
    {
      question = "Sure, sure. You should get some rest, Marcus.",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_6_3",
  on_end = _glitch_on_end,
  steps = {
    {
      question = "We've had this conversation before, haven't we? Exact same words. Same coffee. Same spot.",
      answers = {
        { label = "I don't think so.", next_step = 2 },
        { label = "Maybe.", next_step = 2 },
      },
    },
    {
      question = "Every day. I always say the same thing and you always say that. It's very strange.",
      answers = {
        { label = "That's just routine.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_6_4",
  on_end = _glitch_on_end,
  steps = {
    {
      question = "Do you ever look at the walls here? Really look? Sometimes they don't feel... solid.",
      answers = {
        { label = "They're just walls.", next_step = 2 },
        { label = "I know what you mean.", next_step = 2 },
      },
    },
    {
      question = "Like they're only there because we expect them to be. Like set dressing. Does any of this feel load-bearing to you?",
      answers = {
        { label = "I need more coffee.", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_6_5",
  on_end = _glitch_on_end,
  steps = {
    {
      question = "Norman, I'm not supposed to— I mean. How are you doing today?",
      answers = {
        { label = "What weren't you supposed to say?", next_step = 2 },
      },
    },
    {
      question = "...",
      answers = {
        { label = "Hello?", next_step = nil },
      },
    },
  },
})

Discussion.register({
  id = "coworker_disc_asc_6_6",
  on_end = _glitch_on_end,
  steps = {
    {
      question = "Forget it. You won't remember this conversation anyway. None of us do.",
      answers = {
        { label = "What do you mean?", next_step = 2 },
        { label = "That's a strange thing to say.", next_step = 2 },
      },
    },
    {
      question = "Tomorrow you'll come back and it'll be like this never happened. Same coffee. Same office. Same Norman.",
      answers = {
        { label = "...", next_step = nil },
      },
    },
  },
})