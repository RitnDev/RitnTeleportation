---
-- Fonction "enemy"
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
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



local function pollution_by_surface(LuaSurface)
    if global.teleport.surfaces[LuaSurface.name] then 
        if global.teleport.surfaces[LuaSurface.name].pollution then                     
            local count = global.teleport.surfaces[LuaSurface.name].pollution.count
            local pollution_total = LuaSurface.get_total_pollution()
            global.teleport.surfaces[LuaSurface.name].pollution.last = global.teleport.surfaces[LuaSurface.name].pollution.current
            global.teleport.surfaces[LuaSurface.name].pollution.current = pollution_total
            local ecart = global.teleport.surfaces[LuaSurface.name].pollution.current - global.teleport.surfaces[LuaSurface.name].pollution.last
            if ecart > 0 then 
                global.teleport.surfaces[LuaSurface.name].pollution.count = count + ecart
            end
        end
    end
end


local function evolution_by_surface(LuaSurface)
    if global.teleport.surfaces[LuaSurface.name] then  
        if global.teleport.surfaces[LuaSurface.name].pollution then                     
            local count = global.teleport.surfaces[LuaSurface.name].pollution.count
            local time = global.teleport.surfaces[LuaSurface.name].time
            local time_factor = global.map_settings.enemy_evolution.time_factor
            local pollution_factor = global.map_settings.enemy_evolution.pollution_factor
            local enemy_name = "enemy"
            if LuaSurface.name ~= "nauvis" then 
                enemy_name = prefix_enemy .. LuaSurface.name
            end

            if game.forces[enemy_name] then 
                -- calcul de l'evolution (by time & pollution)
                if global.teleport.surfaces[LuaSurface.name].map_used then 
                    game.forces[enemy_name].evolution_factor_by_time = time * time_factor
                end
                game.forces[enemy_name].evolution_factor_by_pollution = count * pollution_factor

                local evo_kill = game.forces[enemy_name].evolution_factor_by_killing_spawners
                local evo_pol = game.forces[enemy_name].evolution_factor_by_pollution
                local evo_time = game.forces[enemy_name].evolution_factor_by_time
                -- calcul de l'evolution total
                local evo = 1 - ((1-evo_kill) * (1-evo_pol) * (1-evo_time))
                -- renvoi du calcul sur la force enemy
                game.forces[enemy_name].evolution_factor = evo
            end
        end
    end
end


----------------------------
-- Chargement des fonctions
local flib = {}
flib.getEvoFactor = get_evo_factor
flib.pollution_by_surface = pollution_by_surface
flib.evolution_by_surface = evolution_by_surface

-- Retourne la liste des fonctions
return flib