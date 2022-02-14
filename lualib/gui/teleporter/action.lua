-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =      require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.teleporter =        require(ritnmods.teleport.defines.gui.teleporter.GuiElements)
---------------------------------------------------------------------------------------------
local prefix = ritnmods.teleport.defines.name.gui.prefix.teleporter
local action = {
    [ritnmods.teleport.defines.name.gui.button_close] = {},
    [ritnmods.teleport.defines.name.gui.button_valid] = {},
}
---------------------------------------------------------------------------------------------


local function addPrefix(name)
    return prefix .. name
end

-- GUI click button CLOSE
local function close(LuaSurface, LuaPlayer, LuaEntity)
    ritnGui.teleporter.close(LuaSurface, LuaPlayer, LuaEntity)
    ritnlib.utils.pcallLog("lib.gui.teleporter.action.close(" .. LuaPlayer.name .. ", " ..  LuaSurface.name .. ", LuaEntity)")
end

-- GUI click button VALID
local function valid(LuaSurface, LuaPlayer, LuaEntity, position)
    local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain]
    -- MaJ du nom du teleporter
    local name = LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.TextNamer)].text
    local id = ritnlib.teleporter.getId(LuaSurface, position)
    ritnlib.teleporter.setNameId(LuaSurface, id, name) 
    -- MaJ du nom sur le render
    local renderId = ritnlib.teleporter.getRenderId(LuaSurface, position)
    if renderId ~= -1 then 
        local status, retval = pcall(function() 
            rendering.set_text(renderId, name)
        end)
        if status then 
        else
            ritnlib.utils.pcallLog("[RITNTP] lib.gui.teleporter.action.valid.rendering.set_text -> Error : " .. retval, nil, true) 
        end
    end
    close(LuaSurface, LuaPlayer, LuaEntity)
    ritnlib.utils.pcallLog("lib.gui.teleporter.action.valid(" .. LuaPlayer.name .. ", " ..  LuaSurface.name .. ", LuaEntity, position)")
end


-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.button_close] = close
action[ritnmods.teleport.defines.name.gui.button_valid] = valid

return action