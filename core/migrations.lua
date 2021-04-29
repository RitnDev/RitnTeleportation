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
        if tonumber(vX) <= 1 and tonumber(vY) <= 4 then 

            if tonumber(vZ) <= (30 or 31) then
                -- maj de la structure à la première connexion du premier joueur
                pcall(function() 
                    for _,surface in pairs(game.surfaces) do 
                        if global.teleport.surfaces[surface.name] then 
                            if settings.startup[ritnmods.teleport.defines.name.settings.restart].value == true then
                                global.teleport.surfaces[surface.name].finish = true
                            end
                        end
                    end
                end)

            end
        
            if tonumber(vZ) <= 36 then
                -- maj de la structure à la première connexion du premier joueur
                pcall(function() 
                    for _,surface in pairs(global.teleport.surfaces) do 
                        
                        local portal_value, teleporter_value, portal_id_value, teleporter_id_value
                        portal_value = surface.portals[1].value
                        portal_id_value = surface.portals[1].id_value
                        teleporter_value = surface.teleporters[1].value
                        teleporter_id_value = surface.teleporters[1].id_value

                        surface.portals[1] = nil
                        surface.teleporters[1] = nil

                        surface.value = {
                            portal = portal_value,
                            id_portal = portal_id_value,
                            teleporter = teleporter_value,
                            id_teleporter = teleporter_id_value,
                        }
                    end
                end)

            end

            if tonumber(vZ) <= 40 then
                pcall(function() 
                    for _,surface in pairs(global.teleport.surfaces) do 
                        if surface.name ~= "nauvis" then
                            if game.players[surface.name] then
                                surface.exception = game.players[surface.name].admin
                                surface.last_use = game.tick
                                surface.map_used = false
                            else
                                surface.exception = false
                                surface.last_use = game.tick
                                surface.map_used = false
                            end
                        else
                            surface.exception = true
                            surface.last_use = 0
                            surface.map_used = true
                        end
                    end
                end)
            end

            
            if tonumber(vZ) <= 43 then
                pcall(function() 
                    if not global.settings then global.settings = {} end
                end)
            end


            if tonumber(vZ) <= (44 or 61 or 62)  then
                pcall(function() 
                    for _,surface in pairs(global.teleport.surfaces) do  
                        surface.players = {}
                    end
                end)
            end

        end

        if tonumber(vX) <= 1 and tonumber(vY) <= 5 then 
            
            --1.5.0
            if tonumber(vZ) >= 0 then 

                global.enemy = {
                    setting = settings.startup[ritnmods.teleport.defines.name.settings.enemy].value,
                    value = false
                }

                -- Recupération des settings de la map (nauvis)
                if global.map_gen_settings.seed then 
                    if global.map_gen_settings["autoplace_controls"]["enemy-base"].size == 0 then 
                        global.enemy.value = false
                    else
                        global.enemy.value = true
                    end
                end
            end

            if tonumber(vZ) <= 4 then 
                for _,force in pairs(game.forces) do 
                    if string.sub(force.name, 1, string.len(prefix_enemy)) == prefix_enemy then 
                        if force.ai_controllable == false then
                            force.ai_controllable = true
                        end
                    end
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