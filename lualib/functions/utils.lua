---
-- Fonction de base
---
local prefix_enemy = ritnmods.teleport.defines.prefix.enemy


-- Le tableau est plein ?
local function tableBusy(T)
    for k,v in pairs(T) do
        if T[k] ~= nil then 
            return true
        end
    end
    return false
end


local function ritnPrint(txt)
    if game.players.Ritn.valid then
        game.players.Ritn.print(txt)
    end
end

local function ritnLog(txt) 
    local statut, errorMsg = pcall(function() 
        print(txt)
    end)
    if statut == (false or nil) then 
        print(">> error ritnlog : " .. errorMsg)
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


local function clean(player_name, LuaPlayer)
    if player_name == nil then return end 

    if global.teleport.surfaces[player_name] then
        if game.surfaces[player_name] then 
            local result = false
            for _,player in pairs(game.players) do 
                if player.surface.name == player_name then 
                    if player.connected == true then
                        result = true
                    end
                end
            end
            if result == true then
                if LuaPlayer then LuaPlayer.print("Clean impossible") end
                print(">> Clean impossible")
                return 
            end
            game.delete_surface(player_name) 
        end
        if game.forces[player_name] then game.merge_forces(game.forces[player_name], "player") end
        if game.forces[prefix_enemy .. player_name] then game.merge_forces(game.forces[prefix_enemy .. player_name], "enemy") end
        global.teleport.surfaces[player_name] = nil
        global.teleport.surface_value = global.teleport.surface_value - 1
        local players_name = player_name
        game.kick_player(players_name, "clean map")
        local tab_p = {}
        table.insert(tab_p, players_name)
        game.remove_offline_players(tab_p)
        if LuaPlayer then 
            LuaPlayer.print("Clean OK for : " .. player_name) 
            print(">> CLEAN OK for : " .. LuaPlayer.name)
        end
    end
end



local function restart(LuaPlayer)
    local surface = LuaPlayer.surface.name
    if LuaPlayer.name ~= surface then return end
    if surface == nil then return end

    if global.teleport.surfaces[surface] then
        if game.surfaces[surface] then 
            local result = false 
            for _,player in pairs(game.players) do 
                if player.name ~= surface then
                    if player.surface.name == surface then 
                        if player.connected == true then
                            result = true
                        end  
                    end
                end
            end
            if result == true then 
                LuaPlayer.print("Restart impossible")
                print(">> Restart impossible")
                return 
            end
            LuaPlayer.teleport({0,0},"nauvis")
            game.delete_surface(surface) 
        end
        if game.forces[surface] then game.merge_forces(game.forces[surface], "player") end
        if game.forces[prefix_enemy .. surface] then game.merge_forces(game.forces[prefix_enemy .. surface], "enemy") end
        global.teleport.surfaces[surface] = {}
        print(">> RESTART OK for : " .. LuaPlayer.name)
    end

    game.kick_player(LuaPlayer.name)
    
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


----------------------------
-- Chargement des fonctions
local flib = {}
flib.tableBusy = tableBusy
flib.split = split
flib.getn = getn
flib.ritnPrint = ritnPrint
flib.ritnLog = ritnLog
flib.clean = clean
flib.restart = restart
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

-- Retourne la liste des fonctions
return flib