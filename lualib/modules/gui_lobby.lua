---------------------------------------------------------------------------------------------
-- >>  GUI LOBBY
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.lobby =        require(ritnmods.teleport.defines.gui.lobby.GuiElements)
ritnGui.lobby.action = require(ritnmods.teleport.defines.gui.lobby.action)
---------------------------------------------------------------------------------------------


-- Fonction : on_gui_click
local function on_gui_click(e)
    local element = e.element
    local LuaPlayer = game.players[e.player_index]
    local center = LuaPlayer.gui.center
    --local LuaGui = center[ritnmods.teleport.defines.gui.lobby.frame.name]
    local pattern = "([^-]*)-?([^-]*)-?([^-]*)"
    local LuaGui_name = ""
    local click = {
      ui, element, name, action
    }
  
    -- Action de la frame : Gui Editor
    if LuaGui == nil then return end
    
    --LuaGui_name = ritnmods.gedit.defines.gui.editor_main.frame.name
    if LuaGui.name ~= LuaGui_name then return end
    if element == nil then return end
    if element.valid == false then return end
    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(element.name, pattern)
    click.action = click.element .. "-" .. click.name
    local type = "frame"                                      ---- A SUPPR

    -- Actions
    if click.ui == "lobby" then
        if click.element ~= "button" then return end
        if not ritnGui.main.action[element.name] then return end
        ritnGui.main.action[element.name](LuaPlayer, type)
        return
    end


end





-- Creation du module
local module = {}
module.events = {}

-- Chargement des modules
module.events[defines.events.on_gui_click] = on_gui_click

return module