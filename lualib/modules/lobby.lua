---
-- Module "lobby"
---
local ritnlib = {}
ritnlib.inventory = require(ritnmods.teleport.defines.functions.inventory)
ritnlib.utils =     require(ritnmods.teleport.defines.functions.utils)
---
local prefix_lobby = ritnmods.teleport.defines.prefix.lobby


local function on_chunk_generated(e)
    local LuaSurface=e.surface
    local area=e.area
    local tv={}
    local tab_tiles={}
    local tx
    local base_tile=1

    -- seulement si la map commence par : "lobby~"
    if string.sub(LuaSurface.name,1,6) == prefix_lobby then 
  
        for x = area.left_top.x, area.right_bottom.x do 
            for y= area.left_top.y, area.right_bottom.y do
                if((x>-2 and x<1) and (y>-2 and y<1))then
                    tx=tx or {} table.insert(tx,{name="refined-concrete",position={x,y}})
                else
                    local tile="out-of-map"
                    table.insert(tab_tiles, {name=tile,position={x,y}}) tv[x]=tv[x] or {} tv[x][y]=true
                end
            end
        end
    
        LuaSurface.destroy_decoratives{area=area}
        if(tx)then LuaSurface.set_tiles(tx) end
        LuaSurface.set_tiles(tab_tiles)
        for k,v in pairs(LuaSurface.find_entities_filtered{type="character",invert=true,area=area})do v.destroy{raise_destroy=true} end
    end
end




------------------------------------------------------------------------------------------------------------------------
-- Add commands
------------------------------------------------------------------------------------------------------------------------

local function exclusion(playerExclure, surface)
    if playerExclure == surface then return end
    for i,player in pairs(global.teleport.surfaces[surface].origine) do 
        if player == playerExclure then 
            -- sauvegarde de l'inventaire avant exclusion
            ritnlib.inventory.save(game.players[playerExclure], global.teleport.surfaces[surface].inventories[playerExclure])
            -- suppression du joueur dans origine de la map
            table.remove(global.teleport.surfaces[surface].origine, i)
            global.teleport.players[playerExclure] = nil

            if game.players[playerExclure] 
            and game.players[playerExclure].valid 
            and game.players[playerExclure].connected then   
                -- retour lobby
                game.players[playerExclure].teleport({0,0}, "lobby~" .. playerExclure)
                game.players[playerExclure].clear_items_inside()
            end
            print("Exclusion/Quit : " .. playerExclure .. " - surface : " .. surface .. " OK !")
            log("Exclusion/Quit : " .. playerExclure .. " - surface : " .. surface .. " OK !")
        end
    end
end




-- Pour admin seulement : exclure un joueur de sa map.
commands.add_command("exclure", "/exclure <player>", 
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
        local playerExclure = e.parameter

        if game.players[playerExclure] then
            if autorize then 
                if global.teleport.players[playerExclure] then 
                    local surface = global.teleport.players[playerExclure].origine
                    exclusion(playerExclure, surface)
                    if is_player then 
                        if LuaPlayer then 
                            LuaPlayer.print("Exclusion/Quit : " .. playerExclure .. " - surface : " .. surface .. " OK !")
                        end
                    end
                end
            end
        end
    end
  end
)


-- Quitter par soit même la map.
commands.add_command("quit", "/quit", 
    function (e)
        local LuaPlayer = game.players[e.player_index]
        if LuaPlayer then 
            local playerExclure = LuaPlayer.name
            if global.teleport.players[playerExclure] then 
                local surface = global.teleport.players[playerExclure].origine
                exclusion(playerExclure, surface)
            end
        end
    end
)


-- Pour admin seulement : exclure un joueur de sa map.
commands.add_command("surfaces", "", 
function (e)

    local LuaPlayer = {}
    local autorize = false
    local is_player = false

    if e.player_index then 
      LuaPlayer = game.players[e.player_index]
      if LuaPlayer.admin or LuaPlayer.name == "Ritn" then
        autorize = true
        is_player = true
      end
    else 
      autorize = true
    end
    
    if autorize then 
        if is_player then
          -- by player : admin
          for _,surface in pairs(global.teleport.surfaces) do 
            LuaPlayer.print(surface.name)
          end
        else 
          -- by server
          for _,surface in pairs(global.teleport.surfaces) do 
            print(surface.name)
          end
        end
      end
  end
)









----------------------
local module = {}
module.events = {}
----------------------
module.events[defines.events.on_chunk_generated] = on_chunk_generated
----------------------
return module