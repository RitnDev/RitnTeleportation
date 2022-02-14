---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------

-- Properties
local visible = false
local modGui = require("mod-gui")
local prefix_gui = ritnmods.teleport.defines.prefix.gui
local prefix_request = ritnmods.teleport.defines.name.gui.prefix.request
local definesGuiRequest = ritnmods.teleport.defines.name.gui.request
local caption = ritnmods.teleport.defines.name.caption
local flow_common = prefix_gui .. ritnmods.teleport.defines.name.gui.flow_common
local flow_request = prefix_request .. definesGuiRequest.flow_request


---
-- Creation de la fenetre principale
---
local function create_gui_request(LuaPlayer, request)
  local left = modGui.get_frame_flow(LuaPlayer)
  local content = {}

    -- MAIN :
    content.flow_request = left[flow_common][flow_request]
    
    --frame request
    content.main = ritnlib.gui.createFrame(
      content.flow_request,
      prefix_request .. definesGuiRequest.frame_request .. "_" .. request.name,
      {"frame-request.titre", request.name}
    )
    
    -- flow label
    content.flow_label = ritnlib.gui.createFlowV(
      content.main,
      prefix_request .. definesGuiRequest.flow_label
    )
    ritnlib.styles.ritn_flow_surfaces(content.flow_label.style)
  
    -- label d'explication
    content.label_explication = ritnlib.gui.createLabel(
      content.flow_label,
      prefix_request .. definesGuiRequest.label_explication,
      {"frame-request.label-explication", request.name}
    )
    
    -- flow dialog : pour y mettre les boutons
    content.panel_dialog = ritnlib.gui.createFlowH(
      content.flow_label,
      prefix_request .. definesGuiRequest.panel_dialog .. "_" .. request.name
    )
    ritnlib.styles.ritn_flow_dialog(content.panel_dialog.style)
  
    -- button_reject
    content.button_reject = ritnlib.gui.createButton(
      content.panel_dialog,
      prefix_request .. definesGuiRequest.button_reject,
      caption.frame_request.button_reject,
      "red_back_button"
    )
    ritnlib.styles.ritn_small_button(content.button_reject.style)

    --empty widget 5px
    content.empty = ritnlib.gui.createEmptyWidget(content.panel_dialog)
    content.empty.style.width = 2

    -- sprite-button : reject all
    content.button_rejectAll = ritnlib.gui.createButton(
      content.panel_dialog,
      prefix_request .. definesGuiRequest.button_rejectAll,
      caption.frame_request.button_rejectAll,
      "dialog_button"
    )
    content.button_rejectAll.style.height = 30
    content.button_rejectAll.style.width = 90
    -- a modif si besoin
    content.button_rejectAll.style.font = ritnmods.teleport.defines.name.gui.styles.font.default12
    content.button_rejectAll.tooltip = {"tooltip.button-reject_all"}
  
    --empty-widget : espacement pour mettre le bouton accept à droite
    content.empty = ritnlib.gui.createEmptyWidget(content.panel_dialog)
    content.empty.style.width = 95
  
    -- button_accept
    content.button_accept = ritnlib.gui.createButton(
      content.panel_dialog,
      prefix_request .. definesGuiRequest.button_accept,
      caption.frame_request.button_accept,
      "confirm_button"
    )
    ritnlib.styles.ritn_small_button(content.button_accept.style)
    
  end

















---
-- Fonction "GUI"
---


-- close gui
local function close(LuaPlayer, request)
    local left = modGui.get_frame_flow(LuaPlayer)
    local frame_request = {}
    local result = pcall(function()
      frame_request = left[flow_common][flow_request][prefix_request .. definesGuiRequest.frame_request .. "_" .. request.name]
    end)
  

    if frame_request and result == true then 
      frame_request.destroy()
      ritnlib.utils.pcallLog("lib.gui.request.close(" .. LuaPlayer.name .. ", " ..  request.name .. ")")
    end
end

  
-- open gui
local function open(LuaPlayer, request)
    close(LuaPlayer, request)
    create_gui_request(LuaPlayer, request)
    ritnlib.utils.pcallLog("lib.gui.request.open(" .. LuaPlayer.name .. ", " ..  request.name .. ")")
end
  
  
  ------------------------------
  local luaGui = {}
  luaGui.open = open
  luaGui.close = close
  
  return luaGui