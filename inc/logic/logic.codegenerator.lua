--- @section CodeGenerator

CodeGenerator = {}

local SALT     = 27471
local BASE36   = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local NAME_LEN = 3

-- Per-position offsets derived from SALT so each character slot
-- maps to a different region of the 2-char base-36 space.
local SALTS = {
  SALT % 36,
  math.floor(SALT /   36) % 36,
  math.floor(SALT / 1296) % 36,
}

--- Encodes a number (0–935) as exactly 2 base-36 characters.
--- @within CodeGenerator
function CodeGenerator.encode_pair(n)
  return BASE36:sub(math.floor(n / 36) + 1, math.floor(n / 36) + 1)
      .. BASE36:sub(n % 36 + 1,              n % 36 + 1)
end

--- Decodes 2 base-36 characters back to a number.
--- @within CodeGenerator
function CodeGenerator.decode_pair(s)
  local d1 = BASE36:find(s:sub(1, 1), 1, true) - 1
  local d2 = BASE36:find(s:sub(2, 2), 1, true) - 1
  return d1 * 36 + d2
end

--- Encrypts a player name into a code twice its length.
--- Each input character (A-Z, value 0-25) is encoded as
--- c + SALTS[i] * 26, producing 2 base-36 output characters.
--- @within CodeGenerator
--- @param text string NAME_LEN-character uppercase player name.
--- @return string Encrypted code (2 * NAME_LEN base-36 characters).
function CodeGenerator.encrypt(text)
  local result = ""
  for i = 1, NAME_LEN do
    local c = math.max(0, (string.byte(text, i) or 65) - 65)
    result = result .. CodeGenerator.encode_pair(c + SALTS[i] * 26)
  end
  return result
end

--- Decrypts a personal code back to the original player name.
--- @within CodeGenerator
--- @param encrypted_text string The code to decrypt (2 * NAME_LEN chars).
--- @return string Original player name, or "???" if the code is invalid.
function CodeGenerator.decrypt(encrypted_text)
  local t = encrypted_text:upper()
  if #t ~= NAME_LEN * 2 then return "???" end
  local result = ""
  for i = 1, NAME_LEN do
    local pair = CodeGenerator.decode_pair(t:sub((i - 1) * 2 + 1, i * 2))
    result = result .. string.char(pair % 26 + 65)
  end
  return result
end
