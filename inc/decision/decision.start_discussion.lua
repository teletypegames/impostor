Decision.register({
  id = "start_discussion",
  label = function()
    if Context.have_met_sumphore then
      return "Talk to Sumphore"
    end
    return "Talk to the homeless guy"
  end,
  handle = function()
    if not Context.have_met_sumphore then
      Discussion.start("homeless_guy", "game")
    elseif Ascension.get_level() == 0 then
      Discussion.start("homeless_guy", "game", 4)
    else
      Discussion.start("sumphore_day_3", "game")
    end
  end,
})
