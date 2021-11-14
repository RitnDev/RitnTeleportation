-- INITIALISATION VARIABLES GLOBALS

---------------------
-->       _G
---------------------

-- Variable global ritnmods permettant le lien avec d'autres mods Ritnmods
if not ritnmods then ritnmods = {
    teleport = {
    -- definitions des constantes
      defines = require("defines"),
    },
} end 

-- Nom du mod
local mod_name = ritnmods.teleport.defines.mod_directory



---------------------
-->   global (jeu)
---------------------

-- Enregistrement des données permettant la gestion de la téléportation.
if not global.teleport then global.teleport = 
  {
    surfaces = {},
    players = {},
    player_died = {},
    restart_list = {},
    surface_value = 0,
  }
end
if not global.map_gen_settings then global.map_gen_settings = {} end
if not global.enemy then global.enemy = {
  setting = settings.startup[ritnmods.teleport.defines.name.settings.enemy].value,
  value = false
}
end
if not global.settings then global.settings = {} end
if not global.migration then global.migration = false end

global.generate_seed = settings.startup[ritnmods.teleport.defines.name.settings.generate_seed].value