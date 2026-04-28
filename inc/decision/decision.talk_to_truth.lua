Decision.register({
  id = "talk_to_truth",
  label = function()
    return "Talk to ????"
  end,
  handle = function()
    Discussion.start("norman_truth", "game")
  end,
})
