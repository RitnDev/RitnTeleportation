---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.portal =      require(ritnmods.teleport.defines.functions.portal)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------

-- Properties
local visible = false
local prefix = ritnmods.teleport.defines.name.gui.prefix.portal
local luaGui = {}

-- CREATION DU GUI
local GuiElement = {

  panel_main = prefix .. ritnmods.teleport.defines.name.gui.panel_main,
  MainFlow = prefix .. ritnmods.teleport.defines.name.gui.MainFlow,
  ListFlow = prefix .. ritnmods.teleport.defines.name.gui.ListFlow,
  Infos = prefix .. ritnmods.teleport.defines.name.gui.Infos,
  ButtonFlow = prefix .. ritnmods.teleport.defines.name.gui.ButtonFlow,
  panel_dialog = prefix .. ritnmods.teleport.defines.name.gui.panel_dialog,
  LabelLink = prefix .. ritnmods.teleport.defines.name.gui.LabelLink,
  SurfacesFlow = prefix .. ritnmods.teleport.defines.name.gui.SurfacesFlow,
  list = prefix .. ritnmods.teleport.defines.name.gui.list,
  Pane = prefix .. ritnmods.teleport.defines.name.gui.Pane,

  button_link = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_link,
    sprite = ritnmods.teleport.defines.name.sprite.link,
    tooltip = ritnmods.teleport.defines.name.caption.frame_portal.button_link,
  },

  button_unlink = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_unlink,
    sprite = ritnmods.teleport.defines.name.sprite.unlink,
    tooltip = ritnmods.teleport.defines.name.caption.frame_portal.button_unlink,
  },

  button_close = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_close,
    sprite = ritnmods.teleport.defines.name.sprite.close,
  },

  button_back = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_back,
    caption = ritnmods.teleport.defines.name.caption.frame_portal.button_back,
  },

  button_valid = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_valid,
    caption = ritnmods.teleport.defines.name.caption.frame_portal.button_valid,
  },

}



---
-- Creation de la fenetre
---
local function create_gui(LuaSurface, LuaPlayer, LuaEntity)
  
  local visible = false
  local screen = LuaPlayer.gui.screen
  local content = {}

    -- Creation de la fenêtre du portail
    content.main = ritnlib.gui.createFrame(
        screen, 
        ritnmods.teleport.defines.name.gui.main_portal,
        {"frame-portal.portal-gui-name"}
      )
    ritnlib.gui.frameAutoCenter(content.main)
    ritnlib.styles.ritn_frame_style(content.main.style)

    -- Panel Principale
    content.panel_main = ritnlib.gui.createFlowV(
        content.main, 
        GuiElement.panel_main
      )
    ritnlib.styles.ritn_flow_panel_main(content.panel_main.style)

    -- Flow principale
    content.MainFlow = ritnlib.gui.createFlowV(
        content.panel_main, 
        GuiElement.MainFlow
      )
    ritnlib.styles.ritn_flow_no_padding(content.MainFlow.style)
    ritnlib.styles.ritn_flow_surfaces(content.MainFlow.style)

    -- ListFlow - Fenetre du listing
    content.ListFlow = ritnlib.gui.createFlowV(
        content.panel_main,
        GuiElement.ListFlow,
        visible
      )

    -- Infos
    content.infos = ritnlib.gui.createLabel(
        content.main, 
        GuiElement.Infos, 
        LuaEntity.position.x .. " " .. LuaEntity.position.y, 
        visible
      )
      
    -- LabelLink - Texte de la liaison actuelle
    content.LabelLink = ritnlib.gui.createLabel(
        content.MainFlow, 
        GuiElement.LabelLink, 
        {"frame-portal.link", ritnlib.portal.getDestination(LuaPlayer.surface, LuaEntity.position)}
      )
    ritnlib.styles.ritn_label(content.LabelLink.style)

    -- Panel Dialog
    content.MainDialogFlow = ritnlib.gui.createFlowH(
        content.MainFlow, 
        GuiElement.panel_dialog
      )
    ritnlib.styles.ritn_flow_dialog(content.MainDialogFlow.style)

    -- Buttons
    content.button_link = ritnlib.gui.createSpriteButton(
        content.MainDialogFlow, 
        GuiElement.button_link.name, 
        GuiElement.button_link.sprite, 
        ritnmods.teleport.defines.name.gui.styles.ritn_normal_sprite_button, 
        GuiElement.button_link.tooltip
      )

  
    content.button_unlink = ritnlib.gui.createSpriteButton(
        content.MainDialogFlow, 
        GuiElement.button_unlink.name, 
        GuiElement.button_unlink.sprite, 
        ritnmods.teleport.defines.name.gui.styles.ritn_normal_sprite_button, 
        GuiElement.button_unlink.tooltip
      )

      
    content.empty = ritnlib.gui.createEmptyWidget(content.MainDialogFlow)
    content.empty.style.width = 10

    
    content.button_close = ritnlib.gui.createSpriteButton(
        content.MainDialogFlow, 
        GuiElement.button_close.name, 
        GuiElement.button_close.sprite, 
        ritnmods.teleport.defines.name.gui.styles.ritn_red_sprite_button
      )

    if game.surfaces[ritnlib.portal.getDestination(LuaPlayer.surface, LuaEntity.position)] ~= nil 
    or game.surfaces[ritnlib.portal.getDestination(LuaPlayer.surface, LuaEntity.position)] == ritnmods.teleport.defines.value.portal_not_link then
      content.button_link.enabled = false
      content.button_unlink.enabled = true
    else
      content.button_link.enabled = true
      content.button_unlink.enabled = false

      -- Actualisation du rendering si necessaire :
      local renderId = ritnlib.portal.getRenderId(LuaPlayer.surface, LuaEntity.position)
      if not game.surfaces[ritnlib.portal.getDestination(LuaPlayer.surface, LuaEntity.position)] then
        if renderId ~= -1 then 
          local result = pcall(function()
            rendering.set_text(renderId, ritnmods.teleport.defines.value.portal_not_link) -- Change text
          end)
          if result == false then print(">> (debug) guiElement - portal : create_gui : rendering.set_text non executé !") end
          ritnlib.portal.setDestination(LuaPlayer.surface, LuaEntity.position, ritnmods.teleport.defines.value.portal_not_link)
          content.LabelLink.caption = {"frame-portal.link", ritnlib.portal.getDestination(LuaPlayer.surface, LuaEntity.position)}
        end
      end

    end

  -- ListFlow
    -- SurfacesFlow
    content.SurfacesFlow = ritnlib.gui.createFlowV(
        content.ListFlow, 
        GuiElement.SurfacesFlow
      )
    ritnlib.styles.ritn_flow_surfaces(content.SurfacesFlow.style)
    -- ListDialogFlow
    content.ListDialogFlow = ritnlib.gui.createFlowH(
        content.ListFlow, 
        GuiElement.panel_dialog
      )
    ritnlib.styles.ritn_flow_dialog(content.ListDialogFlow.style)

    -- Pane
    content.Pane = ritnlib.gui.createScrollPane(
        content.SurfacesFlow, 
        GuiElement.Pane
      )
    ritnlib.styles.ritn_scroll_pane(content.Pane.style)

    -- list
    content.list = ritnlib.gui.createList(
        content.Pane, 
        GuiElement.list
      )


    for k,surface in pairs(game.surfaces) do
      if surface.name ~= "nauvis" 
        and surface ~= LuaSurface.name 
        and surface.name ~= LuaEntity.surface.name 
        and ritnlib.portal.getValue(surface) >= 1 then
          
        local exist = false
        for x,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
            if surface.name == portal.dest then
              exist = true
            end
        end
        if not exist then
          content.list.add_item(surface.name)
        end
      end
    end

    -- back_button
    content.button_back = ritnlib.gui.createButton(
        content.ListDialogFlow, 
        GuiElement.button_back.name, 
        GuiElement.button_back.caption, 
        "red_back_button"
      )
    ritnlib.styles.ritn_small_button(content.button_back.style)

    -- valid_button
    content.button_valid = ritnlib.gui.createButton(
        content.ListDialogFlow, 
        GuiElement.button_valid.name, 
        GuiElement.button_valid.caption, 
        "confirm_button"
      )
    ritnlib.styles.ritn_small_button(content.button_valid.style)

end

---
-- Fonction "GUI"
---

-- close gui
local function close(LuaSurface, LuaPlayer)
  local guiPortal = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
  if guiPortal then 
    if LuaSurface then
      local info = guiPortal[prefix .. ritnmods.teleport.defines.name.gui.Infos].caption
      local position = ritnlib.utils.split(info, " ")
      local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.portal, position)
      LuaEntity.operable = true
      LuaEntity.minable = true
    end
    guiPortal.destroy()
  end
end


-- open gui
local function open(LuaPlayer, LuaSurface, LuaEntity)
  close(LuaSurface, LuaPlayer)
  create_gui(LuaSurface, LuaPlayer, LuaEntity)
end



------------------------------
luaGui.show = create_gui
luaGui.open = open
luaGui.close = close

return luaGui