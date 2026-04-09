--- @section DiscussionWindow

local TEXTBOX_W = math.floor(Config.screen.width * 0.7)
local TEXTBOX_H = math.floor(Config.screen.height * 0.3)
local TEXTBOX_X = math.floor((Config.screen.width - TEXTBOX_W) / 2)
local TEXTBOX_Y = math.floor((Config.screen.height - TEXTBOX_H) / 2 - 8)
local TEXTBOX_MAX_CHARS = 30
local DISCUSSION_LINE_HEIGHT = 8
local PADDING = 4
local AUTO_SCROLL_DELAY = 12
local AUTO_SCROLL_STEP = 1

--- Draws the discussion window.
--- @within DiscussionWindow
function DiscussionWindow.draw()
  GameWindow.draw()

  local step = Discussion.get_current_step()
  if not step then return end

  UI.draw_textbox(
    step.question,
    TEXTBOX_X, TEXTBOX_Y,
    TEXTBOX_W, TEXTBOX_H,
    Context.discussion.scroll_y,
    Config.colors.white,
    Config.colors.black,
    Config.colors.light_blue,
    true
  )

  local answers = step.answers
  if #answers > 0 then
    local bar_height = 16
    local bar_y = Config.screen.height - bar_height
    rect(0, bar_y, Config.screen.width, bar_height, Config.colors.dark_grey)
    local selected = answers[Context.discussion.selected_answer]
    local label = selected.label
    local answer_text_y = bar_y + 4
    local left_arrow_color = Input.left() and Config.colors.white or Config.colors.orange
    local right_arrow_color = Input.right() and Config.colors.white or Config.colors.orange
    local left_arrow_contour_color = Input.left() and Config.colors.white or Config.colors.black
    local right_arrow_contour_color = Input.right() and Config.colors.white or Config.colors.black
    Print.text_center_contour("<", 6, answer_text_y, left_arrow_color, false, 1, left_arrow_contour_color)
    Print.text_center(label, Config.screen.width / 2, answer_text_y, Config.colors.orange)
    Print.text_center_contour(">", Config.screen.width - 6, answer_text_y, right_arrow_color, false, 1, right_arrow_contour_color)
  end
end

--- Updates the discussion window logic.
--- @within DiscussionWindow
function DiscussionWindow.update()
  local step = Discussion.get_current_step()
  if not step then return end

  local lines = UI.word_wrap(step.question, TEXTBOX_MAX_CHARS)
  local text_height = #lines * DISCUSSION_LINE_HEIGHT
  local visible_height = TEXTBOX_H - PADDING * 2
  local max_scroll = text_height - visible_height
  if max_scroll < 0 then max_scroll = 0 end

  if max_scroll > 0 then
    if Context.discussion.auto_scroll then
      Context.discussion.scroll_timer = Context.discussion.scroll_timer + 1
      if Context.discussion.scroll_timer >= AUTO_SCROLL_DELAY then
        Context.discussion.scroll_timer = 0
        Context.discussion.scroll_y = Context.discussion.scroll_y + AUTO_SCROLL_STEP
        if Context.discussion.scroll_y > max_scroll then
          Context.discussion.scroll_y = max_scroll
        end
      end
    end
  else
    Context.discussion.scroll_y = 0
    Context.discussion.scroll_timer = 0
  end

  if Input.up() then
    Context.discussion.auto_scroll = false
    Context.discussion.scroll_y = Context.discussion.scroll_y - DISCUSSION_LINE_HEIGHT
    if Context.discussion.scroll_y < 0 then
      Context.discussion.scroll_y = 0
    end
  elseif Input.down() then
    Context.discussion.auto_scroll = false
    Context.discussion.scroll_y = Context.discussion.scroll_y + DISCUSSION_LINE_HEIGHT
    if Context.discussion.scroll_y > max_scroll then
      Context.discussion.scroll_y = max_scroll
    end
  end

  local answers = step.answers
  if #answers > 0 then
    if Input.left() then
      Audio.sfx_beep()
      Context.discussion.selected_answer = Util.safeindex(answers, Context.discussion.selected_answer - 1)
    elseif Input.right() then
      Audio.sfx_beep()
      Context.discussion.selected_answer = Util.safeindex(answers, Context.discussion.selected_answer + 1)
    end

    if Input.select() then
      Audio.sfx_select()
      local selected = answers[Context.discussion.selected_answer]
      if selected.on_select then
        selected.on_select()
      end
      Discussion.go_to_step(selected.next_step)
    end
  end
end
