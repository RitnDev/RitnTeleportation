---------------------------------------------------------------------------------------------
-- >>  GUI PORTAL
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.request =        require(ritnmods.teleport.defines.gui.request.GuiElements)
ritnGui.menu    =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.request.action = require(ritnmods.teleport.defines.gui.request.action)
---------------------------------------------------------------------------------------------
local modGui = require("mod-gui")
local prefix_gui = ritnmods.teleport.defines.prefix.gui
local prefix_menu = ritnmods.teleport.defines.name.gui.prefix.menu
local prefix_request = ritnmods.teleport.defines.name.gui.prefix.request
local flow_common = prefix_gui .. ritnmods.teleport.defines.name.gui.flow_common
local definesGuiRequest = ritnmods.teleport.defines.name.gui.request
local flow_request = prefix_request .. definesGuiRequest.flow_request


---
-- Events GUI
---

-- Quand un joueur arrive en jeu : ajout du flow_common dans "left"
local function on_player_joined_game(e)
    local LuaPlayer = game.players[e.player_index]

    if LuaPlayer.connected and LuaPlayer.valid then 
        local left = modGui.get_frame_flow(LuaPlayer)
        local content = {}
        
        -- Verif que le flow commun est présent
        if not left[flow_common] then 
            -- flow commun - RitnTP
            content.main = ritnlib.gui.createFlowV(
                left,
                flow_common
            )
            -- flow pour le menu principal de RitnTP
            content.menu = ritnlib.gui.createFlowH(
                content.main,
                prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_menu
            )
            -- flow des requests demandant de rejoindre la map.
            content.request = ritnlib.gui.createFlowV(
                content.main,
                flow_request
            )
        end
        local details = {
            lib = "modules",
            category = "gui_request",
        }
        ritnlib.utils.pcallLog(details, e)
    end
end



-- Fonction : on_gui_click
local function on_gui_click(e)
    local element = e.element
    local LuaPlayer = game.players[e.player_index]
    local left = modGui.get_frame_flow(LuaPlayer)
    if not left[flow_common] then 
        on_player_joined_game(e)
    end
    local LuaGui = left[flow_common][flow_request]
    local parent = element.parent
    local pattern = "([^-]*)-?([^-]*)-?([^-]*)"
    local LuaGui_name = ""
    local click = {
      ui, element, name, action
    }
  
    -- Action de la frame : Gui_Lobby
    if LuaGui == nil then return end
    if parent == nil then return end 

    LuaGui_name = flow_request
    if LuaGui.name ~= LuaGui_name then return end
    if element == nil then return end
    if element.valid == false then return end
    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(element.name, pattern)
    click.action = click.element .. "-" .. click.name

    -- Actions
    if click.ui == "request" then
        -- recupération du nom du demandeur
        local request_name = string.sub(parent.name,21)
        if not game.players[request_name] then return end

        if click.element ~= "button" then return end
        if not ritnGui.request.action[click.action] then return end
        ritnGui.request.action[click.action](LuaPlayer, request_name)

        local details = {
            lib = "modules",
            category = "gui_request",
        }
        ritnlib.utils.pcallLog(details, e)
        return
    end


end





-- Creation du module
-----------------------
local module = {}
module.events = {}
-----------------------
module.events[defines.events.on_player_joined_game] = on_player_joined_game
module.events[defines.events.on_gui_click] = on_gui_click
-----------------------
return module