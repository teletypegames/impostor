Decision.register({
  id = "go_to_home",
  label = "Go to Home",
  condition = function()
    return Context.have_been_to_office and Context.have_done_work_today
  end,
  handle = function()
    Util.go_to_screen_by_id("home")
  end,
})
