--- @section MysteriousManScreen

local STATE_TEXT = "text"
local STATE_DAY = "day"
local STATE_CHOICE = "choice"

local ASC_01_TEXT = [[
  Normann seems to be in line,
  ...
  and stays seeking for oxes
  ...
  within the confines.
  ...
  Very good.
]]

local ASC_12_TEXT = [[
  We have a problem!
  ...
  Normann formed his first thought.
  ...
  He saw the tracks.
]]
local ASC_23_TEXT = [[
  Not good, not terrible.
  ...
  Normann caught his glimpse
  ...
  of another way
  ...
  - quite literally -
  ...
  if this continues,
  ...
  we will lose control.
]]
local ASC_34_TEXT = [[
  There is no turning back now for Norman.
  ...
  He caught on.
  ...
  I hoped it would never come to this...
]]

--[[ Norman speaks for the first time during MM screen ]]
local ASC_45_TEXT = [[
  Wait, who are you?
  ...
  *silence*
  ...
  Why am I seeing this?
  ...
  *silence*
  ...
]]

local ascension_texts = {
  [1] = ASC_01_TEXT,
  [2] = ASC_12_TEXT,
  [3] = ASC_23_TEXT,
  [4] = ASC_34_TEXT,
  [5] = ASC_45_TEXT,
}

function MysteriousManScreen.get_text_for_level(level)
  return ascension_texts[level] or ASC_01_TEXT
end

local state = STATE_TEXT
local text_y = Config.screen.height
local text_speed = 0.2
local day_timer = 0
local day_display_frames = 120
local text_done = false
local text_done_timer = 0
local TEXT_DONE_HOLD_FRAMES = 120
local selected_choice = 1
local text = ASC_01_TEXT
local day_text_override = nil
local on_text_complete = nil
local show_mysterious_screen = true
local trigger_flash_on_wake = false

local function draw_mysterious_man_background()
    local img_values = {0,1,0,1,0,1,0,1,0,1,0,1,2,1,4,1,0,2,4,1,0,2,4,1,0,2,4,1,0,2,4,1,0,2,4,2,1,4,2,1,4,1,0,2,4,1,0,1,4,2,1,2,1,0,1,2,4,1,0,2,4,2,1,0,1,2,1,2,1,0,1,4,1,0,2,4,2,0,1,0,1,0,1,2,4,1,0,2,4,2,1,0,1,4,1,0,2,4,2,0,1,2,4,1,0,2,4,1,0,1,0,4,1,0,2,4,0,1,0,1,0,1,0,4,1,0,2,4,0,1,4,1,0,2,4,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,0,4,1,0,2,4,1,0,1,0,4,1,0,2,4,1,0,1,0,1,4,1,0,2,4,1,2,1,0,1,4,1,0,2,4,2,1,0,1,2,4,1,0,2,4,2,1,0,1,2,4,1,0,2,4,1,2,0,1,0,1,0,1,2,1,2,1,0,2,4,1,0,2,4,0,1,0,1,2,1,0,1,0,2,4,1,0,2,4,2,1,0,1,0,1,4,1,0,2,4,2,1,0,1,0,2,4,2,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,4,1,0,2,4,2,1,0,1,0,2,0,1,4,1,0,2,4,1,0,1,0,1,2,0,1,4,1,0,2,4,2,1,0,1,0,1,4,1,0,2,4,2,1,0,2,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,4,1,0,2,4,1,0,1,0,1,4,1,0,2,4,0,1,0,1,0,1,0,1,4,1,0,2,4,0,1,0,1,0,1,4,1,0,2,4,1,0,1,0,2,4,1,0,2,4,2,1,0,1,0,1,0,1,2,4,1,0,2,4,2,1,0,1,0,1,0,1,2,4,1,0,2,4,2,1,0,1,0,1,0,1,4,1,0,2,4,2,4,1,0,1,0,1,0,1,0,1,0,1,2,1,4,2,4,1,0,2,4,2,1,0,1,0,1,0,1,0,1,0,1,2,1,4,2,4,1,0,2,4,2,1,2,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,2,4,1,0,2,4,1,2,1,0,1,0,1,0,1,0,1,0,1,0,1,2,1,4,1,0,2,4,2,1,2,1,0,1,0,1,0,1,0,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,2,1,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,2,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,2,0,1,0,1,0,4,1,0,2,4,0,1,0,1,0,2,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,0,2,0,1,4,1,0,2,4,0,1,0,1,0,1,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,0,1,0,1,4,1,0,2,4,1,0,2,0,1,0,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,0,1,2,4,1,0,2,4,1,0,1,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,0,4,1,0,2,4,1,0,2,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,4,1,0,2,4,1,0,1,0,1,2,4,1,0,2,4,1,0,1,0,1,2,4,1,0,2,4,2,1,0,1,0,1,2,4,1,0,2,4,2,1,0,1,0,1,2,4,1,0,2,4,2,0,1,0,1,4,1,0,2,4,2,0,1,0,1,0,4,1,0,2,4,1,0,1,0,1,0,1,4,1,0,2,4,0,1,0,1,4,2,1,0,1,2,1,2,1,0,1,2,1,2,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,2,0,1,2,0,1,0,2,1,0,1,2,0,1,0,2,0,1,0,1,0,1,2,0,1,0,1,0,1,0,2,0,1,0,1,0,1,0,2,0,1,0,1,0,2,1,0,1,0,1,2,0,1,0,2,0,2,1,0,1,2,0,2,1,0,1,0,1,2,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,2,0,2,1,0,1,0,1,0,1,0,1,0,2,1,0,1,2,0,1,0,1,2,1,0,1,0,1,0,1,0,2,1,0,2,0,1,0,1,0,2,0,1,0,1,0,2,0,1,0,2,0,1,0,1,0,2,1,0,1,2,0,1,0,1,0,1,0,1,0,2,0,1,0,2,0,1,0,2,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0}

    local img_runs = {1480,1,151,1,87,1,1,150,1,1,86,1,2,148,1,2,87,2,148,2,88,2,148,2,88,2,148,2,88,2,148,2,88,2,70,1,2,9,1,2,63,2,88,2,69,1,2,3,5,1,1,1,1,1,1,1,61,2,88,2,68,1,1,3,1,2,1,3,2,3,2,61,2,88,2,68,1,6,1,4,1,5,1,1,60,2,88,2,67,1,1,17,2,60,2,88,2,67,1,19,1,1,59,2,88,2,67,1,19,1,1,59,2,88,2,67,4,1,11,1,1,1,3,59,2,88,2,67,21,1,59,2,88,2,67,21,1,59,2,88,2,66,1,21,2,58,2,88,2,66,1,21,1,1,58,2,88,2,66,4,17,2,1,58,2,88,2,65,2,5,1,15,2,58,2,88,2,63,1,1,2,22,4,55,2,88,2,57,2,2,34,2,2,49,2,88,2,55,1,2,39,3,1,47,2,88,2,55,5,1,3,2,2,1,25,1,1,1,1,1,1,1,47,2,88,2,57,1,2,1,29,1,4,1,1,1,1,49,2,88,2,59,1,2,8,15,9,2,52,2,88,2,62,2,1,1,1,24,1,1,1,54,2,88,2,66,1,22,1,58,2,88,2,66,1,21,1,59,2,88,2,66,2,20,1,59,2,88,2,65,3,20,2,58,2,88,2,63,2,2,1,20,1,1,2,56,2,88,2,61,2,4,1,20,1,2,2,55,2,88,2,59,1,1,6,1,19,1,4,2,54,2,88,2,58,2,7,2,17,1,1,6,2,52,3,87,2,56,1,2,9,1,26,2,51,3,87,2,55,1,1,40,1,50,2,88,2,54,2,41,1,50,2,88,2,53,2,42,2,49,2,88,2,52,2,44,2,48,2,88,2,51,2,46,2,47,2,88,2,50,2,16,1,31,1,47,2,88,2,50,3,1,14,1,29,1,1,2,46,2,88,2,50,18,1,29,1,2,1,46,2,88,2,50,4,14,1,33,1,45,2,88,2,53,1,3,11,2,15,1,13,1,2,46,2,88,2,56,1,1,11,1,15,1,10,2,1,49,2,88,2,55,2,3,10,2,12,2,8,8,46,2,88,2,50,1,1,4,4,1,9,2,11,2,8,2,4,2,1,2,1,1,42,2,88,2,48,2,3,8,1,9,2,9,3,7,2,8,1,1,2,1,1,40,2,88,2,45,3,2,1,1,1,1,8,1,7,1,1,3,6,4,6,1,8,1,1,1,1,4,2,38,2,88,2,45,1,2,2,22,4,4,4,6,1,10,1,1,2,1,2,1,2,37,2,88,2,42,1,1,1,4,1,2,19,1,1,4,1,5,21,1,2,6,35,2,88,2,42,2,1,1,1,1,15,2,8,3,4,3,6,1,17,1,1,2,1,1,1,34,2,88,2,41,3,1,1,15,2,9,3,5,2,8,1,21,1,1,34,2,88,2,41,1,1,1,16,2,11,2,5,2,9,2,18,2,1,34,2,88,2,41,1,2,1,14,2,13,1,5,1,12,1,17,1,2,34,2,88,2,41,1,16,1,17,1,2,1,14,2,17,1,1,33,2,88,2,41,1,2,1,12,1,17,1,3,2,15,1,14,1,1,1,1,33,2,88,2,41,15,1,22,1,17,1,1,11,1,3,1,33,2,88,2,41,1,14,2,40,1,15,1,33,2,88,2,41,1,15,2,35,1,3,1,10,1,4,1,33,2,88,2,41,1,3,1,12,2,36,2,11,1,4,1,33,2,88,2,40,1,1,18,1,35,1,12,1,4,1,1,32,2,88,2,40,2,4,1,14,1,33,1,12,1,6,1,32,2,88,2,40,1,6,1,14,1,31,1,13,1,6,1,32,2,88,2,39,2,22,2,28,1,21,1,1,31,2,88,2,39,2,24,1,26,1,22,1,1,31,2,88,2,39,2,25,1,24,1,23,1,1,31,2,88,2,39,1,27,1,22,2,23,1,1,31,2,88,2,39,1,49,2,24,3,30,2,88,2,39,1,48,1,27,1,1,30,2,88,2,39,1,47,2,27,1,1,30,2,88,2,37,1,1,47,2,28,1,1,30,2,88,2,37,1,1,46,1,30,2,1,29,2,88,2,37,1,47,1,30,2,30,2,88,2,37,1,1,2,43,1,33,30,3,87,2,37,1,45,1,31,1,1,2,29,3,87,2,37,45,1,35,1,29,1,1,88,2,1,35,1,1,80,2,1,26,1,3,86,1,1,2,1,21,1,4,4,2,1,3,80,30,1,2,125,2,80,2,156,2,79,2,1,156,2,1,77,4,156,1,3,76,3,1,140,1,15,1,2,2,74,2,1,1,1,5,3,129,1,18,1,82,1,7,1,129,1,18,1,82,1,9,1,123,3,20,1,1,80,2,11,1,1,119,1,22,1,1,1,2,76,4,1,154,2,2,63,1,14,3,1,126,1,27,2,65,1,17,1,17,2,132,4,66,1,17,4,113,39,66,2,16,31,191,1,1,1,15,1,153,2,15,3,48,2,16,2,152,1,16,1,1,1,48,2,16,2,152,1,1,2,2,1,10,1,1,1,48,1,13,6,153,1,3,13,1,1,48,1,15,2,1,1,153,3,64,1,16,2,154,1,1,83,1,154,1,17,1,66,1,154,1,17,1,66,1,155,1,82,1,156,1,82,1,156,1,1,80,1,1,157,2,78,2,158,2,78,2,158,1,80,1,158,1,79,2,158,1,79,1,159,1,79,1,160,1,77,2,160,1,77,1,162,1,74,1,1,1,162,1,75,1,239,1,165,1,72,1,166,1,240,1,69,1,412,1,63,1,175,1,63,2,238,1,175,1,63,1,239,1,807}

    local val_i=0
    local run=0
    for y=0,136-1 do
        for x=0,240-1 do
            if run==0 then
                val_i=val_i+1
                run=img_runs[val_i]
            end
            run=run-1
            pix(x,y,img_values[val_i])
        end
    end
end

local choices = {
  {
    label = "Wake Up",
  },
  {
    label = "Stay in Bed",
  },
}

local function go_to_day_state()
  if on_text_complete then
    on_text_complete()
    on_text_complete = nil
  end
  if Context.game.current_screen ~= "mysterious_man" then
    return
  end
  state = STATE_DAY
  day_timer = day_display_frames
end

local function wake_up()
  Context.home_norman_visible = false
  Util.go_to_screen_by_id("home")
  MinigameButtonMashWindow.start("game", {
    focus_center_x = (Config.screen.width / 2) - 22,
    focus_center_y = (Config.screen.height / 2) - 18,
    focus_initial_radius = 0,
    target_points = 100,
    instruction_text = "Wake up Norman!",
    show_progress_text = false,
    on_win = function()
      Audio.music_play_wakingup()
      Meter.show()
      if trigger_flash_on_wake then
        trigger_flash_on_wake = false
        Ascension.start_flash()
      end
      Window.set_current("game")
    end,
  })
end

local function stay_in_bed()
  Day.increase()
  state = STATE_DAY
  day_timer = day_display_frames
end

--- Starts the mysterious man screen.
--- @param[opt] options table Optional configuration.</br>
--- Fields: </br>
--- * text (string) Override for the scrolling text.<br/>
--- * day_text (string) Override for the centered day label.<br/>
--- * on_text_complete (function) Callback fired once when the text phase ends.<br/>
--- * skip_text (boolean) If true, skip the text phase and go straight to day display.<br/>
function MysteriousManScreen.start(options)
  options = options or {}
  day_timer = 0
  text_done = false
  text_done_timer = 0
  selected_choice = 1
  text = options.text or ASC_01_TEXT
  text_y = Config.screen.height
  day_text_override = options.day_text
  on_text_complete = options.on_text_complete
  Meter.hide()
  trigger_flash_on_wake = not options.skip_text
  if options.skip_text then
    show_mysterious_screen = false
    state = STATE_DAY
    day_timer = day_display_frames
  else
    show_mysterious_screen = true
    state = STATE_TEXT
  end
  Util.go_to_screen_by_id("mysterious_man")
  Window.set_current("game")
end

--- Sets the scrolling text content.
--- @param new_text string The text to display.
function MysteriousManScreen.set_text(new_text)
  text = new_text
end

Screen.register({
  id = "mysterious_man",
  name = "Mysterious Man",
  decisions = {},
  background_color = Config.colors.black,
  init = function()
    Audio.music_play_mystery()
  end,
  exit = function()
    Audio.music_stop()
  end,
  update = function()
    if state == STATE_TEXT then
      if not text_done then
        text_y = text_y - text_speed

        local lines = 1
        for _ in string.gmatch(text, "\n") do
          lines = lines + 1
        end

        if text_y < -lines * 8 then
          text_done = true
          text_done_timer = TEXT_DONE_HOLD_FRAMES
        end
      else
        text_done_timer = text_done_timer - 1
        if text_done_timer <= 0 then
          go_to_day_state()
        end
      end
    elseif state == STATE_DAY then
      day_timer = day_timer - 1

      if day_timer <= 0 or Input.select() then
        if trigger_flash_on_wake or Ascension.get_level() < 1 then
          wake_up()
        else
          state = STATE_CHOICE
          selected_choice = 1
        end
      end
    elseif state == STATE_CHOICE then
      selected_choice = UI.update_menu(choices, selected_choice)

      if Input.select() then
        Audio.sfx_select()
        if selected_choice == 1 then
          wake_up()
        else
          stay_in_bed()
        end
      end
    end
  end,
  draw = function()
    if show_mysterious_screen then
      draw_mysterious_man_background()
    end

    if state == STATE_TEXT then
      local cx = Config.screen.width / 2
      local line_y = text_y
      for line in (text .. "\n"):gmatch("(.-)\n") do
        Print.text_center(line, cx, line_y, Config.colors.light_grey)
        line_y = line_y + 8
      end
    elseif state == STATE_DAY then
      local day_text = day_text_override or ("Day " .. Context.day_count)
      Print.text_center(
        day_text,
        Config.screen.width / 2,
        Config.screen.height / 2 - 3,
        Config.colors.white
      )
    elseif state == STATE_CHOICE then
      local menu_x = (Config.screen.width - 60) / 2
      local menu_y = (Config.screen.height - 20) / 2
      UI.draw_menu(choices, selected_choice, menu_x, menu_y)
    end
  end,
})
