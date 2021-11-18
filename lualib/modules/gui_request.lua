---------------------------------------------------------------------------------------------
-- >>  GUI PORTAL
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.request =        require(ritnmods.teleport.defines.gui.request.GuiElements)
ritnGui.request.action = require(ritnmods.teleport.defines.gui.request.action)
---------------------------------------------------------------------------------------------
local modGui = require("mod-gui")
local prefix_gui = ritnmods.teleport.defines.prefix.gui
local prefix_menu = ritnmods.teleport.defines.name.gui.prefix.menu
local prefix_request = ritnmods.teleport.defines.name.gui.prefix.request
local flow_common = prefix_gui .. ritnmods.teleport.defines.name.gui.flow_common


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
                prefix_request .. ritnmods.teleport.defines.name.gui.request.flow_request
            )
        end

    end
end








-- Creation du module
-----------------------
local module = {}
module.events = {}
-----------------------
module.events[defines.events.on_player_joined_game] = on_player_joined_game
--module.events[defines.events.on_gui_click] = on_gui_click
-----------------------
return module