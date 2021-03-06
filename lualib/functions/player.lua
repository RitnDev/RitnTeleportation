---
-- Fonction "player"
---

-- give des items
local function give_start_item(LuaPlayer, vanilla)
  if vanilla == (0 or nil) then
    LuaPlayer.insert{name = "iron-ore", count = 11}
    LuaPlayer.insert{name = "wood", count = 3}
    LuaPlayer.insert{name = "stone", count = 10}
    LuaPlayer.insert{name = "iron-gear-wheel", count = 3}
  elseif vanilla == 1 then 
    LuaPlayer.insert{name = "iron-plate", count = 8}
    LuaPlayer.insert{name = "wood", count = 1}
    LuaPlayer.insert{name = "stone-furnace", count = 1}
    LuaPlayer.insert{name = "burner-mining-drill", count = 1}
  elseif vanilla == 2 then --spaceblock
    LuaPlayer.get_main_inventory().insert{name="assembling-machine-2",count=1}
    LuaPlayer.get_main_inventory().insert{name="assembling-machine-1",count=4}
    LuaPlayer.get_main_inventory().insert{name="chemical-plant",count=2}
    LuaPlayer.get_main_inventory().insert{name="solar-panel",count=20}
    LuaPlayer.get_main_inventory().insert{name="small-electric-pole",count=5}
    LuaPlayer.get_main_inventory().insert{name="landfill",count=800}
    LuaPlayer.get_main_inventory().insert{name="spaceblock-water",count=50}
    LuaPlayer.get_main_inventory().insert{name="offshore-pump",count=1}
    LuaPlayer.get_main_inventory().insert{name="accumulator",count=10}
  elseif vanilla == 3 then --seablock
    LuaPlayer.insert{name = "iron-plate", count = 8}
    LuaPlayer.insert{name = "stone-furnace", count = 1}
  else
    LuaPlayer.insert{name = ritnmods.teleport.defines.name.item.portal, count = 1}
  end
  LuaPlayer.insert{name = ritnmods.teleport.defines.name.item.portal, count = 1}

end

--le joueur est mort ?
local function is_died(LuaPlayer)
  for _,player in pairs(global.teleport.player_died) do 
    if player == LuaPlayer.name then return true end
  end
  return false
end

----------------------------
-- Chargement des fonctions
local flib = {}
flib.give_start_item = give_start_item
flib.is_died = is_died

-- Retourne la liste des fonctions
return flib