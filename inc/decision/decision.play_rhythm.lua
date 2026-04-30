Decision.register({
  id = "play_rhythm",
  label = "Play Rhythm Game",
  handle = function()
    Meter.hide()
    local wpm_at_start = Context.meters and Context.meters.wpm or 0
    local rhythm_config = {
      focus_center_x = (Config.screen.width / 2) - 22,
      focus_center_y = (Config.screen.height / 2) - 18,
      focus_initial_radius = 0,
      on_win = function()
        if wpm_at_start > 900 then
          Meter.add("ism", math.floor(Meter.get_max() * 0.05))
          Meter.add("bm", math.floor(Meter.get_max() * 0.05))
        end
        Meter.show()
        Window.set_current("game")
      end,
    }
    if wpm_at_start < 100 then
      rhythm_config.line_speed = 0.025
      rhythm_config.initial_target_width = 0.2
    end
    MinigameRhythmWindow.start("game", rhythm_config)
  end,
})
