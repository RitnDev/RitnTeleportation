---------------------------------------------------------------------------------------------
-- >>  GUI MENU
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.gui =       require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =    require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.menu.action = require(ritnmods.teleport.defines.gui.menu.action)
---------------------------------------------------------------------------------------------

-- INITIALISATION
if not global.cutscene then global.cutscene = false end
-- Chargement des elements à créer
local modGui = require("mod-gui")
local prefix_gui = ritnmods.teleport.defines.prefix.gui
local prefix_menu = ritnmods.teleport.defines.name.gui.prefix.menu
local prefix_main_menu = ritnmods.teleport.defines.name.gui.prefix.main_menu
local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart

local GuiElement = {
  flow_common = prefix_gui .. ritnmods.teleport.defines.name.gui.flow_common,
  flow_menu = prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_menu,
  flow_menu_frame = prefix_menu .. ritnmods.teleport.defines.name.gui.menu.flow_menu_frame,
}

-- Creation du module
local module = {}
module.events = {}


----------------
-- Events GUI --
----------------

-- Fin de la cutscene
local function on_cutscene_waypoint_reached(e)
    local WayPoint = e.waypoint_index

    if WayPoint == 1 then 
      global.cutscene = true
    end

    local details = {
      lib = "modules",
      category = "gui_menu",
      state = "ok"
    }
    ritnlib.utils.pcallLog(details, e)

end

-- Annulation de la cutscene
local function on_cutscene_cancelled(e)
    local LuaPlayer = game.players[e.player_index]
    if LuaPlayer.connected then
      global.cutscene = true
    end

    local details = {
      lib = "modules",
      category = "gui_menu",
      state = "ok"
    }
    ritnlib.utils.pcallLog(details, e)
end

local function on_rocket_launched(e)
    local LuaEntity = e.rocket
    local LuaSurface = LuaEntity.surface

    if not game.is_multiplayer() then return end
    
    -- Mise à true de l'info finish de la surface pour activer le bouton menu
    if global.teleport.surfaces[LuaSurface.name].finish == false then
      global.teleport.surfaces[LuaSurface.name].finish = true 

      -- Activer le bouton si un/des joueur(s) sont connectés au moment du lancé
      for _,player in pairs(game.players) do 
        if player.name == LuaSurface.name then 
          if player.surface.name == LuaSurface.name then 
            if player.connected then 
              local LuaPlayer = player
              local top = modGui.get_button_flow(LuaPlayer)
              if not top[ritnmods.teleport.defines.name.gui.menu.button_main] then
                ritnGui.menu.button_main_show(LuaPlayer)
              end
            end
          end
        end
      end

    end

    local details = {
      lib = "modules",
      category = "gui_menu",
      state = "ok"
    }
    ritnlib.utils.pcallLog(details, e)

end


local function on_player_joined_game(e)
    local LuaPlayer = game.players[e.player_index]

    local details = {
      lib = "modules",
      category = "gui_menu",
      state = "show"
    }
    ritnlib.utils.pcallLog(details, e)

    if LuaPlayer.admin then 
      ritnGui.menu.button_main_open(LuaPlayer)
      return
    end

    if global.teleport.surfaces[LuaPlayer.name] then 
      if LuaPlayer.name == LuaPlayer.surface.name then
        ritnGui.menu.button_main_open(LuaPlayer)
        return
      end
    end

end


local function on_player_changed_surface(e)
  local LuaPlayer = game.players[e.player_index]

  if global.teleport.surfaces[LuaPlayer.name] then 
    if LuaPlayer.name == LuaPlayer.surface.name then
        ritnGui.menu.button_main_open(LuaPlayer)

        local details = {
          lib = "modules",
          category = "gui_menu",
          state = "ok"
        }
        ritnlib.utils.pcallLog(details, e)
        return
    end
  end
end


local function on_gui_click_restart(e, click)

  local element = e.element
  local LuaPlayer = game.players[e.player_index]
  local center = LuaPlayer.gui.center
  local LuaGuiRestart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
 
  
  -- Action de la frame Restart
  if LuaGuiRestart == nil then return false end 
  -- Problème lors du compare donc je passe par une variable intermédiaire.
  local LuaGui_name = ""
  LuaGui_name = prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart

  if LuaGuiRestart.name ~= LuaGui_name then return false end
  if click.ui == "restart" then
    if click.action == ritnmods.teleport.defines.name.gui.menu.button_cancel
    or click.action == ritnmods.teleport.defines.name.gui.menu.button_valid then
      ritnGui.menu.action[click.action](LuaPlayer, click)

      return true
    end
  end

  return false
end



-- Event click GUI
-- Déclenche les actions quand on clique sur les boutons du GUI
local function on_gui_click(e)

  local element = e.element
  local LuaPlayer = game.players[e.player_index]
  local left = modGui.get_frame_flow(LuaPlayer)
  local center = LuaPlayer.gui.center
  if not left[GuiElement.flow_common] then 
    on_player_joined_game(e)
  end
  local LuaGui = left[GuiElement.flow_common][GuiElement.flow_menu][GuiElement.flow_menu_frame]
  local LuaGuiRestart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
  local pattern = "([^-]*)-?([^-]*)-?([^-]*)"
  local click = {
    ui, element, name, action
  }
 
  local details = {
    lib = "modules",
    category = "gui_menu"
  }
  ritnlib.utils.pcallLog(details, e)


  if element == nil then return end
  if element.valid == false then return end
    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(element.name, pattern)
    click.action = click.element .. "-" .. click.name


  -- Action du bouton restart
  local restart = on_gui_click_restart(e, click, pattern)
  if restart == true then return end


  -- Action du bouton main
  if click.ui == "ritn" then
    if click.element ~= "button" then return end
    if click.name ~= "main" then return end
    click.action = click.ui .. "-" .. click.action
    ritnGui.menu.action[click.action](LuaPlayer)
    return
  end


  -- Action de la frame menu
  if LuaGui == nil then return end 
  if LuaGui.name ~= GuiElement.flow_menu_frame then return end
  if click.ui == "main_menu" then
    if click.action == ritnmods.teleport.defines.name.gui.menu.button_restart
    or click.action == ritnmods.teleport.defines.name.gui.menu.button_tp
    or click.action == ritnmods.teleport.defines.name.gui.menu.button_exclusion
    or click.action == ritnmods.teleport.defines.name.gui.menu.button_clean then
      ritnGui.menu.action[click.action](LuaPlayer)
      return 
    end
  end

  
  -- Action de la frame Surfaces
  if LuaGui == nil then return end 
  -- Problème lors du compare donc je passe par une variable intermédiaire.
  local LuaGui_name = ""
  LuaGui_name = GuiElement.flow_menu_frame

  if LuaGui.name ~= LuaGui_name then return end
  if click.ui == "surfaces_menu" then
    if click.action == ritnmods.teleport.defines.name.gui.menu.button_close
    or click.action == ritnmods.teleport.defines.name.gui.menu.button_valid then
      local parent 
      local _, parent = string.match(element.parent.parent.name, pattern)
      ritnGui.menu.action[click.action](LuaPlayer, click, parent)
      return 
    end
  end

end

-----------------
module.events[defines.events.on_cutscene_waypoint_reached] = on_cutscene_waypoint_reached
module.events[defines.events.on_cutscene_cancelled] = on_cutscene_cancelled
module.events[defines.events.on_rocket_launched] = on_rocket_launched
module.events[defines.events.on_player_joined_game] = on_player_joined_game
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_gui_click] = on_gui_click
  
return module