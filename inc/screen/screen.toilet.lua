Screen.register({
  id = "toilet",
  name = "Toilet",
  decisions = {
    "go_to_home",
  },
  background = "bedroom",
  init = function()
    Audio.music_play_mystery()
    Context.stat_screen_active = true
    Meter.hide()
    local cx = Config.screen.width * 0.75
    local cy = Config.screen.height * 0.75
    Focus.start_driven(cx, cy)
    Focus.set_percentage(0.15)
  end,
  update = function()
    if not Context.stat_screen_active then return end
    if Input.select() or Input.select() then
      Focus.stop()
      Context.stat_screen_active = false
      Meter.show()
      Util.go_to_screen_by_id("home")
    end
  end,
  draw = function()
    if not Context.stat_screen_active then return end

    local sw = Config.screen.width
    local cx = sw / 2
    local norman_x = math.floor(sw * 0.75)
    local norman_y = math.floor(Config.screen.height * 0.75)
    local bar_w = math.floor(sw * 0.75)
    local bar_x = math.floor((sw - bar_w) / 2)
    local bar_h = 4

    Sprite.draw_at("norman", norman_x, norman_y)

    Print.text_center("day " .. Context.day_count, cx, 10, Config.colors.white)

    local narrative = "reflecting on my past and present\n...\nboth eventually flushed."
    local wrapped = UI.word_wrap(narrative, 38)
    local text_y = 24
    for _, line in ipairs(wrapped) do
      Print.text_center(line, cx, text_y, Config.colors.light_grey)
      text_y = text_y + 8
    end

    local m = Context.meters
    local max_val = Meter.get_max()
    local decay_pct = Meter.get_decay_percentage()
    local decay_text = string.format("-%d%%", decay_pct)
    local combo_mult = Meter.get_combo_multiplier()
    local combo_pct = math.floor((combo_mult - 1) * 100)
    local mult_text = string.format("+%d%%", combo_pct)
    local meter_start_y = text_y + 10

    local meter_list = {
      { key = "wpm", label = "Work Productivity Meter" },
      { key = "ism", label = "Impostor Syndrome Meter" },
      { key = "bm",  label = "Burnout Meter" },
    }

    for i, meter in ipairs(meter_list) do
      local y = meter_start_y + (i - 1) * 20

      Print.text_center(meter.label, cx, y, Config.colors.white)

      local bar_y = y + 8
      local fill_w = math.max(0, math.floor((m[meter.key] / max_val) * bar_w))
      rect(bar_x, bar_y, bar_w, bar_h, Meter.COLOR_BG)
      if fill_w > 0 then
        rect(bar_x, bar_y, fill_w, bar_h, Config.colors.blue)
      end

      local decay_w = print(decay_text, 0, -6, 0, false, 1)
      Print.text(decay_text, bar_x - decay_w - 4, bar_y, Config.colors.light_blue)
      Print.text(mult_text, bar_x + bar_w + 4, bar_y, Config.colors.light_blue)
    end

    if Ascension.get_level() > 0 then
      local asc_y = meter_start_y + #meter_list * 20
      local asc_letter_y = asc_y + 10
      local asc_spacing = 8
      local asc_total_w = Ascension.get_level() * asc_spacing
      local asc_x = math.floor((sw - asc_total_w) / 2)
      Ascension.draw(asc_x, asc_letter_y, { spacing = asc_spacing })
    end
  end,
})
