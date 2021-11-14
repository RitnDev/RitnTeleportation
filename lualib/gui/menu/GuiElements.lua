---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------

-- Properties
local visible = false
local modGui = require("mod-gui")
local prefix_menu = ritnmods.teleport.defines.name.gui.prefix.menu
local prefix_main_menu = ritnmods.teleport.defines.name.gui.prefix.main_menu
local prefix_surfaces_menu = ritnmods.teleport.defines.name.gui.prefix.surfaces_menu
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart
local luaGui = {}

-- CREATION DU GUI
local GuiElement = {

  -- Bouton principale
  button_main = {
    name = ritnmods.teleport.defines.name.gui.menu.button_main,
    sprite = ritnmods.teleport.defines.name.sprite.portal,
    style = ritnmods.teleport.defines.name.gui.styles.button_main,
  },

  -- commons frame (Menu/Surfaces)
  flow_common = prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_common,
  
  -- Frame Menu
  frame_menu = {
    name = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.frame_menu,
    caption = ritnmods.teleport.defines.name.caption.frame_menu.titre
  },

  flow_restart = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.flow_restart,
  flow_admin = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.flow_admin,
  
  button_restart = {
    name = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.button_restart,
    caption = ritnmods.teleport.defines.name.caption.frame_menu.button_restart,
  },

  label_admin = {
    name = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.label_admin,
    caption = ritnmods.teleport.defines.name.caption.frame_menu.label_admin, 
  },

  button_tp = {
    name = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.button_tp,
    caption = ritnmods.teleport.defines.name.caption.frame_menu.button_tp,
  },

  button_clean = {
    name = prefix_main_menu .. ritnmods.teleport.defines.name.gui.menu.button_clean,
    caption = ritnmods.teleport.defines.name.caption.frame_menu.button_clean,
  },

  -- Frame Surfaces
  frame_surfaces = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.frame_surfaces,
  panel_main = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_main,
  panel_tp = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_tp,
  panel_clean = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.menu.panel_clean,
  SurfacesFlow = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.SurfacesFlow,
  Pane = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.Pane,
  list = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.list,
  panel_dialog = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.panel_dialog,
  
  button_close_surfaces = {
    name = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.button_close,
    caption = ritnmods.teleport.defines.name.caption.frame_portal.button_close,
  },

  button_valid_surfaces = {
    name = prefix_surfaces_menu .. ritnmods.teleport.defines.name.gui.button_valid,
    caption = ritnmods.teleport.defines.name.caption.frame_portal.button_valid,
  },

  -- Frame Restart
  frame_restart = {
    name = prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart,
    caption = ritnmods.teleport.defines.name.caption.frame_restart.titre
  },

  flow_label = prefix_restart .. ritnmods.teleport.defines.name.gui.menu.flow_label,

  label_warning1 = {
    name = prefix_restart .. ritnmods.teleport.defines.name.gui.menu.label_warning1,
    caption = ritnmods.teleport.defines.name.caption.frame_restart.label_warning1, 
  },

  label_warning2 = {
    name = prefix_restart .. ritnmods.teleport.defines.name.gui.menu.label_warning2,
    caption = ritnmods.teleport.defines.name.caption.frame_restart.label_warning2, 
  },

  flow_dialog = prefix_restart .. ritnmods.teleport.defines.name.gui.panel_dialog,

  button_close_restart = {
    name = prefix_restart .. ritnmods.teleport.defines.name.gui.menu.button_cancel,
    caption = ritnmods.teleport.defines.name.caption.frame_portal.button_back,
  },

  button_valid_restart = {
    name = prefix_restart .. ritnmods.teleport.defines.name.gui.button_valid,
    caption = ritnmods.teleport.defines.name.caption.frame_portal.button_valid,
  },

}


---
-- Creation du bouton principale
---
local function create_button_main(LuaPlayer)
  local top = modGui.get_button_flow(LuaPlayer)
  local setting_value = settings.get_player_settings(LuaPlayer)[ritnmods.teleport.defines.name.settings.enable_main_button].value
  if setting_value then
    local main_button = ritnlib.gui.createSpriteButton(
      top, 
      GuiElement.button_main.name, 
      GuiElement.button_main.sprite, 
      ritnmods.teleport.defines.name.gui.styles.ritn_main_sprite_button
    )
  end

end



---
-- Creation de la fenetre principale
---
local function create_gui_menu(LuaPlayer)
  local left = modGui.get_frame_flow(LuaPlayer)
  local content = {}
  local LuaSurface = LuaPlayer.surface
  if global.teleport.surfaces[LuaSurface.name] == nil then return end -- correctif 1.8.1
  if global.teleport.surfaces[LuaSurface.name].name == nil then return end
  local finish = global.teleport.surfaces[LuaSurface.name].finish
  local admin = LuaPlayer.admin

  -- Seul le joueur de la surface à le bouton de disponible
  if LuaPlayer.name ~= LuaSurface.name then 
    finish = false
    -- S'il n'est pas admin pas de bouton menu
    if not admin then return end
  end
  
  -- flow commun (Menu/Surfaces)
  content.main = ritnlib.gui.createFlowH(
    left,
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
-- Creation de la fenetre restart
---
local function create_gui_restart(LuaPlayer)
  local center = LuaPlayer.gui.center
  local content = {}
  
  content.main = ritnlib.gui.createFrame(
    center,
    GuiElement.frame_restart.name,
    GuiElement.frame_restart.caption
  )
 
  
  content.flow_label = ritnlib.gui.createFlowV(
    content.main,
    GuiElement.flow_label
  )
  ritnlib.styles.ritn_flow_surfaces(content.flow_label.style)

  content.label_warning1 = ritnlib.gui.createLabel(
    content.flow_label,
    GuiElement.label_warning1.name,
    GuiElement.label_warning1.caption
  )
  content.label_warning2 = ritnlib.gui.createLabel(
    content.flow_label,
    GuiElement.label_warning2.name,
    GuiElement.label_warning2.caption
  )
  
  content.panel_dialog = ritnlib.gui.createFlowH(
    content.flow_label,
    GuiElement.flow_dialog
  )
  ritnlib.styles.ritn_flow_dialog(content.panel_dialog.style)

  -- button_close
  content.button_close = ritnlib.gui.createButton(
    content.panel_dialog,
    GuiElement.button_close_restart.name,
    GuiElement.button_close_restart.caption,
    "red_back_button"
  )
  ritnlib.styles.ritn_small_button(content.button_close.style)

  content.empty = ritnlib.gui.createEmptyWidget(content.panel_dialog)
  content.empty.style.width = 110

  -- button_valid
  content.button_valid = ritnlib.gui.createButton(
    content.panel_dialog,
    GuiElement.button_valid_restart.name,
    GuiElement.button_valid_restart.caption,
    "confirm_button"
  )
  ritnlib.styles.ritn_small_button(content.button_valid.style)
  
end


---
-- Fonction "GUI"
---


-- Verification si d'autre GUI sont pas déjà ouverte :
local function verifGUIopen(LuaPlayer)
  -- N'ouvre pas la fenetre si on a la telecomande en main
  if LuaPlayer.cursor_stack 
  and LuaPlayer.cursor_stack.valid 
  and LuaPlayer.cursor_stack.valid_for_read 
  and LuaPlayer.cursor_stack.name == ritnmods.teleport.defines.name.item.remote then
    return true
  end

  if LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain] ~= nil then return true end
  if LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal] ~= nil then return true end

  return false
end



-- close gui
local function button_main_close(LuaPlayer)
  local top = modGui.get_button_flow(LuaPlayer)
  local button_main = top[ritnmods.teleport.defines.name.gui.menu.button_main]

  if button_main then 
    button_main.destroy()
  end
end

local function frame_menu_close(LuaPlayer)
  local left = modGui.get_frame_flow(LuaPlayer)
  local frame_menu = left[prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_common]

  if frame_menu then 
    frame_menu.destroy()
  end
end

local function frame_restart_close(LuaPlayer)
  local center = LuaPlayer.gui.center
  local frame_restart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
   
  if frame_restart then 
    frame_restart.destroy()
  end
end


-- open gui
local function button_main_open(LuaPlayer)
  button_main_close(LuaPlayer)
  create_button_main(LuaPlayer)
end

local function frame_menu_open(LuaPlayer)
  if verifGUIopen(LuaPlayer) then return end

  frame_menu_close(LuaPlayer)
  create_gui_menu(LuaPlayer)
end

local function frame_restart_open(LuaPlayer)
  if verifGUIopen(LuaPlayer) then return end

  frame_restart_close(LuaPlayer)
  create_gui_restart(LuaPlayer)
end




------------------------------

luaGui.button_main_show = create_button_main
luaGui.button_main_open = button_main_open
luaGui.button_main_close = button_main_close

luaGui.frame_menu_show = create_gui_menu
luaGui.frame_menu_open = frame_menu_open
luaGui.frame_menu_close = frame_menu_close

luaGui.frame_restart_show = create_gui_restart
luaGui.frame_restart_open = frame_restart_open
luaGui.frame_restart_close = frame_restart_close


return luaGui
