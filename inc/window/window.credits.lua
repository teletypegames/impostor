--- @section CreditsWindow

local _time          = 0.0
local _scroll_x      = 0.0
local _scroll_total_w = 0
local _scroll_chars  = {}
local _title_chars   = {}
local _title_total_w = 0
local _stars         = {}

local TITLE = "TELETYPE GAMES"

local SCROLL_PARTS = {
  "WEB: GAMES.TELETYPE.HU",
  "BBS: GAMES.TELETYPE.HU:2323",
  "IRC: LIBERA.CHAT #TELETYPEGAMES",
  "YOUTUBE.COM/@TELETYPEGAMES",
}

local SCROLL_SEP = "    *    "

local SCROLL_SPEED      = 55.0
local SCROLL_Y          = 129
local SCROLL_ZONE_COLS  = { 7, 4, 9 }

local TITLE_Y          = 4
local TITLE_FALL_DUR   = 0.45
local TITLE_DELAY_STEP = 0.18

local RASTER_COLS  = { 1, 3, 9, 10, 11, 4, 11, 10, 9, 3, 1 }
local RASTER_Y_TOP = 26
local RASTER_Y_BOT = 110

local AUTHORS = {
  "Mr. Zero  - Zsolt Tasnadi",
  "Mr. One   - Ballz",
  "Mr. Two   - Zoltan Timar",
  "Mr. Three - Bela Mezo",
}
local AUTHORS_BASE_Y   = 56
local AUTHORS_LINE_H   = 12
local AUTHORS_ENTRY_DT = 0.65
local AUTHORS_ENTRY_V  = 2.5

local RAINBOW  = { 4, 9, 3, 7, 13, 2, 9, 4 }
local NUM_STARS = 40

--- Initialises credits state and pre-computes character metrics.
--- @within CreditsWindow
function CreditsWindow.init()
  _time    = 0.0
  _scroll_x = Config.screen.width + 4.0

  _title_chars  = {}
  _title_total_w = 0
  for i = 1, #TITLE do
    local ch = TITLE:sub(i, i)
    local w  = print(ch, 0, -100, 0, false, 2)
    _title_chars[i] = { ch = ch, ox = _title_total_w, w = w }
    _title_total_w  = _title_total_w + w
  end

  _scroll_chars  = {}
  _scroll_total_w = 0
  local function append_str(str, col)
    for i = 1, #str do
      local ch = str:sub(i, i)
      local w  = print(ch, 0, -100, 0, false, 1)
      _scroll_chars[#_scroll_chars + 1] = { ch = ch, ox = _scroll_total_w, w = w, col = col }
      _scroll_total_w = _scroll_total_w + w
    end
  end
  for _, part in ipairs(SCROLL_PARTS) do
    append_str(part, RAINBOW[math.random(#RAINBOW)])
    append_str(SCROLL_SEP, Config.colors.white)
  end

  _stars = {}
  for i = 1, NUM_STARS do
    _stars[i] = {
      x   = math.random(0, Config.screen.width  - 1) + 0.0,
      y   = math.random(0, Config.screen.height - 1),
      spd = (i % 3 + 1) * 10.0,
      col = ({ 1, 2, 4, 4 })[(i % 4) + 1],
    }
  end
end

local function draw_stars()
  for _, s in ipairs(_stars) do
    pix(math.floor(s.x), s.y, s.col)
  end
end

local function draw_rasters()
  local cy = RASTER_Y_TOP + math.floor(math.sin(_time * 1.3) * 6)
  for i, col in ipairs(RASTER_COLS) do
    local y = cy + i - 1
    if y >= 0 and y < Config.screen.height then
      line(0, y, Config.screen.width - 1, y, col)
    end
  end
  local cy2 = RASTER_Y_BOT + math.floor(math.sin(_time * 1.7 + 1.5) * 5)
  for i, col in ipairs(RASTER_COLS) do
    local y = cy2 + i - 1
    if y >= 0 and y < Config.screen.height then
      line(0, y, Config.screen.width - 1, y, col)
    end
  end
end

local function bounce_out(p)
  local n1, d1 = 7.5625, 2.75
  if p < 1 / d1 then
    return n1 * p * p
  elseif p < 2 / d1 then
    p = p - 1.5 / d1;  return n1 * p * p + 0.75
  elseif p < 2.5 / d1 then
    p = p - 2.25 / d1; return n1 * p * p + 0.9375
  else
    p = p - 2.625 / d1; return n1 * p * p + 0.984375
  end
end

local function draw_title()
  local sx       = math.floor((Config.screen.width - _title_total_w) / 2)
  local n        = #_title_chars
  local max_dist = (n - 1) / 2.0
  for i, tc in ipairs(_title_chars) do
    local dist  = math.abs(i - (n + 1) / 2.0)
    local delay = (max_dist - dist) * TITLE_DELAY_STEP
    local t     = math.max(0, _time - delay)
    local p     = math.min(1, t / TITLE_FALL_DUR)
    local y     = math.floor(-14 + bounce_out(p) * (TITLE_Y + 14))
    print(tc.ch, sx + tc.ox + 1, y + 1, 0, false, 2)
    print(tc.ch, sx + tc.ox,     y,     Config.colors.light_blue, false, 2)
  end
end

local function draw_authors()
  local col = Config.colors.light_blue
  for i, lbl in ipairs(AUTHORS) do
    local enter_t = math.max(0, _time - (i - 1) * AUTHORS_ENTRY_DT)
    local slide   = math.max(0, 1 - enter_t * AUTHORS_ENTRY_V)
    local x_off   = math.floor(slide * (Config.screen.width + 40))
    local yo      = (slide < 0.01) and math.floor(math.sin(_time * 2.0 + i * 1.1) * 2) or 0
    Print.text(lbl, 12 + x_off, AUTHORS_BASE_Y + (i - 1) * AUTHORS_LINE_H + yo, col)
  end
end

local function draw_scroller()
  local third = Config.screen.width / 3
  for pass = 0, 1 do
    local base = _scroll_x + pass * _scroll_total_w
    for _, sc in ipairs(_scroll_chars) do
      local x = math.floor(base + sc.ox)
      if x >= Config.screen.width then break end
      if x + sc.w > 0 then
        local zone = math.max(1, math.min(3, math.floor(x / third) + 1))
        print(sc.ch, x, SCROLL_Y, SCROLL_ZONE_COLS[zone], false, 1)
      end
    end
  end
end

--- Draws the credits window.
--- @within CreditsWindow
function CreditsWindow.draw()
  cls(Config.colors.black)
  draw_stars()
  draw_rasters()
  draw_title()
  Print.text_center("Authors", Config.screen.width / 2, 47, Config.colors.light_grey)
  draw_authors()
  draw_scroller()

end

--- Updates credits window logic.
--- @within CreditsWindow
function CreditsWindow.update()
  _time = _time + Context.delta_time

  for _, s in ipairs(_stars) do
    s.x = s.x + s.spd * Context.delta_time
    if s.x >= Config.screen.width then s.x = s.x - Config.screen.width end
  end

  _scroll_x = _scroll_x - SCROLL_SPEED * Context.delta_time
  if _scroll_x <= -_scroll_total_w then
    _scroll_x = _scroll_x + _scroll_total_w
  end

  if Input.back() or Input.select() then
    Window.set_current("menu")
  end
end
