unpack = unpack or table.unpack

function build_markov_model(sequence, order)
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

  local counts = {}
  local totals = {}

  -- count
  for i = 1, #sequence - order do
    local notes = make_key({unpack(sequence, i, i + order - 1)})
    totals[notes] = (totals[notes] or 0) + 1

    local notes_full = add_key(notes, sequence[i + order])
    counts[notes_full] = (counts[notes_full] or 0) + 1
  end

  -- build model
  local model = {}

  for notes_full,count in pairs(counts) do
    local notes, _ = split_last(notes_full)

    model[notes_full] = count[notes_full] / total[notes]
  end

  return {
    order = order,
    model = model,
    counts = counts -- keep raw counts (useful!)
  }
end

function generate_sequence(model_data, length)
  local model = model_data.model
  local order = model_data.order

  -- helper: split key into parts
  local function split(k)
    local t = {}
    for part in string.gmatch(k, "[^|]+") do
      t[#t+1] = part
    end
    return t
  end

  -- pick random starting state
  local start_key
  for k,_ in pairs(model) do
    start_key = k
    break
  end

  -- (optional: better random start)
  for k,_ in pairs(model) do
    if math.random() < 0.1 then
      start_key = k
    end
  end

  local parts = split(start_key)

  -- initial sequence = first `order` items
  local seq = {}
  for i = 1, order do
    seq[i] = parts[i]
  end

  -- generation loop
  while #seq < length do
    -- build current state key
    local state = table.concat({unpack(seq, #seq - order + 1, #seq)}, "|")

    -- collect matching transitions
    local matches = {}
    for full,prob in pairs(model) do
      if full:sub(1, #state) == state and full:sub(#state+1, #state+1) == "|" then
        matches[#matches+1] = {key=full, prob=prob}
      end
    end

    if #matches == 0 then break end

    -- weighted pick
    local r = math.random()
    local sum = 0

    local chosen
    for _,m in ipairs(matches) do
      sum = sum + m.prob
      if r <= sum then
        chosen = m.key
        break
      end
    end

    if not chosen then
      chosen = matches[#matches].key
    end

    -- extract next symbol (after last '|')
    local next_symbol = chosen:match("|([^|]+)$")

    seq[#seq+1] = next_symbol
  end

  return seq
end

-- todo: feed samples
