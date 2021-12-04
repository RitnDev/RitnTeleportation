---
-- Fonction "player"
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.lobby =       require(ritnmods.teleport.defines.gui.lobby.GuiElements)
ritnGui.request =     require(ritnmods.teleport.defines.gui.request.GuiElements)
---------------------------------------------------------------------------------------------



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
  end

  -- modif 2.0
  --[[
  if game.is_multiplayer() then
    if global.teleport.surfaces[LuaPlayer.name] then
      LuaPlayer.insert{name = ritnmods.teleport.defines.name.item.portal, count = 1}
    end
  end
  ]]
  
  if game.active_mods["Updated_Construction_Drones"] then 
    LuaPlayer.get_main_inventory().insert{name="Construction Drone",count=10}
  end

end

--le joueur est mort ?
local function is_died(LuaPlayer)
  for _,player in pairs(global.teleport.player_died) do 
    if player == LuaPlayer.name then return true end
  end
  return false
end

-- creation de la requete
local function createRequest(LuaPlayer, request)
  if global.teleport.surfaces[request] then 
    if not global.teleport.surfaces[request].requests[LuaPlayer.name] then   
      global.teleport.surfaces[request].requests[LuaPlayer.name] = {
        name = LuaPlayer.name,
        state = 1,
        reject_all=false
      }
      if not global.teleport.requests[LuaPlayer.name] then global.teleport.requests[LuaPlayer.name] = {} end
      global.teleport.requests[LuaPlayer.name][request] = {name = request}
            
      LuaPlayer.print({"msg.send-request", request}, {r = 1, g = 0, b = 0, a = 0.3})

      local PlayerRequest = game.players[request]
      -- créer la fenetre "gui_request" à l'utilisateur ciblé
      ritnGui.request.open(PlayerRequest, global.teleport.surfaces[request].requests[LuaPlayer.name])
    end
  end
end

-- accepter une demande en cours OU supprimer l'effet du rejectAll
local function acceptRequest(LuaPlayer, reponse)
  local playerSend = reponse.name
  
  if global.teleport.surfaces[LuaPlayer.name] then 
    if global.teleport.surfaces[LuaPlayer.name].requests[playerSend] then
      if global.teleport.surfaces[LuaPlayer.name].requests[playerSend].state == 1 then           
        if not global.teleport.requests[playerSend] then 
          -- une requete a déjà été accepté ailleurs
            LuaPlayer.print({"msg.timeout-request"})
            -- suppression de la request
            global.teleport.surfaces[LuaPlayer.name].requests[playerSend] = nil
            return 
        else
          if global.teleport.requests[playerSend][LuaPlayer.name] then
            
            local LuaSurface = game.surfaces[LuaPlayer.name]

            global.teleport.surfaces[LuaSurface.name].inventories[playerSend] = ritnlib.inventory.init()
            table.insert(global.teleport.surfaces[LuaSurface.name].origine, playerSend)

            -- Enregistrement de la surface d'origine
            if not global.teleport.players[playerSend] then 
              global.teleport.players[playerSend] = {origine = LuaSurface.name}
            end
            local origine = global.teleport.players[playerSend].origine

            -- Teleportation sur la surface du personnage.
            LuaPlayer = game.players[playerSend]
            ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[origine].inventories[LuaPlayer.name])
            
            if LuaPlayer.connected and LuaPlayer.valid then
              -- gestion d'un decalage au moment du teleport pour eviter la colision des joueurs
              local decalage = ritnlib.utils.positionTP(LuaPlayer)
              LuaPlayer.teleport({decalage,decalage}, origine)
              LuaPlayer.character.active = true
            end
            
            -- Arrive sans rien
            LuaPlayer.clear_items_inside()
            
            -- suppression de la request
            global.teleport.surfaces[LuaSurface.name].requests[playerSend] = nil
            global.teleport.requests[playerSend] = nil

            -- fermeture de la fenetre après la création de la map
            ritnGui.lobby.close(LuaPlayer)
          end
        end
      elseif global.teleport.surfaces[LuaPlayer.name].requests[playerSend].state == 0 then
          global.teleport.surfaces[LuaPlayer.name].requests[playerSend] = nil
      end
    end
  end
end

-- rejeter une demande en cours
local function rejectRequest(LuaPlayer, reponse)
  local playerSend = reponse.name

  if not global.teleport.requests[playerSend] then 
    LuaPlayer.print({"msg.timeout-request"})
    -- suppression de la request
    global.teleport.surfaces[LuaPlayer.name].requests[playerSend] = nil
    return 
  end

  if global.teleport.requests[playerSend][LuaPlayer.name] then
    if global.teleport.surfaces[LuaPlayer.name] then 
      if global.teleport.surfaces[LuaPlayer.name].requests[playerSend] then
        if global.teleport.surfaces[LuaPlayer.name].requests[playerSend].state == 1 then 
          -- suppression de la request
          global.teleport.surfaces[LuaPlayer.name].requests[playerSend] = nil
          global.teleport.requests[playerSend][LuaPlayer.name] = nil
          -- envoie un message comme quoi la demande a été refusé !
          if game.players[playerSend].valid and game.players[playerSend].connected then
            game.players[playerSend].print({"msg.reject-request", LuaPlayer.name})
          end
        end
      end
    end
  end
end

-- Rejeter toute demande de ce joueur
local function rejectAllRequest(LuaPlayer, reponse)
  local playerSend = reponse.name

  if not global.teleport.requests[playerSend] then 
    LuaPlayer.print({"msg.timeout-request"})
    -- suppression de la request
    global.teleport.surfaces[LuaPlayer.name].requests[playerSend] = nil
    return 
  end

  if global.teleport.requests[playerSend][LuaPlayer.name] then
    if global.teleport.surfaces[LuaPlayer.name] then 
      if global.teleport.surfaces[LuaPlayer.name].requests[playerSend] then
        if global.teleport.surfaces[LuaPlayer.name].requests[playerSend].state == 1 then 
          -- suppression de la request
          global.teleport.surfaces[LuaPlayer.name].requests[playerSend].state = 0
          global.teleport.surfaces[LuaPlayer.name].requests[playerSend].reject_all=true
          global.teleport.requests[playerSend][LuaPlayer.name] = nil
          -- envoie un message comme quoi la demande a été refusé !
          if game.players[playerSend].valid and game.players[playerSend].connected then
            game.players[playerSend].print({"msg.reject-request", LuaPlayer.name})
          end
        end
      end
    end
  end
end




----------------------------
-- Chargement des fonctions
local flib = {}
flib.give_start_item = give_start_item
flib.is_died = is_died
flib.createRequest = createRequest
flib.acceptRequest = acceptRequest
flib.rejectRequest = rejectRequest
flib.rejectAllRequest = rejectAllRequest

-- Retourne la liste des fonctions
return flib