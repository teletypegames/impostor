Decision.register({
  id = "do_work",
  label = "Do Work",
  handle = function()
    Meter.hide()
    Util.go_to_screen_by_id("work")
    MinigameDDRWindow.start("game", nil, {
      on_win = function()
        if (Context.minigame_ddr.special_condition_met and Context.ascension.level == 1) then
          Context.should_ascend = true
          Context.minigame_ddr.special_condition_met = false
        end
        Meter.show()
        Util.go_to_screen_by_id("office")
        Window.set_current("game")
        Context.have_done_work_today = true
      end,
    })
  end,
})
