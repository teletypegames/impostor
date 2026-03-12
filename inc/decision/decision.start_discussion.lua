Decision.register({
  id = "start_discussion",
  label = function()
    if Context.day_count >= 3 then
      return "Talk to Sumphore"
    end
    return "Talk to the homeless guy"
  end,
  handle = function()
    if Context.day_count < 3 then
      Discussion.start("homeless_guy", "game")
    end
    if Context.day_count >= 3 then
      Discussion.start("sumphore_day_3", "game")
      return
    end
  end,
})
