Decision.register({
  id = "sumphore_discussion",
  label = function()
    if Context.have_met_sumphore then
      return "Talk to Sumphore"
    end
    return "Talk to the homeless guy"
  end,
  condition = function()
    return Ascension.get_level() < 8
  end,
  handle = function()
    local level = Ascension.get_level()

    if level == 0 then
      if Context.have_met_sumphore then
        Discussion.start("homeless_guy", "game", 4)
      else
        Discussion.start("homeless_guy", "game")
      end
      return
    end

    if not Context.have_met_sumphore then
      Discussion.start("homeless_guy", "game")
      return
    end

    if level >= 1 and level <= 5 then
      Discussion.start("sumphore_disc_asc_" .. level, "game")
    elseif level == 6 then
      if Context.glitch_conversation_count >= 6 then
        Discussion.start("sumphore_disc_asc_6", "game")
      else
        Discussion.start("sumphore_disc_asc_6_waiting", "game")
      end
    elseif level == 7 then
      local g = math.min(CommuteGlitch.get_level(), 7)
      Discussion.start("sumphore_disc_cg_" .. g, "game")
    else
      Discussion.start("sumphore_disc_asc_" .. level, "game")
    end
  end,
})
