--- @section MysteriousManWindow

local STATE_TEXT = "text"
local STATE_DAY = "day"
local STATE_CHOICE = "choice"

local state = STATE_TEXT
local text_y = Config.screen.height
local text_speed = 0.4
local day_timer = 0
local day_display_frames = 120
local selected_choice = 1

local choices = {
  {
    label = "Wake Up",
  },
  {
    label = "Stay in Bed",
  },
}

local text = [[
Misterious man appears
during your sleep.

He says nothing.
He doesn't need to.

He says nothing.
]]

--- Sets the scrolling text content.
--- @within MysteriousManWindow
--- @param new_text string The text to display.
function MysteriousManWindow.set_text(new_text)
  text = new_text
end

--- Starts the mysterious man window.
--- @within MysteriousManWindow
function MysteriousManWindow.start()
  state = STATE_TEXT
  text_y = Config.screen.height
  day_timer = 0
  selected_choice = 1
  Meter.hide()
  Window.set_current("mysterious_man")
end

local function wake_up()
  Util.go_to_screen_by_id("home")
  MinigameButtonMashWindow.start("game", {
    focus_center_x = Config.screen.width / 2,
    focus_center_y = Config.screen.height / 2,
    focus_initial_radius = 0,
    on_win = function()
      Meter.show()
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
    text_y = text_y - text_speed

    local lines = 1
    for _ in string.gmatch(text, "\n") do
      lines = lines + 1
    end

    if text_y < -lines * 8 then
      state = STATE_DAY
      day_timer = day_display_frames
    end

    if Input.select() then
      state = STATE_DAY
      day_timer = day_display_frames
    end
  elseif state == STATE_DAY then
    day_timer = day_timer - 1

    if day_timer <= 0 or Input.select() then
      state = STATE_CHOICE
      selected_choice = 1
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

  if state == STATE_TEXT then
    local x = (Config.screen.width - 132) / 2
    Print.text(text, x, text_y, Config.colors.light_grey)
  elseif state == STATE_DAY then
    local day_text = "Day " .. Context.day_count
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
