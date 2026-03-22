-- key separator: |
-- empty note: "..."

math.randomseed(os.time())

local unpack = unpack or table.unpack

local function make_key(tbl)
  return table.concat(tbl, "|")
end

local function unmake_key(k)
  local result = {}
  for t in string.gmatch(k, "[^|]+") do
    result[#result + 1] = t
  end

  return result
end

local function add_key(str, value)
  return str .. "|" .. value
end

local function split_last(full)
  local i = full:match(".*()|")
  return full:sub(1, i-1), full:sub(i+1)
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- helper: split key into parts
local function split(k)
  local t = {}
  for part in string.gmatch(k, "[^|]+") do
    t[#t+1] = part
  end
  return t
end

function build_markov_model(sequence, order)
  -- TODO: add {"..." x order} to beginning?

  local model = { }

  -- count
  for i = 1, #sequence - order do
    local key = make_key({unpack(sequence, i, i + order - 1)})
    local next_note = sequence[i + order]

    local data = model[key] or { next={}, total=0 }

    data.next[next_note] = (data.next[next_note] or 0) + 1
    data.total = data.total + 1

    model[key] = data
  end

  -- normalize
  for temp_key,temp_data in pairs(model) do
    for temp_note, temp_count in pairs(temp_data.next) do
      model[temp_key].next[temp_note] = temp_count / temp_data.total
    end
  end

--[[
  for k,v in pairs(model) do
    print("-----" .. k)
    for k2,v2 in pairs(v.next) do
      print(k2, v2)
    end
  end
--]]

  return {
    order = order,
    model = model
  }
end

function generate_sequence(model_data, length)
  local order = model_data.order
  local model_data = model_data.model

  -- random start key
  local model_keys = {}
  for k,_ in pairs(model) do
    model_keys[#model_keys + 1] = k
  end
  local start_key = model_keys[math.ceil(math.random() * #model_keys)]

  -- sequence starts with the start key
  local seq = unmake_key(start_key)

  -- generation loop
  while #seq < length do
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
