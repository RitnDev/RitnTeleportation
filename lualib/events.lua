------------------------------------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.menu =        require(ritnmods.teleport.defines.gui.menu.GuiElements)
ritnGui.menu.action = require(ritnmods.teleport.defines.gui.menu.action)
---------------------------------------------------------------------------------------------
local events = {}
events.lib =    require(ritnmods.teleport.defines.functions.inventory)
events.utils =  require(ritnmods.teleport.defines.functions.utils)


local function call_remote_functions()
    pcall(function() remote.call("freeplay", "set_created_items", {}) end) 
    pcall(function() remote.call("freeplay", "set_respawn_items", {}) end) 
    pcall(function() remote.call("freeplay", "set_skip_intro", true) end) 
    pcall(function() remote.call("freeplay", "set_disable_crashsite", true) end) 
end
  
function events.on_init(event)
  -- Call remote functions.
  call_remote_functions()
end
  
function events.on_load(event)
  -- Call remote functions.
  call_remote_functions()
end



--------------------------------------------
-- on_tick_local
local function on_tick_local(e)

  local setting_value = settings.global[ritnmods.teleport.defines.name.settings.clean].value
  if game.is_multiplayer == false then return end

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
                return
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