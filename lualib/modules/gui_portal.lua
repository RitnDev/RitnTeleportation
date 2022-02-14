---------------------------------------------------------------------------------------------
-- >>  GUI PORTAL
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.portal =      require(ritnmods.teleport.defines.functions.portal)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =          require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.remote =        require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.portal =        require(ritnmods.teleport.defines.gui.portal.GuiElements)
ritnGui.portal.action = require(ritnmods.teleport.defines.gui.portal.action)
---------------------------------------------------------------------------------------------

-- INITIALISATION
-- Chargement des elements à créer
local prefix = ritnmods.teleport.defines.name.gui.prefix.portal
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart

-- Creation du module
local module = {}
module.events = {}

---
-- Events GUI
---

-- Ouvre la fenêtre GUI du portail si on clique dessus

local function on_gui_opened(e)
    
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    local LuaEntity = e.entity
    
    -- fermeture de la fenetre des teleporteurs
    ritnGui.remote.close(LuaPlayer)
    -- fermeture du menu
    ritnGui.menu.frame_menu_close(LuaPlayer)

    -- On ouvre pas la fenêtre de portail si l'interface restart est déjà ouverte
    local center = LuaPlayer.gui.center
    local frame_restart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
    if frame_restart then return end

    if LuaEntity then
      if LuaEntity.name == ritnmods.teleport.defines.name.entity.portal then
 
        local pos = LuaEntity.position     
        LuaEntity.operable = false
        LuaEntity.minable = false
        
        local details = {
          lib = "modules",
          category = "gui_portal",
          funct = "on_gui_opened",
          player = LuaPlayer.name,
          surface = LuaSurface.name,
          state = "ok"
        }
        ritnlib.utils.pcallLog(details, e)
        
        if LuaPlayer.name == LuaSurface.name then
          ritnGui.portal.open(LuaPlayer, LuaSurface, LuaEntity)
        else
          LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_access)
          LuaEntity.operable = true
          LuaEntity.minable = true
        end
        
      end
    end
end


-- Event click GUI
local function on_gui_click(e)

  local element = e.element
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
  local pattern = "([^-]*)-?([^-]*)-?([^-]*)"
  local click = {
    ui, element, name, action
  }

  if LuaGui == nil then return end 
  if LuaGui.name ~= ritnmods.teleport.defines.name.gui.main_portal then return end
  if element == nil then return end
  if element.valid == false then return end
    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(element.name, pattern)
    click.action = click.element .. "-" .. click.name
  
  if click.ui ~= "portal" then return end
  if click.element ~= "button" then return end

  local details = {
    lib = "modules",
    category = "gui_portal",
  }
  ritnlib.utils.pcallLog(details, e)

  if click.action == ritnmods.teleport.defines.name.gui.button_close
  or click.action == ritnmods.teleport.defines.name.gui.button_unlink
  or click.action == ritnmods.teleport.defines.name.gui.button_link
  or click.action == ritnmods.teleport.defines.name.gui.button_back
  or click.action == ritnmods.teleport.defines.name.gui.button_valid then
    local info = LuaGui[prefix .. ritnmods.teleport.defines.name.gui.Infos].caption
    local position = ritnlib.utils.split(info, " ")
    local id = ritnlib.portal.getId(LuaSurface, position)
    ritnGui.portal.action[click.action](LuaPlayer, LuaSurface, id, position)
  else return end

end

module.events[defines.events.on_gui_opened] = on_gui_opened
module.events[defines.events.on_gui_click] = on_gui_click

return module