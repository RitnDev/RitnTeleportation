---
-- Fonction de base
---
local prefix_enemy = ritnmods.teleport.defines.prefix.enemy


-- create log via RitnLog (remote command)
local function pcallLog(details, ev, event_name)
    local statut, errorMsg = pcall(function() 
        local data = {}
        if type(details) == "table" then 
            data = details
        else 
            data.details = details
        end
        if event_name ~= nil then 
            data.event_name = eventName 
        end
        remote.call("ritnlog", "trace_event", {mod_name="RitnTP", data=data, e=ev}) 
    end)
    if statut == (false or nil) then 
        log("[RITNTP] > Error log : " .. errorMsg) 
    end
end

-- Le tableau est plein ?
local function tableBusy(T)
    for k,v in pairs(T) do
        if T[k] ~= nil then 
            return true
        end
    end
    return false
end

--ritnPrint
local function ritnPrint(txt)
    if game.players.Ritn.valid then
        game.players.Ritn.print(txt)
    end
end


-- Fonction SPLIT
local function split(str, delimiteur) 
    local delim = string.find(str, delimiteur)
    local num_x = tonumber(string.sub(str,1,delim-1))
    local num_y = tonumber(string.sub(str,delim+1))
  
    local t = {
      x = num_x,
      y = num_y
    }
  
    return t
end
  
--récupère le nombre d'entité / items
local function getn(tab)
    if tab ~= nil then
        if type(tab.n) == "number" then return t.n end
        local result = 0
        for i, _ in pairs(tab) do
            if type(i) == "number" and i>result then 
              result=i 
            end
        end
        return result
    else
        return 0
    end
end

-- retourne une position selon l'index joueur
local function positionTP(LuaPlayer, pointOrigine)
    local point = 0.0
    if pointOrigine ~= nil then 
        point = pointOrigine
    end
    point = point + (0.3 * LuaPlayer.index)
    return point
end



local function clean(player_name, LuaPlayer)
    if player_name == nil then return end 

    -- vérification que personne est présent sur la map.
    if global.teleport.surfaces[player_name] then
        if game.surfaces[player_name] then

            local result = false
            for _,player in pairs(game.players) do 
                if global.teleport.players[player.name] then -- fix 2.0.9
                    if global.teleport.players[player.name].origine == player_name 
                    or player.surface.name == player_name then
                        if player.connected == true then
                            -- des joueurs sont connecté : annulation du clean.
                            result = true
                        end
                    end
                end
            end
            -- clean annulé
            if result == true then
                if LuaPlayer then LuaPlayer.print("Clean impossible") end
                log("[RITNTP] > Clean impossible")
                return 
            end

            -- Supression de la map d'origine
            for i,player in pairs(global.teleport.surfaces[player_name].origine) do 
                global.teleport.players[player] = nil
            end

            game.delete_surface(player_name) 
        end

        if game.forces[player_name] then game.merge_forces(game.forces[player_name], "player") end
        if game.forces[prefix_enemy .. player_name] then game.merge_forces(game.forces[prefix_enemy .. player_name], "enemy") end
        global.teleport.surfaces[player_name] = nil
        global.teleport.surface_value = global.teleport.surface_value - 1
        
        -- message de confirmation
        if LuaPlayer then 
            LuaPlayer.print("Clean OK for : " .. player_name) 
        end
        log("[RITNTP] > CLEAN OK for : " .. player_name)
    end
end



local function restart(LuaPlayer)
    local surface = LuaPlayer.surface.name
    if LuaPlayer.name ~= surface then return end
    if surface == nil then return end

    local tab_player = {}

    if global.teleport.surfaces[surface] then
        if game.surfaces[surface] then 
            local result = false 
            for _,player in pairs(game.players) do 
                if player.surface.name == surface then 
                    if global.teleport.players[player.name] then  -- fix 2.0.21
                        if global.teleport.players[player.name].origine ~= surface then
                            if player.connected == true then
                                result = true
                            end  
                        end
                    end
                end
            end
            if result == true then 
                LuaPlayer.print("Restart impossible")
                log("[RITNTP] > Restart impossible")
                return 
            end
            
            -- modif 1.8.0
            for i,player in pairs(global.teleport.surfaces[surface].origine) do 
                global.teleport.players[player] = nil

                -- modif 1.8.3
                game.players[player].teleport({i-1,i-1}, "nauvis")
                if game.players[player].character then 
                    game.players[player].character.active = false
                end
                table.insert(tab_player, player)
            end
            
            game.delete_surface(surface)
        end
        if game.forces[surface] then game.merge_forces(game.forces[surface], "player") end
        if game.forces[prefix_enemy .. surface] then game.merge_forces(game.forces[prefix_enemy .. surface], "enemy") end
        global.teleport.surfaces[surface] = nil
        global.teleport.surface_value = global.teleport.surface_value - 1
        log("[RITNTP] > RESTART OK for : " .. LuaPlayer.name)

        for i = 1, #tab_player do 
            local player = tab_player[i]
            game.players[player].teleport({0,0}, "lobby~" .. player)
            game.players[player].clear_items_inside()
        end
    end
    
end



local function add_exception(player_name)
    local result = false
    if not game.players[player_name] then return result end
    if not game.surfaces[player_name] then return result end
    if not global.teleport.surfaces[player_name] then return result end
    if global.teleport.surfaces[player_name].exception == true then return result end
    global.teleport.surfaces[player_name].exception = true
    result = true
    return result
end

local function remove_exception(player_name)
    local result = false
    if not game.players[player_name] then return result end
    if game.players[player_name].admin == true then return result end
    if not game.surfaces[player_name] then return result end
    if not global.teleport.surfaces[player_name] then return result end
    if global.teleport.surfaces[player_name].exception == false then return result end
    global.teleport.surfaces[player_name].exception = false
    global.teleport.surfaces[player_name].last_use = game.tick
    result = true
    return result
end

local function view_exception(LuaPlayer)
    if LuaPlayer then LuaPlayer.print("Exceptions :") else print("Exceptions :") end
    for _,player in pairs(global.teleport.surfaces) do
        if player.name ~= "nauvis" then 
            if player.exception == true then
                if LuaPlayer then
                    LuaPlayer.print("> " .. player.name)
                else
                    print("> " .. player.name)
                end
            end
        end
    end
end


local function add_settings_player(LuaPlayer, setting, value)
    if global.settings then 
        if not global.settings[LuaPlayer.name] then global.settings[LuaPlayer.name] = {
            [setting] = value,
        }
        else
            if not global.settings[LuaPlayer.name][setting] then 
                local input = {[setting] = value,}
                table.insert(global.settings[LuaPlayer.name],input)
            end
        end
    end
end

local function changeValue_settings_player(LuaPlayer, setting, value)
    if global.settings then 
        if global.settings[LuaPlayer.name] then 
            if global.settings[LuaPlayer.name][setting] ~= nil then 
                global.settings[LuaPlayer.name][setting] = value
            end
        end
    end
end

local function remove_settings_player(LuaPlayer, setting, value)
    if global.settings then 
        if global.settings[LuaPlayer.name] then 
            if global.settings[LuaPlayer.name][setting] then 
                global.settings[LuaPlayer.name][setting] = nil
            end
        end
    end
end


-- Recupération des settings de la map (nauvis)
local function mapGeneratorNewSeed()

    if not global.map_gen_settings.seed then 
        game.map_settings.enemy_evolution.time_factor = 0   -- add 1.5.7
        global.map_gen_settings = game.surfaces.nauvis.map_gen_settings
        --add 1.5.0
        if global.map_gen_settings["autoplace_controls"]["enemy-base"].size == 0 then 
        global.enemy.value = false
        else
        global.enemy.value = true
        end
    end

    local map_gen = global.map_gen_settings

    if global.generate_seed == false and game.is_multiplayer() then
        -- Change la seed
        map_gen.seed = math.random(1,4294967290)
    end

  return map_gen

end


-- Sauvegarde de partie avant déclenchement d'erreur
local function saveGameError(retValue, output)
    -- save game
    game.auto_save("rescue-ritntp")
    --print error console
    log("ERROR RitnTP : " .. retValue)
    --print("error-report -> Factorio/write-output/RitnTeleportation/error/error-report.json")
    --write file output 
    --game.write_file("RitnTeleportation/error/error-report_" .. game.tick .. ".json", output)
    -- stop server by error()
    error("ERROR RitnTP : " .. retValue) --.. "\n\nerror-report -> Factorio/write-output/RitnTeleportation/error/error-report.json")
end




----------------------------
-- Chargement des fonctions
local flib = {}
flib.tableBusy = tableBusy
flib.split = split
flib.getn = getn
flib.ritnPrint = ritnPrint
flib.pcallLog = pcallLog
flib.positionTP = positionTP
flib.clean = clean
flib.restart = restart
flib.mapGeneratorNewSeed = mapGeneratorNewSeed
flib.exception = {
    add = add_exception,
    remove = remove_exception,
    view = view_exception,
}
flib.settings = {
    add = add_settings_player,
    changeValue = changeValue_settings_player,
    remove = remove_settings_player
}
flib.saveGameError = saveGameError

-- Retourne la liste des fonctions
return flib