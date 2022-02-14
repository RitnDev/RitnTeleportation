--INITIALIZE
if not ritnmods then ritnmods = {} end 
if not ritnmods.teleport then ritnmods.teleport = {
    -- definitions des constantes
      defines = require("defines"),
} end 


local setting_value = settings.startup[ritnmods.teleport.defines.name.settings.teleporter_enable].value
test = false
--test = true

-- require
require ("prototypes.custom-inputs")
require ("prototypes.category")
require ("prototypes.items")
require ("prototypes.technology")
require (ritnmods.teleport.defines.gui.styles)


if setting_value then
    local tech = data.raw.technology[ritnmods.teleport.defines.name.technology.teleport]
    tech.hidden = false
    tech.enabled = true
end

-- Si test = true :
require ("lualib.test")