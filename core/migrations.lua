-- MIGRATION
----------------------------------------------------
local module = {}
module.events = {}
local prefix_enemy = ritnmods.teleport.defines.prefix.enemy



-- Quand un joueur arrive en jeu
local function on_player_joined_game(e)

    local LuaPlayer = game.players[e.player_index]

    -- Récupération de la version du mod actuelle
    local version = game.active_mods.RitnTeleportation

    pcall(function() 
        if global.mod_version ~= version then 
            global.migration = true
        end
    end)

    if not global.mod_version then
        -- Ajout de la variable global : mod_version
        global.mod_version = "0.0.0"
        global.migration = true
        -- maj de la structure à la première connexion du premier joueur
        pcall(function() 
            if global.teleport.surfaces.surface_value ~= nil then
                local val = global.teleport.surfaces.surface_value
                global.teleport.surface_value = val
                global.teleport.surfaces.surface_value = nil
                for _,surface in pairs(game.surfaces) do 
                    if global.teleport.surfaces[surface.name] then 
                        global.teleport.surfaces[surface.name].name = surface.name
                    end
                end
            end
        end)

    end

    local pattern = "([^.]*).?([^.]*).?([^.]*)"
    local vX, vY, vZ = string.match(global.mod_version, pattern)


    if tonumber(vZ) ~= nil then
        if tonumber(vX) <= 2 and tonumber(vY) <= 0 then 
            if tonumber(vZ) <= 25 then 

                -- reset de l'evolution de toute les force
                for _,force in pairs(game.forces) do   
                    if string.sub(force.name,1,5) == "enemy" then      
                        force.evolution_factor = 0     
                        force.evolution_factor_by_pollution = 0   
                        force.evolution_factor_by_time = 0
                    end 
                end

                -- valeur d'evolution par défaut
                local time_factor =      0.0000040  -- 40
                local pollution_factor = 0.0000009  -- 9
                local destroy_factor =   0.00200    -- 200

                -- creation de la structure map_settings en global
                local map_settings = game.map_settings
                global.map_settings = {}
                global.map_settings.pollution = { enabled = map_settings.pollution.enabled}
        
                global.map_settings.enemy_evolution = {
                    enabled = map_settings.enemy_evolution.enabled,
                    time_factor = time_factor,
                    destroy_factor = destroy_factor,
                    pollution_factor = pollution_factor,
                }
                global.map_settings.enemy_expansion = {enabled = map_settings.enemy_expansion.enabled}

                -- mise à zero
                game.map_settings.enemy_evolution.time_factor = 0
                game.map_settings.enemy_evolution.pollution_factor = 0

                -- creation de la structure dans les 
                for _,surface in pairs(global.teleport.surfaces) do
                    surface.pollution = {
                        last = 0,
                        current = 0,
                        count = 0,
                    }
                    surface.time = 0
                end

            end
        end
    end

    --fix on_player_left_game (load local save)
    if game.is_multiplayer() == false  then
        pcall(function() 
            for _,surface in pairs(global.teleport.surfaces) do  
                surface.players = {}
            end
        end)
    end


    if global.migration == true then
        global.migration = false
        global.mod_version = version
    end

end



module.events[defines.events.on_player_joined_game] = on_player_joined_game
return module