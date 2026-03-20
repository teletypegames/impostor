--- @section MysteriousManWindow

local STATE_TEXT = "text"
local STATE_DAY = "day"
local STATE_CHOICE = "choice"

local ASC_01_TEXT = [[
  Normann seems to be in line,
  and stays seeking for oxes
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
  Normann caught his glimpse of another way
  *quite literally*
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

local choices = {
  {
    label = "Wake Up",
  },
  {
    label = "Stay in Bed",
  },
}

--- Sets the scrolling text content.
--- @within MysteriousManWindow
--- @param new_text string The text to display.
function MysteriousManWindow.set_text(new_text)
  text = new_text
end

--- Starts the mysterious man window.
--- @within MysteriousManWindow
--- @param[opt] options table Optional window configuration.</br>
--- Fields: </br>
--- * text (string) Override for the scrolling text.<br/>
--- * day_text (string) Override for the centered day label.<br/>
--- * on_text_complete (function) Callback fired once when the text phase ends.<br/>
--- * skip_text (boolean) If true, skip the text phase and go straight to day display.<br/>
function MysteriousManWindow.start(options)
  options = options or {}
  day_timer = 0
  text_done = false
  text_done_timer = 0
  selected_choice = 1
  text = options.text or ASC_01_TEXT
  local line_count = 1
  for _ in string.gmatch(text, "\n") do line_count = line_count + 1 end
  local text_block_h = line_count * 8
  text_y = math.floor((Config.screen.height - text_block_h) / 2)
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
  Window.set_current("mysterious_man")
end

local function go_to_day_state()
  if on_text_complete then
    on_text_complete()
    on_text_complete = nil
  end
  if Window.get_current_id() ~= "mysterious_man" then
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
      Context.home_norman_visible = true
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

--- Updates the mysterious man window logic.
--- @within MysteriousManWindow
function MysteriousManWindow.update()
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
end

--- Draws the mysterious man window.
--- @within MysteriousManWindow
function MysteriousManWindow.draw()
  rect(0, 0, Config.screen.width, Config.screen.height, Config.colors.black)
  if show_mysterious_screen then
    Screen.draw_the_mysterious_screen()
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
end
