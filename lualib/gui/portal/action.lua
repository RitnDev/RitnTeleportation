-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.portal =        require(ritnmods.teleport.defines.functions.portal)
ritnlib.inventory =     require(ritnmods.teleport.defines.functions.inventory)
ritnlib.utils =         require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.portal = require(ritnmods.teleport.defines.gui.portal.GuiElements)
---------------------------------------------------------------------------------------------
local prefix = ritnmods.teleport.defines.name.gui.prefix.portal
local action = {
    [ritnmods.teleport.defines.name.gui.button_close] = {},
    [ritnmods.teleport.defines.name.gui.button_unlink] = {},
    [ritnmods.teleport.defines.name.gui.button_link] = {},
    [ritnmods.teleport.defines.name.gui.button_back] = {},
    [ritnmods.teleport.defines.name.gui.button_valid] = {},
}
---------------------------------------------------------------------------------------------

local function addPrefix(name)
    return prefix .. name
end

local function returnElement(LuaGui, element_name)
    if element_name == "button_unlink" then 
        return LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.MainFlow)][addPrefix(ritnmods.teleport.defines.name.gui.panel_dialog)][addPrefix(ritnmods.teleport.defines.name.gui.button_unlink)]
    elseif element_name == "button_link" then 
        return LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.MainFlow)][addPrefix(ritnmods.teleport.defines.name.gui.panel_dialog)][addPrefix(ritnmods.teleport.defines.name.gui.button_link)]
    elseif element_name == "list" then
        return LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.ListFlow)][addPrefix(ritnmods.teleport.defines.name.gui.SurfacesFlow)][addPrefix(ritnmods.teleport.defines.name.gui.Pane)][addPrefix(ritnmods.teleport.defines.name.gui.list)]
    elseif element_name == "MainFlow" then
        return LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.MainFlow)]
    elseif element_name == "ListFlow" then
        return LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.ListFlow)]
    elseif element_name == "LabelLink" then
        return LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.MainFlow)][addPrefix(ritnmods.teleport.defines.name.gui.LabelLink)]
    end
end



-- GUI click button CLOSE
local function close(LuaPlayer, LuaSurface)
    ritnGui.portal.close(LuaSurface, LuaPlayer)
    ritnlib.utils.pcallLog("lib.gui.portal.action.close(" .. LuaPlayer.name .. ", " ..  LuaSurface.name .. ")")
end

-- GUI click button UNLINK
local function unlink(LuaPlayer, LuaSurface, id, position)
    local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
    local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.portal, position)    
    if LuaEntity.last_user.name == LuaSurface.name then     
        returnElement(LuaGui, "button_unlink").enabled = false
        returnElement(LuaGui, "button_link").enabled = true
        local surface_dest = game.surfaces[ritnlib.portal.getDestinationId(LuaSurface, id)]
        local player_origine, player_dest
        player_origine = LuaPlayer
        for i, player in pairs(game.players) do
            if player.name == surface_dest.name then
                player_dest = player
            end
        end
        -- On téléporte le joueur venant de la destination s'il n'est pas chez lui
        if player_dest.surface.name == LuaSurface.name then
            local position_dest = ritnlib.portal.getPositionDestination(surface_dest, LuaSurface)
            ritnlib.inventory.save(player_dest, global.teleport.surfaces[LuaSurface.name].inventories[player_dest.name])
            if position_dest ~= nil then    
                player_dest.teleport(position_dest, player_dest.name)
            else
                player_dest.teleport({0,0}, player_dest.name)
            end
            ritnlib.inventory.get(player_dest, global.teleport.surfaces[surface_dest.name].inventories[player_dest.name])
            player_dest.force = player_dest.name

        end 
        -- Add v1.2.5
        local renderId = ritnlib.portal.getRenderId(LuaSurface, position)
        if renderId ~= -1 then 
            local status, retval = pcall(function() 
                rendering.set_text(renderId, ritnmods.teleport.defines.value.portal_not_link) -- Change text
            end)
            if status then 
            else
                ritnlib.utils.pcallLog("[RITNTP] lib.gui.portal.action.unlink.rendering.set_text -> Error : " .. retval, nil, true) 
            end
        end
        --

        -- Add 1.5.1
        local LuaPlayerDest = game.players[surface_dest.name]
        if LuaPlayerDest.valid then 
            LuaPlayerDest.print({"msg.unlink", LuaPlayer.name}, {r = 0.217, g = 0.715, b = 0.874, a = 1})
        end

        ritnlib.portal.setDestinationId(LuaSurface, id, ritnmods.teleport.defines.value.portal_not_link)
        close(LuaPlayer, LuaSurface)
    else
        LuaPlayer.print(ritnmods.teleport.defines.name.caption.no_access)
    end
    ritnlib.utils.pcallLog("lib.gui.portal.action.unlink(" .. LuaPlayer.name .. ", " ..  LuaSurface.name .. ", id, position)")
end


-- GUI click button LINK
local function link(LuaPlayer, LuaSurface, id, position) -- id not use but necessary.
    local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
    local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.portal, position)
    if LuaEntity.last_user.name == LuaSurface.name then
        local nb = ritnlib.utils.getn(LuaGui[addPrefix(ritnmods.teleport.defines.name.gui.panel_main)][addPrefix(ritnmods.teleport.defines.name.gui.ListFlow)][addPrefix(ritnmods.teleport.defines.name.gui.SurfacesFlow)][addPrefix(ritnmods.teleport.defines.name.gui.Pane)][addPrefix(ritnmods.teleport.defines.name.gui.list)].items)     
        if nb > 0 then
            returnElement(LuaGui, "MainFlow").visible = false
            returnElement(LuaGui, "ListFlow").visible = true
            LuaGui.auto_center = true
        else
            close(LuaPlayer, LuaSurface)
            LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_surface)
        end
    else
        LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_access)
    end
    ritnlib.utils.pcallLog("lib.gui.portal.action.link(" .. LuaPlayer.name .. ", " ..  LuaSurface.name .. ", position)")
end


-- GUI click button BACK
local function back(LuaPlayer)
    local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
    if LuaGui then
        returnElement(LuaGui, "MainFlow").visible = true
        returnElement(LuaGui, "ListFlow").visible = false
        LuaGui.auto_center = true 
    end
    ritnlib.utils.pcallLog("lib.gui.portal.action.back(" .. LuaPlayer.name .. ")")
end


-- GUI click button VALID
local function valid(LuaPlayer, LuaSurface, id, position)
    local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal] 
    local index = returnElement(LuaGui, "list").selected_index
    local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.portal, position)
    if LuaGui then
        if index ~= nil and index ~= 0 then
            local surface = returnElement(LuaGui, "list").get_item(index)
            if surface ~= nil then
                local dest = game.surfaces[surface].name
                ritnlib.portal.setDestinationId(LuaSurface, id, dest)
                returnElement(LuaGui, "LabelLink").caption = {"frame-portal.link", dest}
                returnElement(LuaGui, "button_link").enabled = false
                returnElement(LuaGui, "button_unlink").enabled = true 
                returnElement(LuaGui, "MainFlow").visible = true
                returnElement(LuaGui, "ListFlow").visible = false   
                LuaGui.auto_center = true
                close(LuaPlayer, LuaSurface)
                -- Add 1.2.5
                local renderId = ritnlib.portal.getRenderId(LuaSurface, position)
                if renderId ~= -1 then 
                    local status, retval = pcall(function() 
                        rendering.set_text(renderId, dest)
                    end)
                    if status then 
                    else
                        ritnlib.utils.pcallLog("[RITNTP] lib.gui.portal.action.valid.rendering.set_text -> Error : " .. retval, nil, true) 
                    end
                end
                --
                LuaPlayer.print({"msg.select", dest})
                -- Add 1.5.1
                local LuaPlayerDest = game.players[dest]
                if LuaPlayerDest.valid then 
                    LuaPlayerDest.print({"msg.link", LuaPlayer.name}, {r = 0.217, g = 0.715, b = 0.874, a = 1})
                end
            else
                LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_select)
            end
        else
            LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_select)
        end
    else
        LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_select)   
    end
    ritnlib.utils.pcallLog("lib.gui.portal.action.valid(" .. LuaPlayer.name .. ", " ..  LuaSurface.name .. ", id, position)")
end


-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.button_close] = close
action[ritnmods.teleport.defines.name.gui.button_unlink] = unlink
action[ritnmods.teleport.defines.name.gui.button_link] = link
action[ritnmods.teleport.defines.name.gui.button_back] = back
action[ritnmods.teleport.defines.name.gui.button_valid] = valid

return action

