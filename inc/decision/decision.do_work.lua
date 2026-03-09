Decision.register({
  id = "do_work",
  label = "Do Work",
  handle = function()
    Meter.hide()
    Util.go_to_screen_by_id("work")
    MinigameDDRWindow.start("game", nil, {
      on_win = function()
        Meter.show()
        Util.go_to_screen_by_id("office")
        Window.set_current("game")
      end,
    })
  end,
})
