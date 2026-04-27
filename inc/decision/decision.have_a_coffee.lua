Decision.register({
  id = "have_a_coffee",
  label = "Have a Coffee",
  handle = function()
    local level = Ascension.get_level()
    local disc_id = "coworker_disc_0"
    if level >= 1 and level <= 5 then
      local suffix = Context.have_done_work_today and ("_asc_" .. level) or ("_" .. level)
      disc_id = "coworker_disc" .. suffix
    elseif level == 6 then
      if not Context.glitch_conversation_done_today and Context.glitch_conversation_count < 6 then
        Context.glitch_conversation_done_today = true
        Context.glitch_conversation_count = Context.glitch_conversation_count + 1
        Glitch.show()
        Discussion.start("coworker_disc_asc_6_" .. Context.glitch_conversation_count, "game")
        return
      end
    end
    Discussion.start(disc_id, "game")
  end,
})