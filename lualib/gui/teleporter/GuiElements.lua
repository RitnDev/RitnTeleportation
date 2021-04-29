---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =    require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.utils =         require(ritnmods.teleport.defines.functions.utils)
ritnlib.gui =           require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =        require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------


-- Properties
local visible = false
local prefix = ritnmods.teleport.defines.name.gui.prefix.teleporter
local luaGui = {}


-- CREATION DU GUI
local guiElement = {

  NamerMain = {
    name = ritnmods.teleport.defines.name.gui.NamerMain,
    caption = {"frame-teleporter.teleporter-gui-name"},
  },
  TextNamer = prefix .. ritnmods.teleport.defines.name.gui.TextNamer,
  panel_main = prefix .. ritnmods.teleport.defines.name.gui.panel_main,
  ButtonFlow = prefix .. ritnmods.teleport.defines.name.gui.ButtonFlow,
  Infos = prefix .. ritnmods.teleport.defines.name.gui.Infos,
  button_close = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_close,
    caption = ritnmods.teleport.defines.name.caption.frame_surfaces.button_close,
  },
  button_valid = {
    name = prefix .. ritnmods.teleport.defines.name.gui.button_valid,
    caption = ritnmods.teleport.defines.name.caption.frame_surfaces.button_valid,
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
      guiElement.NamerMain.name,
      guiElement.NamerMain.caption
    )
  ritnlib.gui.frameAutoCenter(content.main)
  ritnlib.styles.ritn_frame_style(content.main.style)

  -- Textfield
  content.TextNamer = ritnlib.gui.createTextField(
      content.main, 
      guiElement.TextNamer
    )
  content.TextNamer.text = ritnlib.teleporter.getNamePosition(LuaSurface, LuaEntity.position)
  content.TextNamer.select_all()
  content.TextNamer.focus()
  
  -- Panel Principale
  content.panel_main = ritnlib.gui.createFlowV(
        content.main, 
        guiElement.panel_main
      )
  ritnlib.styles.ritn_flow_panel_main(content.panel_main.style)

  -- Flow principale
  content.ButtonFlow = ritnlib.gui.createFlowH(
      content.panel_main,
      guiElement.ButtonFlow
    )
  ritnlib.styles.ritn_flow_dialog(content.ButtonFlow.style)

  -- Infos
  content.infos = ritnlib.gui.createLabel(
      content.main,
      guiElement.Infos,
      LuaEntity.position.x .. " " .. LuaEntity.position.y,
      visible
    )

  -- Button Close
  content.button_close = ritnlib.gui.createButton(
      content.ButtonFlow,
      guiElement.button_close.name,
      guiElement.button_close.caption,
      "red_back_button"
    )
  ritnlib.styles.ritn_small_button(content.button_close.style)

  -- valid_button
  content.button_valid = ritnlib.gui.createButton(
    content.ButtonFlow,
    guiElement.button_valid.name,
    guiElement.button_valid.caption,
    "confirm_button"
  )
  ritnlib.styles.ritn_small_button(content.button_valid.style)

end


---
-- Fonction "GUI"
---


-- close gui
local function close(LuaSurface, LuaPlayer, LuaEntity)
  local guiTeleport = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain]
  if guiTeleport then
    if LuaSurface then
      
      if LuaEntity == nil then 
        local info = guiTeleport[prefix .. ritnmods.teleport.defines.name.gui.Infos].caption
        local position = ritnlib.utils.split(info, " ")
        LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.teleporter, position)
      end
      LuaEntity.operable = true
      LuaEntity.minable = true
    end
    guiTeleport.destroy()
  end
end


-- open gui
local function open(LuaSurface, LuaPlayer, LuaEntity)
  close(LuaSurface, LuaPlayer, LuaEntity)
  create_gui(LuaSurface, LuaPlayer, LuaEntity)
end



------------------------------
luaGui.show = create_gui
luaGui.open = open
luaGui.close = close

return luaGui