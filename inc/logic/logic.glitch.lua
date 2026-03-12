--- @section Glitch
Glitch = {}

--- Shows the glitch effect.
--- @within Glitch
function Glitch.show()
  if Context and Context.glitch then
    Context.glitch.enabled = true
  end
end

--- Hides the glitch effect.
--- @within Glitch
function Glitch.hide()
  if Context and Context.glitch then
    Context.glitch.enabled = false
  end
end

--- Draws the glitch effect if active.
--- @within Glitch
function Glitch.draw()
  if not Context or not Context.glitch or not Context.glitch.enabled then return end

  -- Update state timer
  Context.glitch.timer = Context.glitch.timer - 1
  if Context.glitch.timer <= 0 then
    if Context.glitch.state == "active" then
      Context.glitch.state = "waiting"
      Context.glitch.timer = math.random(20, 60) -- Time to stay fixed
    else
      Context.glitch.state = "active"
      Context.glitch.timer = math.random(40, 100) -- Time to stay glitchy
    end
  end

  -- Draw stripes only when active
  if Context.glitch.state == "active" then
    for _ = 1, 15 do
      local rx = math.random(0, Config.screen.width - 1)
      local ry = math.random(0, Config.screen.height - 1)

      -- Sample color at the random point
      local color = pix(rx, ry)

      -- Determine random length for the stripe (2-40)
      local length = math.random(2, 40)

      -- Draw the vertical stripe
      for sy = 0, length - 1 do
        local dy = ry + sy
        if dy < Config.screen.height then
          pix(rx, dy, color)
        end
      end
    end
  end
end
