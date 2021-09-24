-- INIT
local util =          require(ritnmods.teleport.defines.mods.vanilla.lib.util)
local crash_site =    require(ritnmods.teleport.defines.mods.vanilla.lib.CrashSite)
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.player =      require(ritnmods.teleport.defines.functions.player)
ritnlib.portal =      require(ritnmods.teleport.defines.functions.portal)
ritnlib.teleporter =  require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
ritnlib.surface =     require(ritnmods.teleport.defines.functions.surface)
ritnlib.seablock =    require(ritnmods.teleport.defines.mods.seablock)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.remote =      require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.teleporter =  require(ritnmods.teleport.defines.gui.teleporter.GuiElements)
ritnGui.portal =      require(ritnmods.teleport.defines.gui.portal.GuiElements)
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
    if game.players[surface] then
      LuaPlayer.force = surface 
    else
      if surface == "nauvis" then 
        LuaPlayer.force = "player" 
      end
    end
  end

  if not global.teleport.surfaces[LuaSurface.name] then return end
  if global.teleport.surfaces[LuaSurface.name].name == nil then return end
  if not global.teleport.surfaces[oldSurface.name] then return end
  if global.teleport.surfaces[oldSurface.name].name == nil then return end
  ritnlib.surface.addPlayer(LuaPlayer)
  ritnlib.surface.removePlayer(LuaPlayer, oldSurface)
  ritnlib.inventory.get(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])
end


local function on_pre_player_left_game(e)
  local LuaPlayer = game.players[e.player_index]
  local LuaSurface = LuaPlayer.surface
  local reason = e.reason -- defines.disconnect_reason
  
  ritnlib.utils.ritnLog(">> PRE left game '" .. LuaPlayer.name .. "' : " .. LuaSurface.name)
  
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
local function on_player_created(LuaPlayer)
      
      -- Si le nb_forces atteint +61 les joueurs sont kick
      if #game.forces < 63 then 
        
        -- Recupération des settings de la map (nauvis)
        if not global.map_gen_settings.seed then 
          game.map_settings.enemy_evolution.time_factor = 0   -- add 1.5.7
          global.map_gen_settings = game.surfaces.nauvis.map_gen_settings
          --add 1.5.0
          if global.map_gen_settings["autoplace_controls"]["enemy-base"].size == 0 then 
            global.enemy.value = false
          else
            global.enemy.value = true
          end
        end
  
        local map_gen = global.map_gen_settings

        if global.generate_seed == false then
          -- Change la seed
          map_gen.seed = math.random(1,4294967290)
        end

        local LuaSurface = game.create_surface(LuaPlayer.name, map_gen)  
        local tiles = {}
        
        for x=-1,1 do
          for y=-1,1 do
            table.insert(tiles, {name = "lab-white", position = {x, y}})
          end
        end
        
        LuaSurface.set_tiles(tiles) 
        local LuaForce = game.create_force(LuaPlayer.name)
        LuaForce.reset()
        LuaForce.research_queue_enabled = true
        LuaForce.chart(LuaSurface, {{x = -100, y = -100}, {x = 100, y = 100}})
        if game.active_mods["SeaBlock"] then  
          ritnlib.seablock.startMap(LuaSurface)
        end
        
        for k,v in pairs(game.forces) do
          if v.name ~= "enemy" and v.name ~= "neutral" then
            LuaForce.set_friend(v.name,true)
            game.forces["player"].set_friend(LuaForce.name, true)
          end
        end
  
        for r_name,recipe in pairs(LuaPlayer.force.recipes) do
          LuaForce.recipes[r_name].enabled = recipe.enabled
        end

        --Chargement des items
        LuaPlayer.clear_items_inside()
        local items_start_variantes = 1
        -- Variantes avec SpaceBlock
        if game.active_mods["spaceblock"] then
          items_start_variantes = 2
        end
        if game.active_mods["SeaBlock"] then
          items_start_variantes = 3
        end
        ritnlib.player.give_start_item(LuaPlayer, items_start_variantes)
        
        ritnlib.surface.generateSurface(game.surfaces.nauvis)
        global.teleport.surfaces["nauvis"].exception = true
        global.teleport.surfaces["nauvis"].map_used = true
        ritnlib.surface.generateSurface(LuaSurface)
        global.teleport.surfaces[LuaSurface.name].exception = LuaPlayer.admin
        global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] = ritnlib.inventory.init()
  
        -- Teleportation sur la surface du personnage.
        ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])
        LuaPlayer.teleport({0,0}, LuaSurface.name)
        
        -- Add Crash site :
        if items_start_variantes <= 1 then   
          crash_site.create_crash_site(LuaSurface, {-5,-6}, util.copy(global.crashed_ship_items), util.copy(global.crashed_debris_items))
          util.remove_safe(LuaPlayer, global.crashed_ship_items)
          util.remove_safe(LuaPlayer, global.crashed_debris_items)
        end
        
      else
        game.kick_player(LuaPlayer.name, ritnmods.teleport.defines.name.caption.msg.serveur_full)
      end
  end


  
  
----------------------------------------------------------------------------------------
-- Quand un joueur arrive en jeu
local function on_player_joined_game(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    -- player is home
    if LuaPlayer.name == LuaSurface.name then
  
      if not global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] then
        game.kick_player(LuaPlayer, "Fail to load datas, please retry !")
        game.remove_offline_players(LuaPlayer)
      end
      ritnlib.surface.addPlayer(LuaPlayer)
      ritnlib.inventory.get(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])
    else

      -- No characters
      if LuaPlayer.character == nil then return end
      
      -- new player created
      if not global.teleport.surfaces[LuaPlayer.name] then
        print(">> debug : not surface : create")
        if LuaSurface.name == "nauvis" then
          on_player_created(LuaPlayer)
          return
        end
      else
        print(">> debug : surface exist : " .. LuaPlayer.name)
      end
      -- reactive player
      if global.teleport.surfaces[LuaPlayer.name].name == nil then 
        print(">> debug : valid false : create")
        if LuaSurface.name == "nauvis" then
          on_player_created(LuaPlayer)
          return
        end
      else
        print(">> debug : valid true : " .. LuaPlayer.name)
      end
   
      -- player is no home
      LuaPlayer.teleport({0,0}, LuaPlayer.name)
  
      if not global.teleport.surfaces[LuaPlayer.name].inventories[LuaPlayer.name] then
        game.kick_player(LuaPlayer, "Fail to load datas, please retry !")
        game.remove_offline_players(LuaPlayer)
      end
  
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
  
                local p_pos = LuaPlayer.position
                local et_pos = portal.position
                  
                if (p_pos.x >= (et_pos.x - 1) and p_pos.x <= (et_pos.x + 1)) and (p_pos.y >= (et_pos.y - 1) and p_pos.y <= (et_pos.y + 1)) then
                      
                  local position = et_pos
                  local id = ritnlib.portal.getId(LuaSurface, position)
                  local LuaGui = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.main_portal]
                      
                  -- Teleportation
                  ritnlib.portal.teleport(LuaSurface, id, LuaPlayer)
  
                  if LuaGui then
                    local LuaEntity = LuaSurface.find_entity(ritnmods.teleport.defines.name.entity.portal, position)
                    LuaEntity.operable = true
                    LuaEntity.minable = true
                    LuaGui.destroy()
                  end
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