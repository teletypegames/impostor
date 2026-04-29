Decision.register({
  id = "do_work",
  label = "Do Work",
  condition = function()
    return (not CommuteGlitch.is_active()) or (CommuteGlitch.is_active() and CommuteGlitch.get_level() <= 4)
  end,
  handle = function()
    Meter.hide()
    Util.go_to_screen_by_id("work")

    local modes_for_ascension_levels = {}
    modes_for_ascension_levels[0] = "normal"
    modes_for_ascension_levels[1] = "only_special"
    modes_for_ascension_levels[2] = "only_left"
    modes_for_ascension_levels[3] = "only_nothing"
    modes_for_ascension_levels[4] = "normal"

    local ddr_config = {
      on_win = function(game_context)
        if (game_context.special_mode_condition and Context.ascension.level == 1) then
          Context.should_ascend = true
        elseif (game_context.special_mode_condition and Context.ascension.level == 2) then
          Context.should_ascend = true
        elseif (game_context.special_mode_condition and Context.ascension.level == 3) then
          Context.should_ascend = true
        end

        Meter.show()
        Util.go_to_screen_by_id("office")
        Window.set_current("game")
        Context.have_done_work_today = true
      end,
      special_mode = modes_for_ascension_levels[Ascension.get_level()] or "normal"
    }
    if Context.meters and Context.meters.wpm < 100 then
      ddr_config.arrow_fall_speed = 2.5
      ddr_config.arrow_spawn_interval = 30
    end
    MinigameDDRWindow.start("game", "generated", ddr_config)
  end,
})
