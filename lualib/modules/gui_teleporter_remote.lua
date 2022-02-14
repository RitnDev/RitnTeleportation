---------------------------------------------------------------------------------------------
-- >>  GUI REMOTE TELEPORTER
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =    require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.utils =         require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.remote =        require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.remote.action = require(ritnmods.teleport.defines.gui.remote.action)
---------------------------------------------------------------------------------------------

-- INITIALISATION
-- Creation du module
local module = {}
module.events = {}

-- Chargement des elements à créer
local modGui = require("mod-gui")
local prefix = ritnmods.teleport.defines.name.gui.prefix.remote
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart



local function on_player_cursor_stack_changed(e)
    local LuaPlayer = game.players[e.player_index]


    if LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal] ~= nil then return end
    if LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain] ~= nil then return end
    -- fermeture du menu
    ritnGui.remote.close(LuaPlayer)

    -- On ouvre pas la fenêtre de portail si l'interface restart est déjà ouverte
    local center = LuaPlayer.gui.center
    local frame_restart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
    if frame_restart then return end
    

    if LuaPlayer.cursor_stack 
    and LuaPlayer.cursor_stack.valid 
    and LuaPlayer.cursor_stack.valid_for_read 
    and LuaPlayer.cursor_stack.name == ritnmods.teleport.defines.name.item.remote then
        ritnGui.remote.open(LuaPlayer)

        local details = {
            lib = "modules",
            category = "gui_teleporter_remote",
            func = "on_player_cursor_stack_changed",
            state = "ritnGui.remote.open(" .. LuaPlayer.name .. ")"
        }
        ritnlib.utils.pcallLog(details, e)
    else
        ritnGui.remote.close(LuaPlayer)
    end

end



-- Event click GUI
-- Déclenche les actions quand on clique sur les boutons du GUI
local function on_gui_click(e)
   
    local element = e.element
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    local left = modGui.get_frame_flow(LuaPlayer)
    local LuaGui = left[ritnmods.teleport.defines.name.gui.main_remote]
    local pattern = "([^-]*)-?([^-]*)-?([^-]*)"
    local click = {
        ui, element, name, action
    }
    
    if LuaGui == nil then return end 
    if LuaGui.name ~= ritnmods.teleport.defines.name.gui.main_remote then return end
    if element == nil then return end
    if element.valid == false then return end
      -- récupération des informations lors du clique
      click.ui, click.element, click.name = string.match(element.name, pattern)
      click.action = click.element .. "-" .. click.name
    
    if click.ui ~= "remote" then return end
    if click.element ~= "button" then return end
       
    ritnGui.remote.action[click.action](LuaPlayer)

end


module.events[defines.events.on_gui_click] = on_gui_click
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed

return module