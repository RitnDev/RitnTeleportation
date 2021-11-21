-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.inventory =     require(ritnmods.teleport.defines.functions.inventory)
ritnlib.utils =         require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
---------------------------------------------------------------------------------------------
local modGui = require("mod-gui")
local prefix_gui = ritnmods.teleport.defines.prefix.gui
local prefix_menu = ritnmods.teleport.defines.name.gui.prefix.menu
local prefix_main_menu = ritnmods.teleport.defines.name.gui.prefix.main_menu
local prefix_surfaces_menu = ritnmods.teleport.defines.name.gui.prefix.surfaces_menu
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart

local GuiElement = {
    flow_common = prefix_gui .. ritnmods.teleport.defines.name.gui.flow_common,
    flow_menu = prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_menu,
    flow_menu_frame = prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_menu_frame,
}

-- ACTIONS -- 
local action = {
    [ritnmods.teleport.defines.name.gui.menu.button_main] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_restart] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_exclusion] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_tp] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_clean] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_close] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_valid] = {},
    [ritnmods.teleport.defines.name.gui.menu.button_cancel] = {},
}


-- renvoie l'element souhaitez selon son nom
local function returnElement(LuaPlayer, element_name)
    local left = modGui.get_frame_flow(LuaPlayer)
    local center = LuaPlayer.gui.center
    local menu = left[GuiElement.flow_common][GuiElement.flow_menu][GuiElement.flow_menu_frame]

    if element_name == "menu" then 
        return menu
    elseif element_name == "frame_surfaces" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces]
    elseif element_name == "frame_restart" then 
        return center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
    elseif element_name == "panel_tp" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_tp]
    elseif element_name == "panel_clean" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_clean]
    elseif element_name == "panel_exclusion" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_exclusion]
    elseif element_name == "list_tp" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_tp][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.SurfacesFlow][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.Pane][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.list]
    elseif element_name == "list_clean" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_clean][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.SurfacesFlow][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.Pane][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.list]
    elseif element_name == "list_exclusion" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_exclusion][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.SurfacesFlow][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.Pane][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.list]
    elseif element_name == "button_close_tp" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_tp][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_dialog][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.button_close]
    elseif element_name == "button_valid_tp" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_tp][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_dialog][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.button_valid]
    elseif element_name == "button_close_clean" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_clean][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_dialog][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.button_close]
    elseif element_name == "button_valid_clean" then 
        return menu[prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_clean][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_dialog][prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.button_valid]
    end
end



-- Action du bouton principale, ouverture/fermeture du menu :
local function button_main(LuaPlayer)
    local LuaGui = returnElement(LuaPlayer, "menu")
    local frame_restart = returnElement(LuaPlayer, "frame_restart")
    if frame_restart then return end
    if LuaGui then ritnGui.menu.frame_menu_close(LuaPlayer)
    else ritnGui.menu.frame_menu_open(LuaPlayer) end
end

-- Action du bouton Relancer
local function button_restart(LuaPlayer)
    local LuaGui = returnElement(LuaPlayer, "menu")
    local frame_restart = returnElement(LuaPlayer, "frame_restart")
    if frame_restart then return end
    if LuaGui then ritnGui.menu.frame_menu_close(LuaPlayer) end
    ritnGui.menu.frame_restart_show(LuaPlayer)
end



-- Action du bouton /tp
local function button_tp(LuaPlayer)
    local frame_surfaces = returnElement(LuaPlayer, "frame_surfaces")
    local panel_tp = returnElement(LuaPlayer, "panel_tp")
    local panel_clean = returnElement(LuaPlayer, "panel_clean")
    local panel_exclusion = returnElement(LuaPlayer, "panel_exclusion")
    local list = returnElement(LuaPlayer, "list_tp")

    frame_surfaces.caption = {"frame-surfaces.titre", "(tp)"}
    frame_surfaces.visible = true
    panel_tp.visible = true
    panel_clean.visible = false
    panel_exclusion.visible = false
end

-- Action du bouton /clean
local function button_clean(LuaPlayer)
    local frame_surfaces = returnElement(LuaPlayer, "frame_surfaces")
    local panel_tp = returnElement(LuaPlayer, "panel_tp")
    local panel_clean = returnElement(LuaPlayer, "panel_clean")
    local panel_exclusion = returnElement(LuaPlayer, "panel_exclusion")
    local list = returnElement(LuaPlayer, "list_clean")

    frame_surfaces.visible = true
    frame_surfaces.caption = {"frame-surfaces.titre", "(clean)"}
    panel_tp.visible = false
    panel_clean.visible = true
    panel_exclusion.visible = false
end


-- Action du bouton Exclure - add 1.9.0
local function button_exclusion(LuaPlayer)
    local frame_surfaces = returnElement(LuaPlayer, "frame_surfaces")
    local panel_tp = returnElement(LuaPlayer, "panel_tp")
    local panel_clean = returnElement(LuaPlayer, "panel_clean")
    local panel_exclusion = returnElement(LuaPlayer, "panel_exclusion")
    local list = returnElement(LuaPlayer, "list_clean")

    frame_surfaces.visible = true
    frame_surfaces.caption = {"frame-surfaces.titre-exclusion"}
    panel_tp.visible = false
    panel_clean.visible = false
    panel_exclusion.visible = true
end


-- Sous function d'action :
---------------------------


local function button_valid_tp(LuaPlayer)
    local index = returnElement(LuaPlayer, "list_tp").selected_index
    if index == nil or index == 0 then return end
    local surface = returnElement(LuaPlayer, "list_tp").get_item(index)
    if surface == nil then return end 

    if global.teleport.surfaces[surface] then
        if not global.teleport.surfaces[LuaPlayer.surface.name].inventories[LuaPlayer.name] then 
            global.teleport.surfaces[LuaPlayer.surface.name].inventories[LuaPlayer.name] = ritnlib.inventory.init() 
        end
        ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[LuaPlayer.surface.name].inventories[LuaPlayer.name])
        LuaPlayer.print("TP : " .. LuaPlayer.surface.name .. " -> " .. surface)
        print(">> ADMIN TP (" .. LuaPlayer.name .. ") : " .. LuaPlayer.surface.name .. " -> " .. surface)
        LuaPlayer.teleport({0,0}, surface)
        ritnGui.menu.frame_menu_close(LuaPlayer)   
    end
end



local function button_valid_clean(LuaPlayer)
    local index = returnElement(LuaPlayer, "list_clean").selected_index
    if index == nil or index == 0 then return end
    local surface = returnElement(LuaPlayer, "list_clean").get_item(index)
    ritnlib.utils.clean(surface, LuaPlayer)
    ritnGui.menu.frame_menu_close(LuaPlayer)
end


local function button_valid_excude(LuaPlayer)
    local index = returnElement(LuaPlayer, "list_exclusion").selected_index
    if index == nil or index == 0 then return end
    local playerExclure = returnElement(LuaPlayer, "list_exclusion").get_item(index)
    local surface = LuaPlayer.name
    if global.teleport.surfaces[surface] then
        for i,player in pairs(global.teleport.surfaces[surface].origine) do 
            if player == playerExclure then 
                -- suppression du joueur dans origine de la map
                table.remove(global.teleport.surfaces[surface].origine, i)
                global.teleport.players[playerExclure] = nil

                if game.players[playerExclure] 
                and game.players[playerExclure].valid 
                and game.players[playerExclure].connected then   
                    -- retour lobby
                    game.players[playerExclure].teleport({0,0}, "lobby~" .. playerExclure)
                    game.players[playerExclure].clear_items_inside()
                end
            end
        end
    end
    ritnGui.menu.frame_menu_close(LuaPlayer)
end


local function button_valid_restart(LuaPlayer)
    ritnGui.menu.frame_restart_close(LuaPlayer)
    ritnlib.utils.restart(LuaPlayer)
end


-- >>>>> FERMER L'INTERFACE MENU COMPLETE
local function button_close_menu(LuaPlayer)
    local LuaGui = returnElement(LuaPlayer, "menu")
    if LuaGui then ritnGui.menu.frame_menu_close(LuaPlayer) end
end


local function button_cancel(LuaPlayer)
    ritnGui.menu.frame_restart_close(LuaPlayer)
end





-- architecture pour les action dispatcher du bouton close/valid/back
local sub_action = {
    ["surfaces_menu"] = {
        ["panel_tp"] = {
            ["button-valid"] = button_valid_tp,
            ["button-close"] = button_close_menu,
        },
        ["panel_clean"] = {
            ["button-valid"] = button_valid_clean,
            ["button-close"] = button_close_menu,
        },
        ["panel_exclusion"] = {
            ["button-valid"] = button_valid_excude,
            ["button-close"] = button_close_menu,
        },
    },
    ["restart"] = {
        ["button-valid"] = button_valid_restart,
    },
}

-- Action du bouton valid (frame_surface/frame_restart, panel_tp/panel_clean)
local function button_valid(LuaPlayer, click, parent)
    local frame = click.ui

    if frame == nil then return end 
    if frame == "surfaces_menu" then 
        sub_action[frame][parent][click.action](LuaPlayer)
    else 
        sub_action[frame][click.action](LuaPlayer)
    end
end

-- Action du bouton close (frame_surface, panel_tp/panel_clean)
local function button_close(LuaPlayer, click, parent)
    local frame = click.ui
    
    if frame == nil then return end 
    sub_action[frame][parent][click.action](LuaPlayer)
end


-- Tableau de fonction : permet d'appeler la fonction correspondant au bouton
action[ritnmods.teleport.defines.name.gui.menu.button_main] = button_main
action[ritnmods.teleport.defines.name.gui.menu.button_restart] = button_restart
action[ritnmods.teleport.defines.name.gui.menu.button_exclusion] = button_exclusion
action[ritnmods.teleport.defines.name.gui.menu.button_tp] = button_tp
action[ritnmods.teleport.defines.name.gui.menu.button_clean] = button_clean
action[ritnmods.teleport.defines.name.gui.menu.button_close] = button_close
action[ritnmods.teleport.defines.name.gui.menu.button_valid] = button_valid
action[ritnmods.teleport.defines.name.gui.menu.button_cancel] = button_cancel

return action