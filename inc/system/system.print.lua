--- Prints text with shadow.
--- @within Print
--- @param text string The text to print.<br/>
--- @param x number The x-coordinate.<br/>
--- @param y number The y-coordinate.<br/>
--- @param color number The color of the text.<br/>
--- @param[opt] fixed boolean If true, uses fixed-width font.<br/>
--- @param[opt] scale number The scaling factor.<br/>
function Print.text(text, x, y, color, fixed, scale)
  local shadow_color = Config.colors.black
  if color == shadow_color then shadow_color = Config.colors.light_grey end
  scale = scale or 1
  print(text, x + scale, y + scale, shadow_color, fixed, scale)
  print(text, x, y, color, fixed, scale)
end

--- Prints text with a contour (outline) instead of shadow.
--- @within Print
--- @param text string The text to print.<br/>
--- @param x number The x-coordinate.<br/>
--- @param y number The y-coordinate.<br/>
--- @param color number The color of the text.<br/>
--- @param[opt] fixed boolean If true, uses fixed-width font.<br/>
--- @param[opt] scale number The scaling factor (also used for outline thickness).<br/>
--- @param[opt] contour_color number Outline color; defaults to black; if equal to text color, uses white.<br/>
function Print.text_contour(text, x, y, color, fixed, scale, contour_color)
  scale = scale or 1
  local cc = contour_color
  if cc == nil then cc = Config.colors.black end
  if color == cc then cc = Config.colors.white end
  local ox = { -scale, scale, 0, 0, -scale, scale, -scale, scale }
  local oy = { 0, 0, -scale, scale, -scale, -scale, scale, scale }
  for i = 1, 8 do
    print(text, x + ox[i], y + oy[i], cc, fixed, scale)
  end
  print(text, x, y, color, fixed, scale)
end

--- Prints centered text with shadow.
--- @within Print
--- @param text string The text to print.<br/>
--- @param x number The x-coordinate for centering.<br/>
--- @param y number The y-coordinate.<br/>
--- @param color number The color of the text.<br/>
--- @param[opt] fixed boolean If true, uses fixed-width font.<br/>
--- @param[opt] scale number The scaling factor.<br/>
function Print.text_center(text, x, y, color, fixed, scale)
  scale = scale or 1
  local text_width = print(text, 0, -6 * scale, 0, fixed, scale)
  local centered_x = x - (text_width / 2)
  Print.text(text, centered_x, y, color, fixed, scale)
end

--- Prints centered text with contour instead of shadow.
--- @within Print
--- @param text string The text to print.<br/>
--- @param x number The x-coordinate for centering.<br/>
--- @param y number The y-coordinate.<br/>
--- @param color number The color of the text.<br/>
--- @param[opt] fixed boolean If true, uses fixed-width font.<br/>
--- @param[opt] scale number The scaling factor.<br/>
--- @param[opt] contour_color number Outline color; defaults to black; if equal to text color, uses white.<br/>
function Print.text_center_contour(text, x, y, color, fixed, scale, contour_color)
  scale = scale or 1
  local text_width = print(text, 0, -6 * scale, 0, fixed, scale)
  local centered_x = x - (text_width / 2)
  Print.text_contour(text, centered_x, y, color, fixed, scale, contour_color)
end
