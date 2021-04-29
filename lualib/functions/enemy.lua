---
-- Fonction "enemy"
---
local prefix_enemy = ritnmods.teleport.defines.prefix.enemy


local function get_evo_factor(LuaSurface, format)
    
    local enemy = prefix_enemy .. LuaSurface.name
    local percent_evo_factor = 0

    if game.forces[enemy] ~= nil then
        percent_evo_factor = game.forces[enemy].evolution_factor * 100
    else
        percent_evo_factor = game.forces.enemy.evolution_factor * 100  
    end
    local whole_number = math.floor(percent_evo_factor)
    local fractional_component = math.floor((percent_evo_factor - whole_number) * 10)

    return string.format(format, whole_number, fractional_component)
end




----------------------------
-- Chargement des fonctions
local flib = {}
flib.getEvoFactor = get_evo_factor

-- Retourne la liste des fonctions
return flib