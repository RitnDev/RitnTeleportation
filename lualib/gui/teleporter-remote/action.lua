-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =      require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.remote =      require(ritnmods.teleport.defines.gui.remote.GuiElements)
---------------------------------------------------------------------------------------------
local action = {
    [ritnmods.teleport.defines.name.gui.button_teleport] = {},
    --[ritnmods.teleport.defines.name.gui.button_valid] = {},
}
---------------------------------------------------------------------------------------------
-- Chargement des elements à créer
local modGui = require("mod-gui")
local prefix = ritnmods.teleport.defines.name.gui.prefix.remote





local function elementlist(LuaGui)
    return LuaGui[prefix .. ritnmods.teleport.defines.name.gui.panel_main][prefix .. ritnmods.teleport.defines.name.gui.SurfacesFlow][prefix .. ritnmods.teleport.defines.name.gui.Pane][prefix .. ritnmods.teleport.defines.name.gui.NameList]
end




local function button_teleport(LuaPlayer)
    
    local LuaSurface = LuaPlayer.surface
    local left = modGui.get_frame_flow(LuaPlayer)
    local LuaGui = left[ritnmods.teleport.defines.name.gui.main_remote]
    local elementList = elementlist(LuaGui)

    if elementList ~= nil then
        local index = elementList.selected_index
        if index ~= nil and index ~= 0 then
            local name = elementList.get_item(index)
            ritnlib.teleporter.teleport(LuaPlayer, LuaSurface, name)

            local LuaItemStack = LuaPlayer.cursor_stack
            if LuaItemStack == nil then LuaPlayer.clear_cursor() return end
            if LuaItemStack.valid == false then LuaPlayer.clear_cursor() return end
            
            if LuaItemStack.name == ritnmods.teleport.defines.name.item.remote then 
                LuaPlayer.cursor_stack.drain_durability(1.0)
                LuaPlayer.clear_cursor()
            end

            local details = {
                lib = "gui",
                gui = "teleporter-remote",
                category = "action",
                func = "button_teleport"
            }
            ritnlib.utils.pcallLog(details)      
        end
    end

end






---------------------------------------------------------------------------------------------
action[ritnmods.teleport.defines.name.gui.button_teleport] = button_teleport
---------------------------------------------------------------------------------------------
return action