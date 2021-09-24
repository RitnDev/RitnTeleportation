local modules = {}
------------------------------------------------------------------------------

-- Inclus les events onInit et onLoad + les ajouts de commandes
modules.migrations  =           require(ritnmods.teleport.defines.lib.migrations)
modules.events =                require(ritnmods.teleport.defines.lib.events)

-- Inclus la compatibilité avec les mods
modules.spaceblock =            require(ritnmods.teleport.defines.mods.spaceblock)

-- Inclus les interactions avec les Portails et téléporteurs
modules.portal =                require(ritnmods.teleport.defines.lib.portal)                     
modules.teleporter =            require(ritnmods.teleport.defines.lib.teleporter) 

-- Inclus les interactions avec les joueurs
modules.player =                require(ritnmods.teleport.defines.lib.player) 

-- Inclus les interactions avec les enemies
modules.enemy =                 require(ritnmods.teleport.defines.lib.enemy)

-- Partie permettant la création des GUI et ses interactions
modules.gui_portal =            require(ritnmods.teleport.defines.lib.gui_portal)                 
modules.gui_teleporter =        require(ritnmods.teleport.defines.lib.gui_teleporter)             
modules.gui_teleporter_remote = require(ritnmods.teleport.defines.lib.gui_teleporter_remote)
modules.gui_menu =              require(ritnmods.teleport.defines.lib.gui_menu)

------------------------------------------------------------------------------
return modules