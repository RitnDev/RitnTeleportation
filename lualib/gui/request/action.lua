-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =         require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.request =        require(ritnmods.teleport.defines.gui.request.GuiElements)
---------------------------------------------------------------------------------------------
local modGui = require("mod-gui")

local action = {
    [ritnmods.teleport.defines.name.gui.menu.button_valid] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_cancel] = {},
}











-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.menu.button_valid] = button_valid
action[ritnmods.teleport.defines.name.gui.menu.button_cancel] = button_cancel

return action