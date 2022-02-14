---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------

-- Properties
local visible = false
local prefix_lobby = ritnmods.teleport.defines.name.gui.prefix.lobby
local definesGuiLobby = ritnmods.teleport.defines.name.gui.lobby




---
-- Creation de la fenetre principale
---
local function create_gui_lobby(LuaPlayer)
  local center = LuaPlayer.gui.center
  local content = {}
  
  -- flow commun (Menu/Surfaces)
  content.main = ritnlib.gui.createFlowH(
    center,
    prefix_lobby .. definesGuiLobby.flow_common
  )
  
  -- frame Menu
  content.frame_lobby = ritnlib.gui.createFrame(
    content.main,
    prefix_lobby .. definesGuiLobby.frame_lobby,
    ritnmods.teleport.defines.name.caption.frame_lobby.titre
  )
  ritnlib.styles.ritn_frame_style(content.frame_lobby.style)
  content.frame_lobby.style.maximal_height = 450
  content.frame_lobby.style.maximal_width = 260

  -- Main Flow : Flow principale de la frame
  content.MainFlow = ritnlib.gui.createFlowV(
    content.frame_lobby,
    prefix_lobby .. definesGuiLobby.MainFlow
  )
  ritnlib.styles.ritn_flow_surfaces(content.MainFlow.style)
  content.MainFlow.style.horizontally_stretchable = true
  content.MainFlow.style.vertically_stretchable = true
 

  -- label welcome
  content.label_welcome = ritnlib.gui.createLabel(
    content.MainFlow,
    prefix_lobby .. definesGuiLobby.label_welcome,
    {"frame-lobby.label-welcome", LuaPlayer.name}
  )
  ritnlib.styles.ritn_label(content.label_welcome.style)

  -- ligne séparatrice avant les boutons
  content.line1 = ritnlib.gui.createLineH(
    content.MainFlow,
    prefix_lobby .. definesGuiLobby.line .. "1"
  )


  -- button creation de map
  content.button_create = ritnlib.gui.createButton(
    content.MainFlow,
    prefix_lobby .. definesGuiLobby.button_create,
    ritnmods.teleport.defines.name.caption.frame_lobby.button_create
  )
  ritnlib.styles.ritn_normal_button(content.button_create.style)
  content.button_create.style.minimal_width = 220
  content.button_create.style.font = ritnmods.teleport.defines.name.gui.styles.font.bold18
  content.button_create.style.font_color = {0.109804, 0.109804, 0.109804}
  content.button_create.style.hovered_font_color = {0.109804, 0.109804, 0.109804}
  content.button_create.style.clicked_font_color = {0.109804, 0.109804, 0.109804}

  -- ligne séparatrice entre les 2 actions
  content.line2 = ritnlib.gui.createLineH(
    content.MainFlow,
    prefix_lobby .. definesGuiLobby.line .. "2"
  )

  -- SurfacesFlow
  content.SurfacesFlow = ritnlib.gui.createFlowV(
    content.MainFlow,
    prefix_lobby .. definesGuiLobby.SurfacesFlow
  )
  ritnlib.styles.ritn_flow_surfaces(content.SurfacesFlow.style)
  content.SurfacesFlow.style.horizontal_align = "left"
    
  -- label main surfaces
  content.label_main_surfaces = ritnlib.gui.createLabel(
    content.SurfacesFlow,
    prefix_lobby .. definesGuiLobby.label_main_surfaces,
    ritnmods.teleport.defines.name.caption.frame_lobby.label_main_surfaces
  )
  ritnlib.styles.ritn_label(content.label_main_surfaces.style)
  content.label_main_surfaces.style.font = ritnmods.teleport.defines.name.gui.styles.font.bold14

  -- Pane
  content.Pane = ritnlib.gui.createScrollPane(
    content.SurfacesFlow,
    prefix_lobby .. definesGuiLobby.Pane
  )
  ritnlib.styles.ritn_scroll_pane(content.Pane.style)
    
  -- list
  content.list = ritnlib.gui.createList(
    content.Pane,
    prefix_lobby .. definesGuiLobby.list
  )
  ritnlib.styles.ritn_remote_listbox(content.list.style)
  
  --> ajout des maps dnas la liste
  local nauvis = "nauvis"
  for _,surface in pairs(global.teleport.surfaces) do 
    if surface.name ~= nil then
      if nauvis ~= surface.name then
        content.list.add_item(surface.name)
      end
    end
  end


  -- panel_dialog
  content.panel_dialog = ritnlib.gui.createFlowH(
    content.MainFlow,
    prefix_lobby .. definesGuiLobby.panel_dialog
  )
  ritnlib.styles.ritn_flow_dialog(content.panel_dialog.style)
  content.panel_dialog.style.vertical_align = "center"

  local nbMaps = global.teleport.surface_value-1
  if nbMaps < 0 then nbMaps = 0 end

  -- label main surfaces
  content.label_nb_surfaces = ritnlib.gui.createLabel(
    content.panel_dialog,
    prefix_lobby .. definesGuiLobby.label_nb_surfaces,
    {"frame-lobby.label-nb-surface", nbMaps, global.settings.surfaceMax}
  )
  ritnlib.styles.ritn_label(content.label_nb_surfaces.style)


  --empty
  content.empty = ritnlib.gui.createEmptyWidget(content.panel_dialog)
  content.empty.style.height = 30
  content.empty.style.width = 30

  -- button_valid
  content.button_request = ritnlib.gui.createButton(
    content.panel_dialog,
    prefix_lobby .. definesGuiLobby.button_request,
    ritnmods.teleport.defines.name.caption.frame_lobby.button_request,
    "confirm_button"
  )
  ritnlib.styles.ritn_small_button(content.button_request.style)
  content.button_request.style.maximal_width = 120
  content.button_request.tooltip = {"tooltip.button-valid"}

  ritnlib.utils.pcallLog("lib.gui.lobby.frame_lobby_open(" .. LuaPlayer.name .. ")")
end



---
-- Fonction "GUI"
---


-- close gui
local function frame_lobby_close(LuaPlayer)
  local center = LuaPlayer.gui.center
  local frame_lobby = center[prefix_lobby .. definesGuiLobby.flow_common]

  if frame_lobby then 
    frame_lobby.destroy()
    ritnlib.utils.pcallLog("lib.gui.lobby.action.frame_lobby_close(" .. LuaPlayer.name .. ")")
  end
end


-- open gui
local function frame_lobby_open(LuaPlayer)
  frame_lobby_close(LuaPlayer)
  create_gui_lobby(LuaPlayer)
end


------------------------------
local luaGui = {}
luaGui.open = frame_lobby_open
luaGui.close = frame_lobby_close

return luaGui
