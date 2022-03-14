------------------------------------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.menu.action = require(ritnmods.teleport.defines.gui.menu.action)
---------------------------------------------------------------------------------------------
local events = {}
events.inventory =    require(ritnmods.teleport.defines.functions.inventory)
events.utils =        require(ritnmods.teleport.defines.functions.utils)
events.surface =      require(ritnmods.teleport.defines.functions.surface)
events.enemy =        require(ritnmods.teleport.defines.functions.enemy)


local function call_remote_functions()
    pcall(function() remote.call("freeplay", "set_created_items", {}) end) 
    pcall(function() remote.call("freeplay", "set_respawn_items", {}) end) 
    pcall(function() remote.call("freeplay", "set_skip_intro", true) end) 
    pcall(function() remote.call("freeplay", "set_disable_crashsite", true) end) 
end
  
function events.on_init(event)
  -- Call remote functions.
  call_remote_functions()
  pcall(function() remote.call("EvoGUI", "create_remote_sensor", 
    { 
      mod_name = "RitnTeleportation",
      name = "evolution_factor_ritntp", 
      text = "", 
      caption = {'sensor.evo_factor_name'}
    }
  ) end)
end
  
function events.on_load(event)
  -- Call remote functions.
  call_remote_functions()
end



--------------------------------------------
-- on_tick_local
local function on_tick_local(e)

  local setting_value = settings.global[ritnmods.teleport.defines.name.settings.clean].value
  if game.is_multiplayer() == false then return end

  if setting_value > 0 then 
    if e.tick % 3600 == 0 then -- toutes les minutes
      for i,player in pairs(game.players) do
        if global.teleport.surfaces[player.name] then
          if global.teleport.surfaces[player.name].map_used == true then
            global.teleport.surfaces[player.name].last_use = game.tick
          else

            local value = (game.tick - global.teleport.surfaces[player.name].last_use)/216000 -- tick -> heure

            if value > setting_value then 
                -- clean map 
                local surface = player.name
                if global.teleport.surfaces[surface].exception == true then return end
                events.utils.clean(surface)
                events.utils.pcallLog("Clean map by inactivity !", "on_tick_local")
                return
            end

          end
        end
      end

    end
  end

end

-- Créer une surface nauvis si on charge une partie ne comportant pas RitnTP à la base.
local function on_tick_loadGame(e) 
  if e.tick > 3600 then
    if not global.teleport.surfaces["nauvis"] then
      -- Creation de la structure de map dans les données
      events.surface.generateSurface(game.surfaces.nauvis)
      global.teleport.surfaces["nauvis"].exception = true
      global.teleport.surfaces["nauvis"].map_used = true
      for i,LuaPlayer in pairs(game.players) do
        global.teleport.surfaces["nauvis"].inventories[LuaPlayer.name] = events.inventory.init()
        events.surface.addPlayer(LuaPlayer)
      end
    end
  end
end

local function on_tick_evoGui(e)
  if game.tick % 60 ~= 0 then return end
  if global.enemy.setting == false then return end
  if global.enemy.value == false then return end

  if game.active_mods["EvoGUI"] then 

    for i,LuaPlayer in pairs(game.players) do

      if LuaPlayer.valid then 
          if LuaPlayer.gui.top["evogui_root"] ~= nil then
            local LuaGui = LuaPlayer.gui.top["evogui_root"]["sensor_flow"]["always_visible"]["remote_sensor_evolution_factor_ritntp"]

            if LuaGui then
                local LuaSurface = LuaPlayer.surface 

                if LuaSurface.name == "nauvis" or string.sub(LuaSurface.name, 1, 6) == "lobby~" then
                  -- enemy (nauvis)
                  local LuaForceEnemy = game.forces["enemy"]
                  local percent_evo_factor = LuaForceEnemy.evolution_factor * 100
                  local whole_number = math.floor(percent_evo_factor)
                  local fractional_component = math.floor((percent_evo_factor - whole_number) * 100)

                  LuaGui.caption = {"sensor.evo_factor_format", LuaForceEnemy.name, string.format("%d.%02d%%", whole_number, fractional_component)}
                else
                  -- enemy surface (ritnTP)
                  local LuaForceEnemy = game.forces["enemy~" .. LuaSurface.name]
                  local percent_evo_factor = LuaForceEnemy.evolution_factor * 100
                  local whole_number = math.floor(percent_evo_factor)
                  local fractional_component = math.floor((percent_evo_factor - whole_number) * 100)

                  LuaGui.caption = {"sensor.evo_factor_format", LuaForceEnemy.name, string.format("%d.%02d%%", whole_number, fractional_component)}
                end
            else
                local text = ""
            end
          else
            events.utils.pcallLog("no 'evogui_root'", "on_tick_evoGui")
          end
      else
        events.utils.pcallLog("no 'top'", "on_tick_evoGui")
      end
    end
    
  end
end


local function on_tick_evolution(e)
  local value = e.tick % 60

  if global.teleport ~= nil then 
    if global.map_settings then 
      if global.map_settings.pollution then 
        if global.map_settings.pollution.enabled then 
          if global.map_settings.enemy_evolution then 
            if global.map_settings.enemy_evolution.enabled then 
              if global.enemy.setting then 
                if global.enemy.value then 
                  if global.teleport.surfaces ~= nil then 
                    local LuaSurface = game.surfaces[value]
                    if LuaSurface ~= nil then 
                      if global.teleport.surfaces[LuaSurface.name] then
                        events.enemy.pollution_by_surface(LuaSurface)
                        if not global.teleport.surfaces[LuaSurface.name].current_time then 
                          global.teleport.surfaces[LuaSurface.name].current_time = 0
                          global.teleport.surfaces[LuaSurface.name].time = 0
                        end
                        global.teleport.surfaces[LuaSurface.name].last_time = global.teleport.surfaces[LuaSurface.name].current_time
                        global.teleport.surfaces[LuaSurface.name].current_time = math.floor(game.tick / 60)
                        if global.teleport.surfaces[LuaSurface.name].current_time > global.teleport.surfaces[LuaSurface.name].last_time then
                          global.teleport.surfaces[LuaSurface.name].time = global.teleport.surfaces[LuaSurface.name].time + 1
                        end
                        events.enemy.evolution_by_surface(LuaSurface)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end


-- open_close_menu
local function open_close_menu(e)
  local LuaPlayer = game.players[e.player_index]
  ritnGui.menu.action[ritnmods.teleport.defines.name.gui.menu.button_main](LuaPlayer)
end


------------------------------------------------------------------------------------------------------------------------

-- event : on_tick
script.on_event({defines.events.on_tick},function(e)
  on_tick_local(e)
  on_tick_loadGame(e) 
  on_tick_evoGui(e)
  on_tick_evolution(e)
end)

-- event : custom-input -> toggle_main_menu
script.on_event(ritnmods.teleport.defines.name.customInput.toggle_main_menu,function(e)
  open_close_menu(e)
end)
  
------------------------------------------------------------------------------------------------------------------------
-- Add commands
------------------------------------------------------------------------------------------------------------------------

-- re-Add 1.8.0
commands.add_command("clean", "<player>", 
  function (e)

    local autorize = false
    local is_player = false

    if e.player_index then 
      local LuaPlayer = game.players[e.player_index]
      if LuaPlayer.admin or LuaPlayer.name == "Ritn" then
        autorize = true
        is_player = true
      end
    else 
      autorize = true
    end
    
    if e.parameter ~= nil then
      local parametre = e.parameter

      if global.teleport.surfaces[parametre] then 
        if autorize then 
          if is_player then
            -- by player : admin
            events.utils.clean(parametre, game.players[e.player_index])
          else 
            -- by server
            events.utils.clean(parametre)
          end
        end
      end
    end

  end
)

commands.add_command("exception", "<add/remove/view> <player>", 
  function (e)
    local LuaPlayer = game.players[e.player_index]
      if LuaPlayer.admin or LuaPlayer.name == "Ritn" then
        if e.parameter ~= nil then 

          local pattern = "([^ ]*) ?([^ ]*)"
          local param = {cmd,player}
          local result
          param.cmd, param.player = string.match(e.parameter, pattern)

          if param.cmd == "add" then 
            result = events.utils.exception.add(param.player)
            if result == true then 
              LuaPlayer.print("add exception " .. param.player .. " OK !")
            else
              LuaPlayer.print("-> /exception add <player>") 
            end
          elseif param.cmd == "remove" then
            result = events.utils.exception.remove(param.player)
            if result == true then 
              LuaPlayer.print("Remove exception " .. param.player .. " OK !")
            else
              LuaPlayer.print("-> /exception remove <player> ") 
            end
          elseif param.cmd == "view" then
            events.utils.exception.view(LuaPlayer)
          end
            
        else
          LuaPlayer.print("-> /exception <add/remove/view> <player>") 
        end 
      end 
  end
)


-------------------------------------------
return events