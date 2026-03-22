Decision.register({
  id = "sumphore_discussion",
  label = function()
    if Context.have_met_sumphore then
      return "Talk to Sumphore"
    end
    return "Talk to the homeless guy"
  end,
  handle = function()
    if not Context.have_met_sumphore then
      Discussion.start("homeless_guy", "game")
      return
    end
    local level = Ascension.get_level()

    -- TODO: Add more discussions for levels above 3
    if level >= 1 and level <= 3 then
      Discussion.start("sumphore_disc_asc_" .. level, "game")
    else
      Discussion.start("homeless_guy", "game", 4)
    end
  end,
})
