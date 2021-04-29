-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =      require(ritnmods.teleport.defines.functions.teleporter)
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
        rendering.set_text(renderId, name)
    end
    close(LuaSurface, LuaPlayer, LuaEntity)
end


-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.button_close] = close
action[ritnmods.teleport.defines.name.gui.button_valid] = valid

return action