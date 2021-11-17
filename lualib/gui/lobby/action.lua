-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.surface =     require(ritnmods.teleport.defines.functions.surface)
ritnlib.player =     require(ritnmods.teleport.defines.functions.player)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.lobby =        require(ritnmods.teleport.defines.gui.lobby.GuiElements)
---------------------------------------------------------------------------------------------
local prefix_lobby = ritnmods.teleport.defines.name.gui.prefix.lobby
local definesGuiLobby = ritnmods.teleport.defines.name.gui.lobby
---------------------------------------------------------------------------------------------
local action = {
    [ritnmods.teleport.defines.name.gui.lobby.button_create] = {},
    [ritnmods.teleport.defines.name.gui.lobby.button_request] = {},
}


-- Fonctions

-- renvoie l'element souhaitez selon son nom
local function returnElement(LuaPlayer, element_name)
    local center = LuaPlayer.gui.center
    local guiLobby = center[prefix_lobby .. definesGuiLobby.flow_common]

    if element_name == "list" then 
        return guiLobby[prefix_lobby .. definesGuiLobby.frame_lobby][prefix_lobby .. definesGuiLobby.MainFlow][prefix_lobby .. definesGuiLobby.SurfacesFlow][prefix_lobby .. definesGuiLobby.Pane][prefix_lobby .. definesGuiLobby.list]
    end
end




local function button_create(LuaPlayer)
    -- Creation de la surface joueur
    ritnlib.surface.createSurface(LuaPlayer)
    -- fermeture de la fenetre après la création de la map
    ritnGui.lobby.close(LuaPlayer)
end



local function button_request(LuaPlayer)
    local index = returnElement(LuaPlayer, "list").selected_index
    if index == nil or index == 0 then return end
    local surface = returnElement(LuaPlayer, "list").get_item(index)
    ritnlib.player.createRequest(LuaPlayer, surface)
end






-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.lobby.button_create] = button_create
action[ritnmods.teleport.defines.name.gui.lobby.button_request] = button_request

return action