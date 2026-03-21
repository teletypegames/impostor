unpack = unpack or table.unpack

musicator_markov_model = {
  model = {
    ["...|..."] = {
      next = {
        ["..."] = 0.71111111111111,
        ["A-4"] = 0.0074074074074074,
        ["B-4"] = 0.0037037037037037,
        ["C-3"] = 0.011111111111111,
        ["C-4"] = 0.037037037037037,
        ["C-5"] = 0.11111111111111,
        ["C-6"] = 0.0037037037037037,
        ["D-4"] = 0.011111111111111,
        ["D-5"] = 0.018518518518519,
        ["E-4"] = 0.0074074074074074,
        ["E-5"] = 0.025925925925926,
        ["F-5"] = 0.0074074074074074,
        ["G-3"] = 0.0037037037037037,
        ["G-4"] = 0.022222222222222,
        ["G-5"] = 0.018518518518519
      },
      total = 270
    },
    ["...|A-4"] = {
      next = {
        ["..."] = 0.9,
        ["C-5"] = 0.1
      },
      total = 10
    },
    ["...|A-5"] = {
      next = {
        ["..."] = 1
      },
      total = 8
    },
    ["...|B-4"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["...|B-5"] = {
      next = {
        ["..."] = 1
      },
      total = 5
    },
    ["...|C-3"] = {
      next = {
        ["..."] = 0.66666666666667,
        ["C-5"] = 0.33333333333333
      },
      total = 3
    },
    ["...|C-4"] = {
      next = {
        ["..."] = 0.875,
        ["D-4"] = 0.083333333333333,
        ["E-4"] = 0.041666666666667
      },
      total = 24
    },
    ["...|C-5"] = {
      next = {
        ["..."] = 0.73333333333333,
        ["B-4"] = 0.033333333333333,
        ["C-5"] = 0.066666666666667,
        ["D-5"] = 0.13333333333333,
        ["E-5"] = 0.033333333333333
      },
      total = 60
    },
    ["...|C-6"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["...|D-4"] = {
      next = {
        ["..."] = 0.92857142857143,
        ["D-4"] = 0.071428571428571
      },
      total = 14
    },
    ["...|D-5"] = {
      next = {
        ["..."] = 0.80645161290323,
        ["C-5"] = 0.032258064516129,
        ["D-5"] = 0.032258064516129,
        ["E-5"] = 0.12903225806452
      },
      total = 31
    },
    ["...|D-6"] = {
      next = {
        ["..."] = 1
      },
      total = 3
    },
    ["...|E-4"] = {
      next = {
        ["..."] = 1
      },
      total = 19
    },
    ["...|E-5"] = {
      next = {
        ["..."] = 0.77777777777778,
        ["C-5"] = 0.022222222222222,
        ["D-5"] = 0.13333333333333,
        ["F-5"] = 0.066666666666667
      },
      total = 45
    },
    ["...|F-3"] = {
      next = {
        ["..."] = 1
      },
      total = 3
    },
    ["...|F-4"] = {
      next = {
        ["..."] = 0.8,
        ["D-4"] = 0.1,
        ["F-4"] = 0.1
      },
      total = 10
    },
    ["...|F-5"] = {
      next = {
        ["..."] = 0.66666666666667,
        ["D-5"] = 0.066666666666667,
        ["E-5"] = 0.066666666666667,
        ["G-5"] = 0.2
      },
      total = 15
    },
    ["...|G-3"] = {
      next = {
        ["..."] = 0.8,
        ["G-5"] = 0.2
      },
      total = 5
    },
    ["...|G-4"] = {
      next = {
        ["..."] = 0.95652173913043,
        ["E-4"] = 0.043478260869565
      },
      total = 23
    },
    ["...|G-5"] = {
      next = {
        ["..."] = 0.875,
        ["A-5"] = 0.0625,
        ["E-5"] = 0.0625
      },
      total = 16
    },
    ["...|G-6"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["A-4|..."] = {
      next = {
        ["..."] = 0.55555555555556,
        ["C-5"] = 0.33333333333333,
        ["D-5"] = 0.11111111111111
      },
      total = 9
    },
    ["A-4|B-4"] = {
      next = {
        ["C-5"] = 1
      },
      total = 2
    },
    ["A-4|C-5"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["A-4|G-4"] = {
      next = {
        ["F-4"] = 1
      },
      total = 2
    },
    ["A-5|..."] = {
      next = {
        ["..."] = 0.2,
        ["B-5"] = 0.1,
        ["E-4"] = 0.1,
        ["E-5"] = 0.4,
        ["F-5"] = 0.1,
        ["G-5"] = 0.1
      },
      total = 10
    },
    ["A-5|G-5"] = {
      next = {
        ["..."] = 0.33333333333333,
        ["A-5"] = 0.66666666666667
      },
      total = 3
    },
    ["B-4|..."] = {
      next = {
        ["A-4"] = 1
      },
      total = 1
    },
    ["B-4|A-4"] = {
      next = {
        ["G-4"] = 1
      },
      total = 2
    },
    ["B-4|C-5"] = {
      next = {
        ["..."] = 1
      },
      total = 2
    },
    ["B-5|..."] = {
      next = {
        ["..."] = 0.2,
        ["A-5"] = 0.2,
        ["D-6"] = 0.4,
        ["G-5"] = 0.2
      },
      total = 5
    },
    ["C-3|..."] = {
      next = {
        ["C-4"] = 1
      },
      total = 2
    },
    ["C-3|C-5"] = {
      next = {
        ["..."] = 0.33333333333333,
        ["C-3"] = 0.66666666666667
      },
      total = 3
    },
    ["C-4|..."] = {
      next = {
        ["..."] = 0.5,
        ["D-4"] = 0.125,
        ["E-4"] = 0.041666666666667,
        ["F-3"] = 0.041666666666667,
        ["G-3"] = 0.16666666666667,
        ["G-4"] = 0.083333333333333,
        ["G-5"] = 0.041666666666667
      },
      total = 24
    },
    ["C-4|D-4"] = {
      next = {
        ["E-4"] = 1
      },
      total = 2
    },
    ["C-4|E-4"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["C-5|..."] = {
      next = {
        ["..."] = 0.40677966101695,
        ["A-4"] = 0.067796610169492,
        ["C-5"] = 0.050847457627119,
        ["D-5"] = 0.20338983050847,
        ["E-5"] = 0.15254237288136,
        ["F-5"] = 0.016949152542373,
        ["G-4"] = 0.10169491525424
      },
      total = 59
    },
    ["C-5|B-4"] = {
      next = {
        ["A-4"] = 1
      },
      total = 2
    },
    ["C-5|C-3"] = {
      next = {
        ["C-5"] = 1
      },
      total = 2
    },
    ["C-5|C-5"] = {
      next = {
        ["..."] = 0.8,
        ["C-5"] = 0.2
      },
      total = 5
    },
    ["C-5|D-5"] = {
      next = {
        ["..."] = 0.3,
        ["C-5"] = 0.2,
        ["D-5"] = 0.1,
        ["E-5"] = 0.4
      },
      total = 10
    },
    ["C-5|E-5"] = {
      next = {
        ["..."] = 0.33333333333333,
        ["D-5"] = 0.33333333333333,
        ["G-5"] = 0.33333333333333
      },
      total = 3
    },
    ["C-6|..."] = {
      next = {
        ["A-5"] = 1
      },
      total = 1
    },
    ["D-4|..."] = {
      next = {
        ["..."] = 0.26666666666667,
        ["A-5"] = 0.066666666666667,
        ["C-4"] = 0.2,
        ["E-4"] = 0.4,
        ["F-3"] = 0.066666666666667
      },
      total = 15
    },
    ["D-4|C-4"] = {
      next = {
        ["..."] = 1
      },
      total = 2
    },
    ["D-4|D-4"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["D-4|E-4"] = {
      next = {
        ["F-4"] = 1
      },
      total = 2
    },
    ["D-5|..."] = {
      next = {
        ["..."] = 0.2258064516129,
        ["A-4"] = 0.032258064516129,
        ["A-5"] = 0.032258064516129,
        ["C-5"] = 0.2258064516129,
        ["E-5"] = 0.29032258064516,
        ["F-5"] = 0.096774193548387,
        ["G-5"] = 0.096774193548387
      },
      total = 31
    },
    ["D-5|C-5"] = {
      next = {
        ["..."] = 0.77777777777778,
        ["D-5"] = 0.22222222222222
      },
      total = 9
    },
    ["D-5|D-5"] = {
      next = {
        ["..."] = 0.5,
        ["E-5"] = 0.5
      },
      total = 2
    },
    ["D-5|E-5"] = {
      next = {
        ["..."] = 0.33333333333333,
        ["E-5"] = 0.11111111111111,
        ["F-5"] = 0.55555555555556
      },
      total = 9
    },
    ["D-5|F-5"] = {
      next = {
        ["E-5"] = 1
      },
      total = 1
    },
    ["D-6|..."] = {
      next = {
        ["B-5"] = 0.66666666666667,
        ["G-6"] = 0.33333333333333
      },
      total = 3
    },
    ["E-4|..."] = {
      next = {
        ["..."] = 0.19047619047619,
        ["B-5"] = 0.047619047619048,
        ["C-4"] = 0.14285714285714,
        ["D-4"] = 0.23809523809524,
        ["F-4"] = 0.19047619047619,
        ["G-4"] = 0.19047619047619
      },
      total = 21
    },
    ["E-4|D-4"] = {
      next = {
        ["C-4"] = 1
      },
      total = 2
    },
    ["E-4|F-4"] = {
      next = {
        ["G-4"] = 1
      },
      total = 2
    },
    ["E-5|..."] = {
      next = {
        ["..."] = 0.18604651162791,
        ["A-5"] = 0.046511627906977,
        ["C-5"] = 0.27906976744186,
        ["D-5"] = 0.2093023255814,
        ["E-5"] = 0.069767441860465,
        ["F-5"] = 0.093023255813953,
        ["G-4"] = 0.023255813953488,
        ["G-5"] = 0.093023255813953
      },
      total = 43
    },
    ["E-5|C-5"] = {
      next = {
        ["E-5"] = 1
      },
      total = 1
    },
    ["E-5|D-5"] = {
      next = {
        ["..."] = 0.125,
        ["C-5"] = 0.75,
        ["F-5"] = 0.125
      },
      total = 8
    },
    ["E-5|E-5"] = {
      next = {
        ["F-5"] = 1
      },
      total = 1
    },
    ["E-5|F-5"] = {
      next = {
        ["..."] = 0.5,
        ["E-5"] = 0.4,
        ["G-5"] = 0.1
      },
      total = 10
    },
    ["E-5|G-5"] = {
      next = {
        ["..."] = 0.5,
        ["F-5"] = 0.5
      },
      total = 2
    },
    ["F-3|..."] = {
      next = {
        ["C-4"] = 1
      },
      total = 3
    },
    ["F-4|..."] = {
      next = {
        ["D-4"] = 0.11111111111111,
        ["E-4"] = 0.44444444444444,
        ["G-4"] = 0.44444444444444
      },
      total = 9
    },
    ["F-4|D-4"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["F-4|E-4"] = {
      next = {
        ["D-4"] = 1
      },
      total = 2
    },
    ["F-4|F-4"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["F-4|G-4"] = {
      next = {
        ["A-4"] = 1
      },
      total = 2
    },
    ["F-5|..."] = {
      next = {
        ["..."] = 0.2,
        ["A-5"] = 0.066666666666667,
        ["D-5"] = 0.2,
        ["E-5"] = 0.46666666666667,
        ["G-5"] = 0.066666666666667
      },
      total = 15
    },
    ["F-5|A-5"] = {
      next = {
        ["G-5"] = 1
      },
      total = 1
    },
    ["F-5|D-5"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["F-5|E-5"] = {
      next = {
        ["..."] = 0.5,
        ["D-5"] = 0.16666666666667,
        ["F-5"] = 0.16666666666667,
        ["G-5"] = 0.16666666666667
      },
      total = 6
    },
    ["F-5|G-5"] = {
      next = {
        ["..."] = 0.75,
        ["A-5"] = 0.25
      },
      total = 4
    },
    ["G-3|..."] = {
      next = {
        ["C-4"] = 0.5,
        ["D-4"] = 0.25,
        ["F-3"] = 0.25
      },
      total = 4
    },
    ["G-3|G-5"] = {
      next = {
        ["..."] = 0.5,
        ["G-3"] = 0.5
      },
      total = 2
    },
    ["G-4|..."] = {
      next = {
        ["..."] = 0.090909090909091,
        ["A-4"] = 0.090909090909091,
        ["C-4"] = 0.045454545454545,
        ["C-5"] = 0.18181818181818,
        ["D-5"] = 0.045454545454545,
        ["E-4"] = 0.22727272727273,
        ["E-5"] = 0.045454545454545,
        ["F-4"] = 0.27272727272727
      },
      total = 22
    },
    ["G-4|A-4"] = {
      next = {
        ["B-4"] = 1
      },
      total = 2
    },
    ["G-4|E-4"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["G-4|F-4"] = {
      next = {
        ["E-4"] = 1
      },
      total = 2
    },
    ["G-5|..."] = {
      next = {
        ["..."] = 0.35,
        ["A-5"] = 0.05,
        ["B-5"] = 0.05,
        ["C-5"] = 0.05,
        ["D-4"] = 0.05,
        ["E-5"] = 0.25,
        ["F-5"] = 0.2
      },
      total = 20
    },
    ["G-5|A-5"] = {
      next = {
        ["..."] = 0.5,
        ["G-5"] = 0.5
      },
      total = 4
    },
    ["G-5|E-5"] = {
      next = {
        ["..."] = 1
      },
      total = 1
    },
    ["G-5|F-5"] = {
      next = {
        ["A-5"] = 1
      },
      total = 1
    },
    ["G-5|G-3"] = {
      next = {
        ["G-5"] = 1
      },
      total = 1
    },
    ["G-6|..."] = {
      next = {
        ["D-6"] = 1
      },
      total = 1
    }
  },
  order = 2
}

local function musicator_unmake_key(k)
  local result = {}
  for t in string.gmatch(k, "[^|]+") do
    result[#result + 1] = t
  end

  return result
end

local function musicator_count_notes(sequence)
  local result = 0

  for i,v in ipairs(sequence) do
    if not (v == "...") then
      result = result + 1
    end
  end

  return result
end

function musicator_generate_sequence(model_data, length)
  local order = model_data.order
  local model = model_data.model

  -- random start key
  local model_keys = {}
  for k,_ in pairs(model) do
    model_keys[#model_keys + 1] = k
  end
  local start_key = model_keys[math.ceil(math.random() * #model_keys)]

  -- sequence starts with the start key
  local seq = musicator_unmake_key(start_key)

  -- generation loop
  while musicator_count_notes(seq) < length do
    local current_key = table.concat({unpack(seq, #seq - order + 1, #seq)}, "|")

    local chosen = "..."

    local key_data = model[current_key]
    if key_data then
      local r = math.random()
      local prob_sum = 0.0
      for new_note, new_prob in pairs(key_data.next) do
        prob_sum = prob_sum + new_prob
        if prob_sum < r then
          chosen = new_note
        end
      end
    end

--    print(current_key .. " --> " .. chosen)

    seq[#seq+1] = chosen
  end

  return seq
end

function musicator_row_to_frame(row, bpm, spd)
  local frames_per_row = (150 * spd) / bpm
  return math.floor(row * frames_per_row)
end

function musicator_note_to_direction(note)
  local subnote = note:sub(1,1)

  local mapping = {
    C="left",
    D="up",
    E="up",
    F="right",
    G="right",
    A="down"
  }

  return mapping[subnote] or "up"
end

-- converts generated sequence to pattern that the ddr minigame can consume
function musicator_sequence_to_pattern(sequence, bpm, spd)
  local result = {}

  for i, note in ipairs(sequence) do
    if not (note == "...") then

      local at_ms = musicator_row_to_frame(i, bpm, spd)
      local direction = musicator_note_to_direction(note)
    
      result[#result + 1] = { frame=at_ms, dir=direction, note=note }
    end
  end

  return result
end

function musicator_generate_pattern(length, bpm, spd)
  return musicator_sequence_to_pattern(musicator_generate_sequence(musicator_markov_model, length), bpm, spd)
end
