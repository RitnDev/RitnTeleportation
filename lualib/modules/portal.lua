-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.player =      require(ritnmods.teleport.defines.functions.player)
ritnlib.portal =      require(ritnmods.teleport.defines.functions.portal)
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
ritnlib.surface =     require(ritnmods.teleport.defines.functions.surface)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local module = {}
module.events = {}


-- Mise en place de l'entité portail sur le terrain
local function portal_place(e)
    local LuaEntity = e.created_entity
    local LuaPlayer = game.players[e.player_index]

    
    if not LuaEntity then return end
    if not LuaEntity.valid then return end
    if not LuaPlayer then return end
  
    local surface = LuaEntity.surface
    if surface.name ~= LuaPlayer.name then return end
    -- No characters
    if LuaPlayer.character == nil then return end
    if LuaEntity.name ~= ritnmods.teleport.defines.name.entity.portal then return end

    
    if LuaPlayer.name ~= nil then 
      print(">> " .. LuaPlayer.name .." -> place portal")
    end
    
    if LuaEntity.name == ritnmods.teleport.defines.name.entity.portal then
      if LuaPlayer.name == surface.name then

        local renderId = rendering.draw_text{
          text=ritnmods.teleport.defines.value.portal_not_link,
          surface=surface,
          target=LuaEntity,
          alignment = "center",
          target_offset={0, -2.0},
          color = {r = 0.217, g = 0.715, b = 0.874, a = 1},
          scale_with_zoom = true,
          scale = 1.5
        }

        ritnlib.portal.setIdValue(surface,ritnlib.portal.getIdValue(surface) + 1) -- id_value + 1
        
        local id = ritnlib.portal.getIdValue(surface)
        local table_prep = ritnlib.portal.new(id, LuaEntity.position, ritnmods.teleport.defines.value.portal_not_link, renderId, 1)
  
        table.insert(global.teleport.surfaces[surface.name].portals , table_prep)
        ritnlib.portal.setValue(surface, ritnlib.portal.getValue(surface) + 1) -- value + 1

        
      else
        LuaPlayer.insert{name = ritnmods.teleport.defines.name.item.portal, count = 1}
        LuaEntity.destroy()
      end
    end
  
end
  


--  ######################################## --
--  Quand on enlève le portail sur le terrain --
--  ######################################## --
--  # @origine = lié à l'entité et de la   # --
--  #            surface d'où l'event est  # --
--  #            originaire.               # --
--  #                                      # --
--  # @destination = là où le portail est  # --
--  #                censé ce rendre.      # --
--  ######################################## --
local function portal_breaks(e)
--[[
  Contains:
  player_index :: uint: The index of the player doing the mining.
  entity :: LuaEntity: The entity that has been mined.
  buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity. 
]]

    local isDestination = false

    local LuaEntity = {}
    local LuaSurface = {
      origine, -- LuaSurface (Ritn)
      destination, -- LuaSurface (jeu)
    }

    LuaEntity.origine = e.entity
    LuaSurface.origine = LuaEntity.origine.surface

    -- Vérifie que l'entité est bien un portail
    if LuaEntity.origine.name == ritnmods.teleport.defines.name.entity.portal then   
        local LuaPlayer = {}
        local TabPosition = {}

        -- Suppression du portail dans l'inventaire "buffer"
        e.buffer.clear()

        --Qui a miné le portail ?
        LuaPlayer.mined = game.players[e.player_index]
        print(">> " .. LuaPlayer.mined.name .." -> mine portal") 

        -- Position du portail enlevé
        TabPosition.origine = LuaEntity.origine.position
        LuaSurface.destination = game.surfaces[ritnlib.portal.getDestination(LuaSurface.origine, TabPosition.origine)] 
        

        -- Si le portail a une destination
        -- Mise à true de l'info : isDestination
        if LuaSurface.destination ~= nil then 
            isDestination = true
            ritnlib.utils.ritnLog(">> (debug) - break portal - surface destination : " .. LuaSurface.destination.name)
        else
          ritnlib.utils.ritnLog(">> (debug) - break portal - no surface destination")
        end
        
        -- Récupération des Joueurs concernés (propriétaire des surfaces)
        for i,player in pairs(game.players) do     
            if player.name == LuaSurface.origine.name then
              LuaPlayer.origine = player -- Joueur createur origine du portail
              ritnlib.utils.ritnLog(">> (debug) - break portal - player origine : " .. LuaPlayer.origine.name)
            end
            if isDestination == true then
                if player.name == LuaSurface.destination.name then 
                  LuaPlayer.destination = player -- Joueur destinataire lié à ce portail
                  ritnlib.utils.ritnLog(">> (debug) - break portal - player destination : " .. LuaPlayer.destination.name)
                end
            end
        end

        -- Si le portail n'a aucune destination on ajoute 1 portail dans l'inventaire
        -- Le joueur a juste enlevé le portail non lié
        if isDestination == false then 
          ritnlib.portal.insertPortal(LuaPlayer.origine, LuaSurface.origine, TabPosition.origine)
          ritnlib.utils.ritnLog(">> (debug) - break portal - delete portal - no destination")
          return
        end

        -- Récupère les coordonées du portail destination lié à la surface d'origine.
        TabPosition.destination = ritnlib.portal.getPositionDestination(LuaSurface.origine, LuaSurface.destination)

        -- Si le portail a été miné mais ni par le joueur d'origine ni de destination
        if LuaPlayer.mined.name ~= LuaPlayer.origine.name then
            if LuaPlayer.mined.name ~= LuaPlayer.destination.name then 
              -- On repose le portail au meme endroit (donne une impression qu'il ne s'est rien passé)   
              ritnlib.portal.replacePortal(LuaSurface.origine, LuaEntity.origine.position, LuaPlayer.origine.name, LuaSurface.destination.name)
              ritnlib.utils.ritnLog(">> (debug) - break portal - rebuild portal")
            return
          end 
        end


        -- Si le joueur n'est pas mort
        if ritnlib.player.is_died(LuaPlayer.destination) == false then

          -- On téléporte les joueurs d'origine s'ils ne sont pas chez eux
          ritnlib.utils.ritnLog(">> (debug) - break portal - tpHome1 : " .. LuaSurface.origine.name .. " - " .. LuaSurface.destination.name)
          local id = ritnlib.portal.getId(LuaSurface.origine, TabPosition.origine)
          ritnlib.portal.returnHome(LuaSurface.origine, LuaSurface.destination, TabPosition.destination, id)

          -- On téléporte les joueurs venant de la destination s'il ne sont pas chez eux
          ritnlib.utils.ritnLog(">> (debug) - break portal - tpHome1 : " .. LuaSurface.destination.name .. " - " .. LuaSurface.origine.name)
          id = ritnlib.portal.getId(LuaSurface.destination, TabPosition.destination)
          ritnlib.portal.returnHome(LuaSurface.destination, LuaSurface.origine, TabPosition.origine, id)

          -- insert portal
          ritnlib.portal.insertPortal(LuaPlayer.origine,LuaSurface.origine, TabPosition.origine, LuaSurface.destination, TabPosition.destination)

        else --Si le joueur est mort
          -- On repose le portail au meme endroit (donne une impression qu'il ne s'est rien passé)
          LuaPlayer.origine.print({"frame.is-died", LuaPlayer.destination.name})
          ritnlib.portal.replacePortal(LuaSurface.origine, LuaEntity.origine.position, LuaPlayer.origine.name, LuaSurface.destination.name)
          ritnlib.utils.ritnLog(">> (debug) - break portal - player dead")
        end
    end

end


-- Quand un portail a été détruit
local function portal_died(e)
  local LuaEntity = e.entity

  if LuaEntity.name == ritnmods.teleport.defines.name.entity.portal then  

    local LuaSurface = LuaEntity.surface
    local LuaPlayer = LuaEntity.last_user
    local position = LuaEntity.position
    
    local renderId = ritnlib.portal.replacePortal(LuaSurface, position, LuaPlayer.name, LuaSurface.name)
    ritnlib.portal.setRenderId(LuaSurface, position, renderId)
  end

end




local function on_player_cursor_stack_changed(e) 
  local LuaPlayer = game.players[e.player_index]
  ritnlib.inventory.clearCursor(LuaPlayer, ritnmods.teleport.defines.name.item.portal)
end


------------------------------------------------------------------------------------------------------------------------
-- Add commands
------------------------------------------------------------------------------------------------------------------------

commands.add_command("link", "", 
  function (e)
    local LuaPlayer = game.players[e.player_index]
    local list = ritnlib.portal.listLink(LuaPlayer.name)
    if #list > 0 then 
      LuaPlayer.print({"msg.cmd-link"})
      for i = 1, #list do 
        LuaPlayer.print(list[i])
      end
    else 
      LuaPlayer.print({"msg.dest-not-find"}, {r=1,g=0,b=0,a=1})
    end
  end
)


----------------------------------------------------------------------------
-- portal
module.events[defines.events.on_entity_died] = portal_died
module.events[defines.events.on_player_mined_entity] = portal_breaks
module.events[defines.events.on_built_entity] = portal_place
-- Autres events
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed

return module
