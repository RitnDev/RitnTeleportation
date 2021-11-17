---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------

-- Properties
local visible = false
local modGui = require("mod-gui")
local prefix_lobby = ritnmods.teleport.defines.name.gui.prefix.lobby
local definesGuiLobby = ritnmods.teleport.defines.name.gui.lobby
local luaGui = {}



---
-- Creation de la fenetre principale
---
local function create_gui_request(LuaPlayer)
  local left = modGui.get_frame_flow(LuaPlayer)
  local content = {}
    
    content.main = ritnlib.gui.createFrame(
        left,
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


-- close gui
local function close(LuaPlayer)
    local center = LuaPlayer.gui.center
    local frame_lobby = center[prefix_lobby .. definesGuiLobby.flow_common]
  
    if frame_lobby then 
      frame_lobby.destroy()
    end
end
  
  
-- open gui
local function open(LuaPlayer)
    frame_lobby_close(LuaPlayer)
    create_gui_lobby(LuaPlayer)
end
  
  
  ------------------------------
  luaGui.open = frame_lobby_open
  luaGui.close = frame_lobby_close
  
  return luaGui