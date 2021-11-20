-- INIT
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.portal =      require(ritnmods.teleport.defines.functions.portal)
ritnlib.teleporter =  require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
ritnlib.surface =     require(ritnmods.teleport.defines.functions.surface)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.remote =      require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.teleporter =  require(ritnmods.teleport.defines.gui.teleporter.GuiElements)
ritnGui.portal =      require(ritnmods.teleport.defines.gui.portal.GuiElements)
ritnGui.lobby =       require(ritnmods.teleport.defines.gui.lobby.GuiElements)
---------------------------------------------------------------------------------------------
local module = {}
module.events = {}


-- Restitution de l'inventaire lors du changement de surface
local function on_player_changed_surface(e)
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local surface = LuaSurface.name
  local oldSurface = game.surfaces[e.surface_index]

  if LuaPlayer.force.name ~= "guides" then
    if game.forces[surface] then --modif 1.8.0 -> old : game.players[surface]
      LuaPlayer.force = surface 
    else
      -- prendre en charge le lobby ici
      if surface == "nauvis" then 
        LuaPlayer.force = "player" 
      end
    end
  end

  if not global.teleport.surfaces[LuaSurface.name] then return end
  if global.teleport.surfaces[LuaSurface.name].name == nil then return end
  ritnlib.surface.addPlayer(LuaPlayer)
  ritnlib.inventory.get(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])
  
  if not global.teleport.surfaces[oldSurface.name] then return end
  if global.teleport.surfaces[oldSurface.name].name == nil then return end
  ritnlib.surface.removePlayer(LuaPlayer, oldSurface)
end


local function on_pre_player_left_game(e)
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local reason = e.reason -- defines.disconnect_reason
  
  ritnlib.utils.ritnLog(">> PRE left game '" .. LuaPlayer.name .. "' : " .. LuaSurface.name)

  if string.sub(LuaSurface.name, 1, 6) == "lobby~" then return end -- add 1.8.3
  
  -- 1.6.2 ---------
  local statut, errorMsg = pcall(function() 
    if not global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] then
      global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] = ritnlib.inventory.init()
      ritnlib.utils.ritnLog(">> (debug) - portal teleport - teleport : init inventaire ok")
    end
  end)
  if statut  == (false or nil) then 
    ritnlib.utils.ritnLog(">> (debug) - ERROR = " .. errorMsg)
  end
  ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])


  if reason == defines.disconnect_reason.quit then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "quit")
  elseif reason == defines.disconnect_reason.dropped then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "dropped")
  elseif reason == defines.disconnect_reason.reconnect then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "reconnect")
  elseif reason == defines.disconnect_reason.wrong_input then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "wrong_input")
  elseif reason == defines.disconnect_reason.desync_limit_reached	then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "desync_limit_reached")
  elseif reason == defines.disconnect_reason.cannot_keep_up	then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "cannot_keep_up")
  elseif reason == defines.disconnect_reason.afk then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "afk")
  elseif reason == defines.disconnect_reason.kicked	then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "kicked")
  elseif reason == defines.disconnect_reason.kicked_and_deleted then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "kicked_and_deleted")
  elseif reason == defines.disconnect_reason.banned	then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "banned")
  elseif reason == defines.disconnect_reason.switching_servers then
    ritnlib.utils.ritnLog(">> PRE left game - Reason : " .. "switching_servers")
  end
  ------------------
end


local function on_player_left_game(e)
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  ritnlib.utils.ritnLog(">> left game '" .. LuaPlayer.name .. "' : " .. LuaSurface.name)
  if string.sub(LuaSurface.name, 1, 6) == "lobby~" then return end -- add 1.8.3
  ritnlib.surface.removePlayer(LuaPlayer, LuaSurface)
end



-- Inscription à la liste des décès 
local function on_pre_player_died(e)
  local LuaPlayer = game.players[e.player_index]
  local guiTeleport = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain]
  local guiPortal = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
  ritnGui.remote.close(LuaPlayer)
  ritnGui.teleporter.close(LuaPlayer.surface, LuaPlayer)
  ritnGui.portal.close(LuaPlayer.surface, LuaPlayer)
  ritnGui.menu.frame_menu_close(LuaPlayer)
  ritnGui.menu.frame_restart_close(LuaPlayer)
  table.insert(global.teleport.player_died, LuaPlayer.name)
end

-- Désinscription à la liste des décès 
local function on_player_respawned(e)
  local LuaPlayer = game.players[e.player_index]
  for i,player in pairs(global.teleport.player_died) do 
    if player == LuaPlayer.name then 
      table.remove(global.teleport.player_died, i)
    end
  end 
end


------------------------------------------------------------------------
-- Nouveau joueur arrivant
-- Créer une surface avec les paramètres enregistrés en map gen settings
local function NewPlayerSurface(LuaPlayer)

      ritnlib.surface.createLobby(LuaPlayer)
      --if not game.is_multiplayer() then
          -- Creation de la surface joueur
          --ritnlib.surface.createSurface(LuaPlayer)
      --end

end


  
  
----------------------------------------------------------------------------------------
-- Quand un joueur arrive en jeu
local function on_player_joined_game(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface

    -- No characters
    if LuaPlayer.character == nil then return end
              
    -- le joueur n'existe pas dans la structure
    if not global.teleport.players[LuaPlayer.name] then 
      print(">> debug : not surface : create")
      NewPlayerSurface(LuaPlayer)
      return
    -- le joueur n'est plus lié à une map d'origine
    elseif global.teleport.players[LuaPlayer.name].origine == "" then
      print(">> debug : not surface : create")
      NewPlayerSurface(LuaPlayer)
      return
    end

    local surfaceOrigineName = global.teleport.players[LuaPlayer.name].origine

    -- player is home
    if  surfaceOrigineName == LuaSurface.name then
      ritnlib.surface.addPlayer(LuaPlayer)
      ritnlib.inventory.get(LuaPlayer, global.teleport.surfaces[surfaceOrigineName].inventories[LuaPlayer.name])
      LuaPlayer.character.active = true
    else -- player is no home
      LuaPlayer.teleport({0,0}, global.teleport.players[LuaPlayer.name].origine)
      LuaPlayer.character.active = true
    end
end
  
-------------------------------------------------------------------------------------------------------------
-- Vérifie si le joueur est proche d'un portail lié quand il est en mouvement et le téléporte si c'est le cas
local function on_player_changed_position(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface

    -- No characters
    if LuaPlayer.character == nil then return end
  
    if global.teleport.surfaces[LuaSurface.name] then  

      -- mise à jour de l'info tp sur deplacement du joueurs
      if global.teleport.surfaces[LuaSurface.name].players then 
        local player = global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name]
        if player then
          if player.tick then
            if (game.tick - player.tick) >= 180 then
              player.tp = false
            end
          end
        end
      end

      if global.teleport.surfaces[LuaSurface.name].portals then
        local nb_portal = ritnlib.portal.getValue(LuaSurface)
        
        if nb_portal > 0 then
  
          for _,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
            if portal.teleport ~= 0 then
                  
                if (LuaPlayer.position.x >= (portal.position.x - 1) 
                  and LuaPlayer.position.x <= (portal.position.x + 1)) 
                  and (LuaPlayer.position.y >= (portal.position.y - 1) 
                  and LuaPlayer.position.y <= (portal.position.y + 1)) then
                      
                  local position = portal.position
                  local id = ritnlib.portal.getId(LuaSurface, position)
                  local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
                      
                  -- Teleportation
                  ritnlib.portal.teleport(LuaSurface, id, LuaPlayer)

                  -- Fermeture de tous les gui
                  ritnGui.remote.close(LuaPlayer)
                  ritnGui.teleporter.close(LuaPlayer.surface, LuaPlayer)
                  ritnGui.portal.close(LuaPlayer.surface, LuaPlayer)
                  ritnGui.menu.frame_menu_close(LuaPlayer)
                  ritnGui.menu.frame_restart_close(LuaPlayer)
                  
                end 
  
            end
          end
  
        end
  
      end

    end
end


local function on_runtime_mod_setting_changed(e)
  local LuaPlayer = game.players[e.player_index]
  local setting_name = e.setting
  local setting_type = e.setting_type

  if setting_type == "runtime-per-user" then 
    if setting_name == ritnmods.teleport.defines.name.settings.enable_main_button then 
      ritnGui.menu.button_main_open(LuaPlayer)
    end
  end

  if setting_type == "runtime-global" then 
    if setting_name == ritnmods.teleport.defines.name.settings.surfaceMax then
      local setting_value = settings.global[setting_name].value
      global.settings.surfaceMax = setting_value
    end
  end

end


-- Annonce les recherche terminée si le joueur n'est pas chez lui
local function on_research_finished(e)
  if e.by_script == true then return end 

  local LuaTechnology = e.research
  local LuaForce = LuaTechnology.force
  local LuaPlayer = game.players[LuaForce.name]
  
  if LuaPlayer then 
    local setting_name = ritnmods.teleport.defines.name.settings.show_research
    local setting_value = settings.get_player_settings(LuaPlayer)[setting_name].value
    if LuaPlayer.surface.name ~= LuaForce.name then 
      if setting_value then
        local richText = "[technology=" .. LuaTechnology.name .. "]"
        LuaPlayer.print({ritnmods.teleport.defines.name.caption.msg.show_research, richText}, {r=1,g=0,b=0,a=1})
      end
    end
  end
end




-- Events Player
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_player_joined_game] = on_player_joined_game
module.events[defines.events.on_pre_player_left_game] = on_pre_player_left_game
module.events[defines.events.on_player_left_game] = on_player_left_game
module.events[defines.events.on_player_changed_position] = on_player_changed_position
module.events[defines.events.on_pre_player_died] = on_pre_player_died
module.events[defines.events.on_player_respawned] = on_player_respawned
module.events[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
module.events[defines.events.on_research_finished] = on_research_finished

return module