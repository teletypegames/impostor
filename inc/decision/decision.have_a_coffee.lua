Decision.register({
  id = "have_a_coffee",
  label = "Have a Coffee",
  handle = function()
    local level = Ascension.get_level()
    local disc_id = "coworker_disc_0"
    if level >= 1 and level <= 3 then
      local suffix = Context.have_done_work_today and ("_asc_" .. level) or ("_" .. level)
      disc_id = "coworker_disc" .. suffix
    elseif level == 7 then
      local g = CommuteGlitch.get_level()
      if g >= 7 then
        disc_id = "coworker_disc_cg_7"
      else
        disc_id = "coworker_disc_cg_" .. math.max(3, math.min(g, 6))
      end
    end
    Discussion.start(disc_id, "game")
  end,
})