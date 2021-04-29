
local function replace (str, what, with)
  what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
  return string.gsub(str, what, with)
end
local data_util = {}
data_util.replace = replace


--[[
mods are incompatible if they:
Teleport Items/entity
]]--

-- if a mod in this list any item teleportation mechanics when this mod is enabled it can be removed from the list
local incompatible_mod_keywords = {
  "teleport",
} -- can add a white list if these cause problems
for mod_name, version in pairs(mods) do
    local mod_name_format = string.lower(data_util.replace(mod_name, "_", "-"))
    for _, keyword in pairs(incompatible_mod_keywords) do
      if string.find(mod_name_format, keyword, 1, true) and mod_name ~= "Teleporters" then
        if mod_name ~= "RitnTeleportation" then
          error("Incompatibe mod: " .. mod_name) -- this should not happen unless a teleportation mod has been missed from the incompatability list
        end
      end
    end
end
