-- Initialisation des variables globals
require ("core.global")

-- Activation de l'event-listener
local event_listener = require(ritnmods.teleport.defines.event_listener)
-- Activation de gvv s'il est présent
if script.active_mods["gvv"] then require(ritnmods.teleport.defines.lib.gvv)() end
-- envoie des modules à l'event listener :
event_listener.add_libraries(require (ritnmods.teleport.defines.lib.modules))
