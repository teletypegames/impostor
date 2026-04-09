Decision.register({
  id = "have_a_coffee",
  label = "Have a Coffee",
  handle = function()
    local level = Ascension.get_level()
    local disc_id = "coworker_disc_0"
    -- TODO: Add more discussions for levels above 3
    if level >= 1 and level <= 3 then
      local suffix = Context.have_done_work_today and ("_asc_" .. level) or ("_" .. level)
      disc_id = "coworker_disc" .. suffix
    end
    Discussion.start(disc_id, "game")
  end,
})