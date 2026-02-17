DesitionManager = {}

local _desitions = {} -- Private table to store all desitions

-- Registers a new desition with the manager
-- id: unique string identifier for the desition
-- label: string label to display for the desition
-- handler: function to execute when the desition is selected
function DesitionManager.register(id, label, handler)
  if _desitions[id] then
    -- Optional: warning if overwriting an existing desition
    -- trace("Warning: Overwriting desition with id: " .. id)
  end
  _desitions[id] = Util.create_decision(id, label, handler)
end

-- Retrieves a desition by its id
-- id: unique string identifier of the desition
-- Returns the desition object, or nil if not found
function DesitionManager.get(id)
  return _desitions[id]
end

-- Optional: a way to get all registered desitions, if needed (e.g., for debug)
function DesitionManager.get_all()
  return _desitions
end

-- Register all game desitions
-- Home Screen Decisions
DesitionManager.register("go_to_toilet", "Go to Toilet", Desitions.go_to_toilet)
DesitionManager.register("go_to_walking_to_office", "Go to Walking to office", Desitions.go_to_walking_to_office)

-- Minigame functions
DesitionManager.register("play_button_mash", "Play Button Mash", Desitions.start_minigame_mash)
DesitionManager.register("play_rhythm", "Play Rhythm Game", Desitions.start_minigame_rhythm)
DesitionManager.register("play_ddr", "Play DDR (Random)", Desitions.start_minigame_ddr)

-- Navigation functions
DesitionManager.register("go_to_home", "Go to Home", Desitions.go_to_home)
DesitionManager.register("go_to_office", "Go to Office", Desitions.go_to_office)
DesitionManager.register("go_to_walking_to_home", "Go to Walking to home", Desitions.go_to_walking_to_home)
