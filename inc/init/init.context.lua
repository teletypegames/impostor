local SAVE_GAME_BANK = 6
local SAVE_GAME_MAGIC_VALUE_ADDRESS = 0
local SAVE_GAME_MAGIC_VALUE = 0xCA

local SAVE_GAME_PLAYER_X_ADDRESS = 1
local SAVE_GAME_PLAYER_Y_ADDRESS = 2
local SAVE_GAME_PLAYER_VX_ADDRESS = 3
local SAVE_GAME_PLAYER_VY_ADDRESS = 4
local SAVE_GAME_selectS_ADDRESS = 5
local SAVE_GAME_CURRENT_SCREEN_ADDRESS = 6

local VX_VY_OFFSET = 128 -- Offset for negative velocities

-- Helper for deep copying tables
local function clone_table(t)
  local copy = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      copy[k] = clone_table(v)
    else
      copy[k] = v
    end
  end
  return copy
end

-- This function returns a table containing only the initial *data* for Context
local function get_initial_data()
  return {
    active_window = WINDOW_SPLASH,
    intro = {
      y = Config.screen.height,
      speed = 0.5,
      text = "Norman Reds’ everyday life\nseems ordinary: work,\nmeetings, coffee, and\nendless notifications.\nBut beneath the surface\n— within him, or around\nhim — something is\nconstantly building, and\nit soon becomes clear\nthat there is more going\non than meets the eye."
    },
    current_screen = 1,
    splash_timer = Config.timing.splash_duration,
    dialog = {
      text = "",
      menu_items = {},
      selected_menu_item = 1,
      active_entity = nil,
      showing_description = false,
      current_node_key = nil
    },
    player = {
      sprite_id = Config.player.sprite_id
    },
    ground = {
      x = 0,
      y = Config.screen.height,
      w = Config.screen.width,
      h = 8
    },
    menu_items = {},
    selected_menu_item = 1,
    game_in_progress = false, -- New flag
    screens = clone_table({
      {
        -- Screen 1
        name = "Screen 1",
        npcs = {
          {
            name = "Trinity",
            sprite_id = 2,
            dialog = {
              start = {
                text = "Hello, Neo.",
                options = {
                  {label = "Who are you?", next_node = "who_are_you"},
                  {label = "My name is not Neo.", next_node = "not_neo"},
                  {label = "...", next_node = "silent"}
                }
              },
              who_are_you = {
                text = "I am Trinity. I've been looking for you.",
                options = {
                  {label = "The famous hacker?", next_node = "famous_hacker"},
                  {label = "Why me?", next_node = "why_me"}
                }
              },
              not_neo = {
                text = "I know. But you will be.",
                options = {
                  {label = "What are you talking about?", next_node = "who_are_you"}
                }
              },
              silent = {
                text = "You're not much of a talker, are you?",
                options = {
                  {label = "I guess not.", next_node = "dialog_end"}
                }
              },
              famous_hacker = {
                  text = "The one and only.",
                  options = {
                      {label = "Wow.", next_node = "dialog_end"}
                  }
              },
              why_me = {
                  text = "Morpheus believes you are The One.",
                  options = {
                      {label = "The One?", next_node = "the_one"}
                  }
              },
              the_one = {
                  text = "The one who will save us all.",
                  options = {
                      {label = "I'm just a programmer.", next_node = "dialog_end"}
                  }
              },
              dialog_end = {
                text = "We'll talk later.",
                options = {} -- No options, ends conversation
              }
            }
          },
          {
            name = "Oracle",
            sprite_id = 3,
            dialog = {
              start = {
                  text = "I know what you're thinking. 'Am I in the right place?'",
                  options = {
                      {label = "Who are you?", next_node = "who_are_you"},
                      {label = "I guess I am.", next_node = "you_are"}
                  }
              },
              who_are_are = {
                  text = "I'm the Oracle. And you're right on time. Want a cookie?",
                  options = {
                      {label = "Sure.", next_node = "cookie"},
                      {label = "No, thank you.", next_node = "no_cookie"}
                  }
              },
              you_are = {
                  text = "Of course you are. Sooner or later, everyone comes to see me. Want a cookie?",
                  options = {
                      {label = "Yes, please.", next_node = "cookie"},
                      {label = "I'm good.", next_node = "no_cookie"}
                  }
              },
              cookie = {
                  text = "Here you go. Now, what's really on your mind?",
                  options = {
                      {label = "Am I The One?", next_node = "the_one"},
                      {label = "What is the Matrix?", next_node = "the_matrix"}
                  }
              },
              no_cookie = {
                  text = "Suit yourself. Now, what's troubling you?",
                  options = {
                      {label = "Am I The One?", next_node = "the_one"},
                      {label = "What is the Matrix?", next_node = "the_matrix"}
                  }
              },
              the_one = {
                  text = "Being The One is just like being in love. No one can tell you you're in love, you just know it. Through and through. Balls to bones.",
                  options = {
                      {label = "So I'm not?", next_node = "dialog_end"}
                  }
              },
              the_matrix = {
                  text = "The Matrix is a system, Neo. That system is our enemy. But when you're inside, you look around, what do you see? The very minds of the people we are trying to save.",
                  options = {
                      {label = "I see.", next_node = "dialog_end"}
                  }
              },
              dialog_end = {
                  text = "You have to understand, most of these people are not ready to be unplugged.",
                  options = {}
              }
            }
          }
        },
        items = {
          {
            name = "Key",
            sprite_id = 4,
            desc = "A rusty old key. It might open something."
          }
        }
      },
      {
        -- Screen 2
        name = "Screen 2",
        npcs = {
          {
            name = "Morpheus",
            sprite_id = 5,
            dialog = {
              start = {
                  text = "At last. Welcome, Neo. As you no doubt have guessed, I am Morpheus.",
                  options = {
                      {label = "It's an honor to meet you.", next_node = "honor"},
                      {label = "You've been looking for me.", next_node = "looking_for_me"}
                  }
              },
              honor = {
                  text = "No, the honor is mine.",
                  options = {
                      {label = "What is this place?", next_node = "what_is_this_place"}
                  }
              },
              looking_for_me = {
                  text = "I have. For some time.",
                  options = {
                      {label = "What is this place?", next_node = "what_is_this_place"}
                  }
              },
              what_is_this_place = {
                  text = "This is the construct. It's our loading program. We can load anything from clothing, to equipment, weapons, training simulations. Anything we need.",
                  options = {
                      {label = "Right.", next_node = "dialog_end"}
                  }
              },
              dialog_end = {
                  text = "I've been waiting for you, Neo. We have much to discuss.",
                  options = {} -- Ends conversation
              }
            }
          },
          {
            name = "Tank",
            sprite_id = 6,
            dialog = {
              start = {
                  text = "Hey, Neo! Welcome to the construct. I'm Tank.",
                  options = {
                      {label = "Good to meet you.", next_node = "good_to_meet_you"},
                      {label = "This place is incredible.", next_node = "incredible"}
                  }
              },
              good_to_meet_you = {
                  text = "You too! We've been waiting for you. Need anything? Training? Weapons?",
                  options = {
                      {label = "Training?", next_node = "training"},
                      {label = "I'm good for now.", next_node = "dialog_end"}
                  }
              },
              incredible = {
                  text = "Isn't it? The boss's design. We can load anything we need. What do you want to learn?",
                  options = {
                      {label = "Show me.", next_node = "training"}
                  }
              },
              training = {
                  text = "Jujitsu? Kung Fu? How about... all of them?",
                  options = {
                      {label = "All of them.", next_node = "all_of_them"}
                  }
              },
              all_of_them = {
                  text = "Operator, load the combat training program.",
                  options = {
                      {label = "...", next_node = "dialog_end"}
                  }
              },
              dialog_end = {
                  text = "Just holler if you need anything. Anything at all.",
                  options = {}
              }
            }
          }
        },
        items = {
          {
            name = "Potion",
            sprite_id = 7,
            desc = "A glowing red potion. It looks potent."
          }
        }
      },
      {
        -- Screen 3
        name = "Screen 3",
        npcs = {
          {
            name = "Agent Smith",
            sprite_id = 8,
            dialog = {
              start = {
                  text = "Mr. Anderson. We've been expecting you.",
                  options = {
                      {label = "My name is Neo.", next_node = "name_is_neo"},
                      {label = "...", next_node = "silent"}
                  }
              },
              name_is_neo = {
                  text = "Whatever you say. You're here for a reason.",
                  options = {
                      {label = "What reason?", next_node = "what_reason"}
                  }
              },
              silent = {
                  text = "The silent type. It doesn't matter. You are an anomaly.",
                  options = {
                      {label = "What do you want?", next_node = "what_reason"}
                  }
              },
              what_reason = {
                  text = "To be deleted. The system has no place for your kind.",
                  options = {
                      {label = "I won't let you.", next_node = "wont_let_you"}
                  }
              },
              wont_let_you = {
                  text = "You hear that, Mr. Anderson? That is the sound of inevitability.",
                  options = {
                      {label = "...", next_node = "dialog_end"}
                  }
              },
              dialog_end = {
                  text = "It is purpose that created us. Purpose that connects us. Purpose that pulls us. That guides us. That drives us. It is purpose that defines. Purpose that binds us.",
                  options = {}
              }
            }
          },
          {
            name = "Cypher",
            sprite_id = 9,
            dialog = {
              start = {
                  text = "Well, well. The new messiah. Welcome to the real world.",
                  options = {
                      {label = "You don't seem happy.", next_node = "not_happy"},
                      {label = "...", next_node = "silent"}
                  }
              },
              not_happy = {
                  text = "Happy? Ignorance is bliss, Neo. We've been fighting this war for years. For what?",
                  options = {
                      {label = "For freedom.", next_node = "freedom"}
                  }
              },
              silent = {
                  text = "Not a talker, huh? Smart. Less to regret later. Want a drink?",
                  options = {
                      {label = "Sure.", next_node = "drink"},
                      {label = "No thanks.", next_node = "no_drink"}
                  }
              },
              drink = {
                  text = "Good stuff. The little things you miss, you know? Like a good steak.",
                  options = {
                      {label = "I guess.", next_node = "dialog_end"}
                  }
              },
              no_drink = {
                  text = "Your loss. More for me.",
                  options = {
                      {label = "...", next_node = "dialog_end"}
                  }
              },
              freedom = {
                  text = "Freedom... right. If Morpheus told you you could fly, would you believe him?",
                  options = {
                      {label = "He's our leader.", next_node = "dialog_end"}
                  }
              },
              dialog_end = {
                  text = "Just be careful who you trust.",
                  options = {}
              }
            }
          }
        },
        items = {}
      }
    })
  }
end

Context = {}

local function reset_context_to_initial_state()
  local initial_data = get_initial_data()

  -- Clear existing data properties from Context (but not methods)
  for k in pairs(Context) do
    if type(Context[k]) ~= "function" then -- Only clear data, leave functions
      Context[k] = nil
    end
  end

  -- Copy all initial data properties into Context
  for k, v in pairs(initial_data) do
    Context[k] = v
  end
end

-- Initially populate Context with data
reset_context_to_initial_state()

-- Now define the methods for Context
function Context.new_game()
  reset_context_to_initial_state()
  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
end

function Context.save_game()
  if not Context.game_in_progress then return end

  mset(SAVE_GAME_MAGIC_VALUE, SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK)
  mset(Context.current_screen, SAVE_GAME_CURRENT_SCREEN_ADDRESS, SAVE_GAME_BANK)
end

function Context.load_game()
  if mget(SAVE_GAME_MAGIC_VALUE_ADDRESS, SAVE_GAME_BANK) ~= SAVE_GAME_MAGIC_VALUE then
    -- No saved game found, start a new one
    Context.new_game()
    return
  end

  reset_context_to_initial_state() -- Reset data, preserve methods

  Context.current_screen = mget(SAVE_GAME_CURRENT_SCREEN_ADDRESS, SAVE_GAME_BANK)

  Context.game_in_progress = true
  MenuWindow.refresh_menu_items()
end