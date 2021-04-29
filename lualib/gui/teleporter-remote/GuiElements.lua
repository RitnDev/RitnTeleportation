---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =  require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------

-- INIT
local luaGui = {}
local modGui = require("mod-gui")
-- Properties
local prefix = ritnmods.teleport.defines.name.gui.prefix.remote
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart
--local direction = "vertical"


-- CREATION DU GUI
local GuiElement = {

  main_remote = {
    name = ritnmods.teleport.defines.name.gui.main_remote,
    caption = {"frame-teleporter.teleporter-gui-name"},
  },

  panel_main = prefix .. ritnmods.teleport.defines.name.gui.panel_main,
  SurfacesFlow = prefix .. ritnmods.teleport.defines.name.gui.SurfacesFlow,
  Pane = prefix .. ritnmods.teleport.defines.name.gui.Pane,
  list = prefix .. ritnmods.teleport.defines.name.gui.NameList,

  button_teleport = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_teleport,
    caption = ritnmods.teleport.defines.name.caption.frame_teleporter.button_teleport,
  },

}



---
-- Creation de la fenetre
---
local function create_gui(LuaPlayer)
  
  local LuaSurface = LuaPlayer.surface
  local left = modGui.get_frame_flow(LuaPlayer)
  local content = {}

  -- Creation de la fenêtre du portail
  content.main = ritnlib.gui.createFrame(
    left, 
    GuiElement.main_remote.name,
    GuiElement.main_remote.caption
  )
  ritnlib.styles.ritn_frame_remote_style(content.main.style)
  
  
  -- Panel Principale
  content.panel_main = ritnlib.gui.createFlowV(
    content.main, 
    GuiElement.panel_main
  )
  ritnlib.styles.ritn_flow_panel_main(content.panel_main.style)


  -- SurfacesFlow
  content.SurfacesFlow = ritnlib.gui.createFlowV(
    content.panel_main, 
    GuiElement.SurfacesFlow
  )
  ritnlib.styles.ritn_flow_surfaces(content.SurfacesFlow.style)


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
  ritnlib.styles.ritn_remote_listbox(content.list.style)

  if ritnlib.teleporter.getValue(LuaSurface) >= 1 then
      for x,teleport in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
          if teleport.teleport == 1 then
              content.list.add_item(teleport.name)
          end
      end
  end
  
  -- button teleport
  content.button_teleport = ritnlib.gui.createButton(
    content.panel_main,
    GuiElement.button_teleport.name,
    GuiElement.button_teleport.caption
  )
  ritnlib.styles.ritn_small_button(content.button_teleport.style)
end




local function close(LuaPlayer)
  local left = modGui.get_frame_flow(LuaPlayer)
  local LuaGui = left[ritnmods.teleport.defines.name.gui.main_remote]
  if LuaGui then 
      LuaGui.destroy()
  end
end

local function open(LuaPlayer)
  close(LuaPlayer)
  create_gui(LuaPlayer)
end


--------------------------
luaGui.show = create_gui
luaGui.open = open
luaGui.close = close 

return luaGui

