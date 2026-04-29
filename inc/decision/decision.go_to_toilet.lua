local function apply_home_toilet_meter_delta()
  local max = Meter.get_max()
  Meter.add("bm", -math.floor(max * 0.15))
  Meter.add("ism", -math.floor(max * 0.10))
  Meter.add("wpm", math.floor(max * 0.05))
end

Decision.register({
  id = "go_to_toilet",
  label = "Go to Toilet",
  handle = function()
    if not Context.have_done_work_today and not Context.toilet_meters_today_morning then
      apply_home_toilet_meter_delta()
      Context.toilet_meters_today_morning = true
    elseif Context.have_been_to_office
      and Context.have_done_work_today
      and not Context.toilet_meters_today_evening then
      apply_home_toilet_meter_delta()
      Context.toilet_meters_today_evening = true
    end
    Util.go_to_screen_by_id("toilet")
  end,
})
