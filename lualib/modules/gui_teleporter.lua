---------------------------------------------------------------------------------------------
-- >>  GUI TELEPORTER
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.teleporter =      require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.utils =           require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =              require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.remote =            require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.teleporter =        require(ritnmods.teleport.defines.gui.teleporter.GuiElements)
ritnGui.teleporter.action = require(ritnmods.teleport.defines.gui.teleporter.action)
---------------------------------------------------------------------------------------------

-- INITIALISATION
-- Chargement des elements à créer
local prefix = ritnmods.teleport.defines.name.gui.prefix.teleporter
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart

-- Creation du module
local module = {}
module.events = {}


---
-- Events GUI
---

-- Ouvre la fenêtre GUI du teleporter si on clique dessus
local function on_gui_opened(e)
    
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local LuaEntity = e.entity
  
  -- fermeture de la fenetre de la remote 
  ritnGui.remote.close(LuaPlayer)
  -- fermeture du menu
  ritnGui.menu.frame_menu_close(LuaPlayer)

  -- On ouvre pas la fenêtre de portail si l'interface restart est déjà ouverte
  local center = LuaPlayer.gui.center
  local frame_restart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
  if frame_restart then return end

  if LuaEntity then
    if LuaEntity.name == ritnmods.teleport.defines.name.entity.teleporter then
   
      local position = LuaEntity.position
      LuaEntity.operable = false
      LuaEntity.minable = false
      
      if global.teleport.players[LuaPlayer.name].origine == LuaSurface.name then
        ritnGui.teleporter.open(LuaSurface, LuaPlayer, LuaEntity)
      else
        LuaEntity.operable = true
        LuaEntity.minable = true
      end

      local details = {
        lib = "modules",
        category = "gui_teleporter",
      }
      ritnlib.utils.pcallLog(details, e)
    end
  end
end

-- Event click GUI
-- Déclenche les actions quand on clique sur les boutons du GUI
local function on_gui_click(e)

  local element = e.element
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain]
  local pattern = "([^-]*)-?([^-]*)-?([^-]*)"
  local click = {
    ui, element, name, action
  }
 
  if LuaGui == nil then return end 
  if LuaGui.name ~= ritnmods.teleport.defines.name.gui.NamerMain then end
  if element == nil then return end
  if element.valid == false then return end
    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(element.name, pattern)
    click.action = click.element .. "-" .. click.name

  if click.ui ~= "teleporter" then return end
  if click.element ~= "button" then return end

  if click.action == ritnmods.teleport.defines.name.gui.button_close
  or click.action == ritnmods.teleport.defines.name.gui.button_valid then
    local info = LuaGui[prefix .. ritnmods.teleport.defines.name.gui.Infos].caption
    local position = ritnlib.utils.split(info, " ")
    local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.teleporter, position)
    ritnGui.teleporter.action[click.action](LuaSurface, LuaPlayer, LuaEntity, position)

    local details = {
      lib = "modules",
      category = "gui_teleporter",
    }
    ritnlib.utils.pcallLog(details, e)
  else return
  end

end

-- Appuie sur entrer lors de la saisie dans TextNamer
local function on_gui_confirmed(e)

  local element = e.element
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain]
  
  if LuaGui == nil then return end 
  if LuaGui.name ~= ritnmods.teleport.defines.name.gui.NamerMain then return end
  if element == nil then return end
  if element.valid == false then return end

  if element.name == prefix .. ritnmods.teleport.defines.name.gui.TextNamer then
    local info = LuaGui[prefix .. ritnmods.teleport.defines.name.gui.Infos].caption
    local position = ritnlib.utils.split(info, " ")
    local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.teleporter, position)
    ritnGui.teleporter.action[ritnmods.teleport.defines.name.gui.button_valid](LuaSurface, LuaPlayer, LuaEntity, position)

    local details = {
      lib = "modules",
      category = "gui_teleporter",
    }
    ritnlib.utils.pcallLog(details, e)
  end

end



module.events[defines.events.on_gui_opened] = on_gui_opened
module.events[defines.events.on_gui_click] = on_gui_click
module.events[defines.events.on_gui_confirmed] = on_gui_confirmed

return module