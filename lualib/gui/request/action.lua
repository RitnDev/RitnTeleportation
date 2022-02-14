-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
ritnlib.player =     require(ritnmods.teleport.defines.functions.player)
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.request =    require(ritnmods.teleport.defines.gui.request.GuiElements)
---------------------------------------------------------------------------------------------
local modGui = require("mod-gui")

local action = {
    [ritnmods.teleport.defines.name.gui.request.button_accept] = {},
    [ritnmods.teleport.defines.name.gui.request.button_reject] = {},
    [ritnmods.teleport.defines.name.gui.request.button_rejectAll] = {},
}


--- FONCTIONS :

-- Bouton accepter
local function button_accept(LuaPlayer, request_name)
    local reponse = {name = request_name}
    ritnlib.player.acceptRequest(LuaPlayer, reponse)
    ritnGui.request.close(LuaPlayer, reponse)
    ritnlib.utils.pcallLog("lib.gui.request.action.button_accept(" .. LuaPlayer.name .. ", " ..  request_name .. ")")
end

-- Bouton rejeter
local function button_reject(LuaPlayer, request_name)
    local reponse = {name = request_name}
    ritnlib.player.rejectRequest(LuaPlayer, reponse)
    ritnGui.request.close(LuaPlayer, reponse)
    ritnlib.utils.pcallLog("lib.gui.request.action.button_reject(" .. LuaPlayer.name .. ", " ..  request_name .. ")")
end

-- Bouton rejeter toute nouvelle demande
local function button_rejectAll(LuaPlayer, request_name)
    local reponse = {name = request_name}
    ritnlib.player.rejectAllRequest(LuaPlayer, reponse)
    ritnGui.request.close(LuaPlayer, reponse)
    ritnlib.utils.pcallLog("lib.gui.request.action.button_rejectAll(" .. LuaPlayer.name .. ", " ..  request_name .. ")")
end



-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.request.button_accept] = button_accept
action[ritnmods.teleport.defines.name.gui.request.button_reject] = button_reject
action[ritnmods.teleport.defines.name.gui.request.button_rejectAll] = button_rejectAll

return action