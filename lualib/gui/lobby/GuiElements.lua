---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------

-- Properties
local visible = false
--local prefix_menu = ritnmods.teleport.defines.name.gui.prefix.menu
--local prefix_main_menu = ritnmods.teleport.defines.name.gui.prefix.main_menu
--local prefix_surfaces_menu = ritnmods.teleport.defines.name.gui.prefix.surfaces_menu
--local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart
local luaGui = {}



---
-- Creation de la fenetre principale
---
local function create_gui_lobby(LuaPlayer)
  local center = LuaPlayer.gui.center
  local content = {}
  local LuaSurface = LuaPlayer.surface
  
  -- flow commun (Menu/Surfaces)
  content.main = ritnlib.gui.createFlowH(
    center,
    GuiElement.flow_common
  )
  
  -- frame Menu
  content.frame_menu = ritnlib.gui.createFrame(
    content.main,
    GuiElement.frame_menu.name,
    GuiElement.frame_menu.caption
  )
  ritnlib.styles.ritn_frame_style(content.frame_menu.style)

  -- flow_restart
  content.flow_restart = ritnlib.gui.createFlowV(
    content.frame_menu,
    GuiElement.flow_restart,
    finish
  )
  
  -- button restart
  content.button_restart = ritnlib.gui.createButton(
    content.flow_restart,
    GuiElement.button_restart.name,
    GuiElement.button_restart.caption
  )

  -- flow_admin
  content.flow_admin = ritnlib.gui.createFlowV(
    content.frame_menu,
    GuiElement.flow_admin
  )
  ritnlib.styles.ritn_flow_surfaces(content.flow_admin.style)
  content.flow_admin.visible = admin


    -- label_admin
    content.label_admin = ritnlib.gui.createLabel(
      content.flow_admin,
      GuiElement.label_admin.name,
      GuiElement.label_admin.caption
    )
    ritnlib.styles.ritn_label(content.label_admin.style)

    -- button_tp
    content.button_tp = ritnlib.gui.createButton(
      content.flow_admin,
      GuiElement.button_tp.name,
      GuiElement.button_tp.caption
    )
    
    -- button_clean
    content.button_admin = ritnlib.gui.createButton(
      content.flow_admin,
      GuiElement.button_clean.name,
      GuiElement.button_clean.caption
    )


  -- frame surfaces
  content.frame_surfaces = ritnlib.gui.createFrame(
    content.main,
    GuiElement.frame_surfaces,
    ""
  )
  content.frame_surfaces.visible = visible
  ritnlib.styles.ritn_frame_style(content.frame_surfaces.style)

  -- panel main
  content.panel_main = ritnlib.gui.createFlowV(
    content.frame_surfaces,
    GuiElement.panel_main
  )
  ritnlib.styles.ritn_flow_panel_main(content.panel_main.style)

  content.panel_tp = ritnlib.gui.createFlowV(
    content.panel_main,
    GuiElement.panel_tp,
    visible
  )
  content.panel_clean = ritnlib.gui.createFlowV(
    content.panel_main,
    GuiElement.panel_clean,
    visible
  )

  -- PANEL TP :

  -- SurfacesFlow
  content.SurfacesFlow_tp = ritnlib.gui.createFlowV(
    content.panel_tp,
    GuiElement.SurfacesFlow
  )
  ritnlib.styles.ritn_flow_surfaces(content.SurfacesFlow_tp.style)
    -- Pane
    content.Pane = ritnlib.gui.createScrollPane(
      content.SurfacesFlow_tp,
      GuiElement.Pane
    )
    ritnlib.styles.ritn_scroll_pane(content.Pane.style)
    -- list_tp
    content.list = ritnlib.gui.createList(
      content.Pane,
      GuiElement.list
    )
    
    local MySurface = LuaPlayer.surface.name

    for _,surface in pairs(global.teleport.surfaces) do 
      if surface.name ~= nil then
        if MySurface ~= surface.name then
          content.list.add_item(surface.name)
        end
      end
    end


  -- panel_dialog
  content.panel_dialog = ritnlib.gui.createFlowH(
    content.panel_tp,
    GuiElement.panel_dialog
  )
  ritnlib.styles.ritn_flow_dialog(content.panel_dialog.style)

    -- button_close
    content.button_close = ritnlib.gui.createButton(
      content.panel_dialog,
      GuiElement.button_close_surfaces.name,
      GuiElement.button_close_surfaces.caption,
      "red_back_button"
    )
    ritnlib.styles.ritn_small_button(content.button_close.style)

    -- button_valid
    content.button_valid = ritnlib.gui.createButton(
      content.panel_dialog,
      GuiElement.button_valid_surfaces.name,
      GuiElement.button_valid_surfaces.caption,
      "confirm_button"
    )
    ritnlib.styles.ritn_small_button(content.button_valid.style)


    -- PANEL CLEAN :

  -- SurfacesFlow
  content.SurfacesFlow_clean = ritnlib.gui.createFlowV(
    content.panel_clean,
    GuiElement.SurfacesFlow
  )
  ritnlib.styles.ritn_flow_surfaces(content.SurfacesFlow_clean.style)
    -- Pane
    content.Pane = ritnlib.gui.createScrollPane(
      content.SurfacesFlow_clean,
      GuiElement.Pane
    )
    ritnlib.styles.ritn_scroll_pane(content.Pane.style)
    -- list_clean
    content.list = ritnlib.gui.createList(
      content.Pane,
      GuiElement.list
    )
 
    for _,surface in pairs(global.teleport.surfaces) do 
      if surface.name ~= nil then
        if game.players[surface.name] ~= nil then
          if game.players[surface.name].connected == false then
            content.list.add_item(surface.name)
          end
        end
      end
    end

  -- panel_dialog
  content.panel_dialog = ritnlib.gui.createFlowH(
    content.panel_clean,
    GuiElement.panel_dialog
  )
  ritnlib.styles.ritn_flow_dialog(content.panel_dialog.style)

    -- button_close
    content.button_close = ritnlib.gui.createButton(
      content.panel_dialog,
      GuiElement.button_close_surfaces.name,
      GuiElement.button_close_surfaces.caption,
      "red_back_button"
    )
    ritnlib.styles.ritn_small_button(content.button_close.style)

    -- button_valid
    content.button_valid = ritnlib.gui.createButton(
      content.panel_dialog,
      GuiElement.button_valid_surfaces.name,
      GuiElement.button_valid_surfaces.caption,
      "confirm_button"
    )
    ritnlib.styles.ritn_small_button(content.button_valid.style)

end



---
-- Fonction "GUI"
---


-- close gui
local function frame_lobby_close(LuaPlayer)
  local center = LuaPlayer.gui.center
  --local frame_lobby = center[prefix_lobby .. ritnmods.teleport.defines.name.gui.lobby.flow_common]

  if frame_lobby then 
    frame_lobby.destroy()
  end
end


-- open gui
local function frame_lobby_open(LuaPlayer)
  frame_lobby_close(LuaPlayer)
  create_gui_lobby(LuaPlayer)
end


------------------------------
luaGui.open = frame_menu_open
luaGui.close = frame_menu_close

return luaGui
