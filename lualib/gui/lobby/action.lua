-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.lobby =        require(ritnmods.teleport.defines.gui.lobby.GuiElements)
---------------------------------------------------------------------------------------------

local action = {
    [ritnmods.teleport.defines.name.gui.menu.button_main] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_restart] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_tp] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_clean] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_close] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_valid] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_cancel] = {},
}









-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.menu.button_main] = button_main
action[ritnmods.teleport.defines.name.gui.menu.button_restart] = button_restart
action[ritnmods.teleport.defines.name.gui.menu.button_tp] = button_tp
action[ritnmods.teleport.defines.name.gui.menu.button_clean] = button_clean
action[ritnmods.teleport.defines.name.gui.menu.button_close] = button_close
action[ritnmods.teleport.defines.name.gui.menu.button_valid] = button_valid
action[ritnmods.teleport.defines.name.gui.menu.button_cancel] = button_cancel

return action