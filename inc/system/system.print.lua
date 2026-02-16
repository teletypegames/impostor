
function Print.text(text, x, y, color, fixed, scale)
  local shadow_color = Config.colors.black
  if color == shadow_color then shadow_color = Config.colors.light_grey end
  scale = scale or 1
  print(text, x + 1, y + 1, shadow_color, fixed, scale)
  print(text, x, y, color, fixed, scale)
end

function Print.text_center(text, x, y, color, fixed, scale)
  scale = scale or 1
  local text_width = print(text, 0, -6, 0, fixed, scale)
  local centered_x = x - (text_width / 2)
  Print.text(text, centered_x, y, color, fixed, scale)
end
