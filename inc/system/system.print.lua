--- @section Print

--- Prints text with shadow.
--- @within Print
--- @param text string The text to print.
--- @param x number The x-coordinate.
--- @param y number The y-coordinate.
--- @param color number The color of the text.
--- @param[opt] fixed boolean If true, uses fixed-width font.
--- @param[opt] scale number The scaling factor.
function Print.text(text, x, y, color, fixed, scale)
  local shadow_color = Config.colors.black
  if color == shadow_color then shadow_color = Config.colors.light_grey end
  scale = scale or 1
  print(text, x + 1, y + 1, shadow_color, fixed, scale)
  print(text, x, y, color, fixed, scale)
end

--- Prints centered text with shadow.
--- @within Print
--- @param text string The text to print.
--- @param x number The x-coordinate for centering.
--- @param y number The y-coordinate.
--- @param color number The color of the text.
--- @param[opt] fixed boolean If true, uses fixed-width font.
--- @param[opt] scale number The scaling factor.
function Print.text_center(text, x, y, color, fixed, scale)
  scale = scale or 1
  local text_width = print(text, 0, -6, 0, fixed, scale)
  local centered_x = x - (text_width / 2)
  Print.text(text, centered_x, y, color, fixed, scale)
end
