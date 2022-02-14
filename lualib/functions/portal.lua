---
-- Fonction Portal
---
local flib = {}
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.surface =       require(ritnmods.teleport.defines.functions.surface)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.remote =            require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.teleporter =        require(ritnmods.teleport.defines.gui.teleporter.GuiElements)
---------------------------------------------------------------------------------------------

-- getDestination
local function getDestination(LuaSurface, position)
  if LuaSurface ~= nil then 
  if global.teleport.surfaces[LuaSurface.name] ~= nil then 
  if position ~= nil then 
  -------
      for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
          if portal.teleport == 1 then
            if portal.position.x == position.x and portal.position.y == position.y then
              return portal.dest
            end
          end
      end
  -------
  end
  end
  end

end

-- setDestination
local function setDestination(LuaSurface, position, strDest)
  if LuaSurface ~= nil then 
  if global.teleport.surfaces[LuaSurface.name] ~= nil then 
  if position ~= nil then 
  -------
    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
      if portal.teleport == 1 then
        if portal.position.x == position.x and portal.position.y == position.y then
          if strDest ~= nil then
            portal.dest = strDest
            return
          else
            portal.dest = ritnmods.teleport.defines.value.portal_not_link
            return
          end
        end
      end
    end
  -------
  end 
  end 
  end
end


-- getDestinationId
local function getDestinationId(LuaSurface, id)
  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then 
  if id ~= nil then
  -------
    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
      if portal.teleport == 1 then
        if portal.id == id then
          return portal.dest
        end
      end
    end
  -------
  end 
  end 
  end
end

-- setDestinationId
local function setDestinationId(LuaSurface, id, strDest)

  if LuaSurface ~= nil then 
  if global.teleport.surfaces[LuaSurface.name] ~= nil then 
  if id ~= nil then 

  -------
    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
      if portal.teleport == 1 then
        if portal.id == id then
          if strDest ~= nil then
            portal.dest = strDest
            return
          else 
            portal.dest = ritnmods.teleport.defines.value.portal_not_link
            return
          end
        end
      end
    end
  -------
  end
  end
  end
end


-- getPositionDestination
local function getPositionDestination(LuaSurface, LuaSurface_dest)

  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then 
  if LuaSurface_dest ~= nil then 
  if global.teleport.surfaces[LuaSurface_dest.name] ~= nil then 

  -------
    for i,portal in pairs(global.teleport.surfaces[LuaSurface_dest.name].portals) do
      if portal.teleport == 1 then
        if portal.dest == LuaSurface.name then
            return portal.position
        end
      end
    end
  -------
  end
  end
  end
  end
end

-- getPositionDestination
local function getPositionId(LuaSurface, id)

  if LuaSurface ~= nil then 
  if global.teleport.surfaces[LuaSurface.name] ~= nil then 
  if id ~= nil then 
  -------
    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
      if portal.teleport == 1 then
        if portal.id == id then
          return portal.position
        end
      end
    end
  -------
  end
  end
  end
end

----------------------------------------------------------------------------------

-- getId
local function getId(LuaSurface, position)

    if LuaSurface ~= nil then
    if global.teleport.surfaces[LuaSurface.name] ~= nil then
    if position ~= nil then
    
    -------
      for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
        if portal.teleport == 1 then
          if position ~= nil then
            if portal.position.x == position.x and portal.position.y == position.y then
              return portal.id
            end
          end
        end
      end
    -------
    end
    end
    end

    return
end

----------------------------------------------------------------------------------

-- getRenderId
local function getRenderId(LuaSurface, position)

  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then
  if position ~= nil then
    
    -------
    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
      if portal.teleport == 1 then
        if portal.position.x == position.x and portal.position.y == position.y then
          if portal.render_id then
            return portal.render_id
          else return -1 end
        end
      end
    end
  -------
  else return -1 end
  else return -1 end
  else return -1 end
end

-- setRenderId
local function setRenderId(LuaSurface, position, renderId)
  local result = -1

  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then
  if position ~= nil then
  -------
    if renderId ~= nil then result = renderId end

    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
      if portal.teleport == 1 then
        if portal.position.x == position.x and portal.position.y == position.y then
            portal.render_id = result
            return
        end
      end
    end
  -------
  end
  end
  end

end

----------------------------------------------------------------------------------

-- getIdValue
local function getIdValue(LuaSurface)
  if LuaSurface ~= nil then
    if global.teleport.surfaces[LuaSurface.name] then
      return global.teleport.surfaces[LuaSurface.name].value.id_portal
    else return -1 end
  else return -1 end
end

-- setIdValue
local function setIdValue(LuaSurface, value)
  if LuaSurface ~= nil then
    if global.teleport.surfaces[LuaSurface.name] ~= nil then
      if value ~= nil then
        global.teleport.surfaces[LuaSurface.name].value.id_portal = value
      end
    end
  end
end

----------------------------------------------------------------------------------

-- getPortalValue
local function getValue(LuaSurface)
  if LuaSurface ~= nil then
    if global.teleport.surfaces[LuaSurface.name] then
      return global.teleport.surfaces[LuaSurface.name].value.portal
    else return -1 end
  else return -1 end
end

-- setPortalValue
local function setValue(LuaSurface, value)
  if LuaSurface ~= nil then
    if global.teleport.surfaces[LuaSurface.name] ~= nil then
      if value ~= nil then
        global.teleport.surfaces[LuaSurface.name].value.portal = value
      end
    end
  end
end

----------------------------------------------------------------------------------


local function new(id, position, dest, render_id, teleport)
  local portal = {
    id = id,
    position = position,
    dest = dest,
    render_id = render_id,
    teleport = teleport,
  }
  return portal
end



-- Suppression de la structure "portal" dans global.teleport.surfaces[surface.name].portals
local function delete(LuaSurface_origine, TabPosition_origine, LuaSurface_destination, TabPosition_destination)
  local id = getId(LuaSurface_origine, TabPosition_origine)
        
  for i,portal in pairs(global.teleport.surfaces[LuaSurface_origine.name].portals) do
      if portal.id == id then
        global.teleport.surfaces[LuaSurface_origine.name].portals[i] = nil
      end
  end      
  setValue(LuaSurface_origine, getValue(LuaSurface_origine) - 1)

  -- Suppression du lien pour le portail destinataire
  if LuaSurface_destination ~= nil and TabPosition_destination ~= nil then
    id = getId(LuaSurface_destination, TabPosition_destination)
    setDestinationId(LuaSurface_destination, id, ritnmods.teleport.defines.value.portal_not_link)
  end
end





----------------------------------------------------------------------------------

-- Téléportation entre portail
local function teleport(LuaSurface, id, LuaPlayer, instantTP)
  
  if not id then return end
  if LuaSurface == nil then return end
  if LuaPlayer.driving then return end
  -- No characters
  if LuaPlayer.character == nil then return end
  
  -- Via commande ADMIN (pas d'attente)
  local instant = false
  if instantTP ~= nil then instant = instantTP end

  -- temporisation après un TP
  if global.teleport.surfaces[LuaSurface.name] then 
    if global.teleport.surfaces[LuaSurface.name].players then 
      if global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name] then 
        if instant == false then
          if global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name].tp == true then 
            ritnlib.utils.pcallLog(">> (" .. LuaPlayer.name .. ") : portal teleport - waiting tp ...", nil, true)
            return 
          end
        end
      end
    end
  end
  ------
  local details = {
    lib = "functions",
    category = "portal",
    funct = "teleport",
    state = "before : getDestinationId()",
    surface = LuaSurface.name,
    id = id,
  }
  ritnlib.utils.pcallLog(details, nil, true)
  ------
  -- Récupère la surface de destination
  local surfaceDest_name = getDestinationId(LuaSurface, id)
  ------
  details.destination = surfaceDest_name
  details.state = "after : getDestinationId()"
  ritnlib.utils.pcallLog(details, nil, true)

  details = {
    lib = "functions",
    category = "portal",
    funct = "teleport",
  }
  ------
  
  --if surfaceDest_name ~= nil then return end
  local LuaSurface_dest = game.surfaces[surfaceDest_name]

  if LuaSurface_dest ~= nil then
      if global.teleport.surfaces[LuaSurface_dest.name] then
        if getValue(LuaSurface_dest) ~= 0 then
          
          -- Recuperation du portail de destination (position et ID)
          local portal_position = nil

          -- recuperation de la position du portail destination
          for id, portal in pairs(global.teleport.surfaces[LuaSurface_dest.name].portals) do
              if portal.dest == LuaSurface.name then
                portal_position = portal.position
              end
          end

          if portal_position == nil then
            LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.dest_not_find)
              return
          end

          -- Recuperation de l'ID du portail destination
          local id_portal = getId(LuaSurface_dest, portal_position)

          if id_portal == nil then
            LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.dest_not_find)
          else

              local origine = global.teleport.players[LuaPlayer.name].origine

              -- Verification que les personnes sont autorisés à passé le portail
              if origine == LuaSurface.name or origine == LuaSurface_dest.name then
                
                -- fermeture de la page Namer Teleporter
                local guiTeleport = LuaPlayer.gui.screen[ritnmods.teleport.defines.name.gui.NamerMain]
                if guiTeleport ~= nil then 
                  local prefix = ritnmods.teleport.defines.name.gui.prefix.teleporter
                  local info = guiTeleport[prefix .. ritnmods.teleport.defines.name.gui.Infos].caption
                  local position = ritnlib.utils.split(info, " ")
                  ritnGui.teleporter.close(LuaSurface, LuaPlayer, position)
                end
                -- fermeture de la fenetre des teleporteurs
                ritnGui.remote.close(LuaPlayer)
                  ritnlib.utils.pcallLog(">> " .. origine .." -> " .. LuaSurface_dest.name, nil, true)

                  -- 1.6.1 ----
                  local statut, errorMsg = pcall(function() 
                    if not global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] then
                      global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] = ritnlib.inventory.init()
                    end
                  end)
                  if statut then 
                  else
                    log(">> [RITNTP] ERROR = " .. errorMsg)
                  end
                  -------------
                  ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])
                  
                  -- gestion d'un decalage au moment du teleport pour eviter la colision des joueurs
                  local decalage = ritnlib.utils.positionTP(LuaPlayer, 1.0)
                  -- teleportation                  
                  if origine == LuaSurface_dest.name then
                    LuaPlayer.teleport({portal_position.x+decalage, portal_position.y+decalage},LuaSurface_dest)
                    details.state = "teleport ok"
                    ritnlib.utils.pcallLog(details, nil, true)
                  else
                    LuaPlayer.teleport({portal_position.x-decalage, portal_position.y+decalage},LuaSurface_dest)
                    details.state = "teleport ok"
                    ritnlib.utils.pcallLog(details, nil, true)
                  end
              else
                LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_access)
                details.state = "no tp : no access"
                ritnlib.utils.pcallLog(details, nil, true)
              end
          end
        else
          LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.dest_not_find)
          details.state = "no tp : no destination"
          ritnlib.utils.pcallLog(details, nil, true)
          return
        end
      end
      
  else
    -- Aucune destination lié
    LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.not_link)
    if Luasurface_dest ~= ritnmods.teleport.defines.value.portal_not_link then 
      setDestinationId(LuaSurface, id, ritnmods.teleport.defines.value.portal_not_link)

      local renderId = getRenderId(LuaSurface, getPositionId(LuaSurface, id))
      if renderId ~= -1 then 
        rendering.set_text(renderId, ritnmods.teleport.defines.value.portal_not_link) -- Change text
          details.state = "rendering : portal not link"
          ritnlib.utils.pcallLog(details, nil, true)
      end
      
    end
  end
  
end


-- Insert un portail dans l'inventaire du joueur (supprime la structure portal)
local function insertPortal(LuaPlayer, LuaSurface_origine, TabPosition_origine, LuaSurface_destination, TabPosition_destination)
  if LuaPlayer.name == LuaPlayer.surface.name then
    if LuaPlayer.connected then
      -- insert portail dans l'inventaire s'il est connecté
      LuaPlayer.insert({name = ritnmods.teleport.defines.name.item.portal, count = 1})
    else
      -- insert dans l'inventaire sauvegardé s'il n'est pas connecté
      global.teleport.surfaces[LuaSurface_origine.name].inventories[LuaPlayer.name][defines.inventory.character_main].insert({name = ritnmods.teleport.defines.name.item.portal, count = 1})
    end
  end
  -- Suppression de la structure "portal" dans global.teleport.surfaces[surface.name].portals
  delete(LuaSurface_origine, TabPosition_origine, LuaSurface_destination, TabPosition_destination)
  
  local details = {
    lib = "functions",
    category = "portal",
    funct = "insertPortal",
  }
  details.state = "ok"
  ritnlib.utils.pcallLog(details, nil, true)
end


-- replace le portail en lieu et place
local function replacePortal(LuaSurface_origine, LuaEntity_position, LuaPlayer_name, LuaSurface_destination)
    local LuaEntity1 = ritnlib.surface.create_portal(LuaSurface_origine, LuaEntity_position, LuaPlayer_name) 
    local renderId = rendering.draw_text{
        text=getDestination(LuaSurface_origine, LuaEntity1.position),
        surface=LuaSurface_origine,
        target=LuaEntity1,
        alignment = "center",
        target_offset={0, -2.0},
        color = {r = 0.217, g = 0.715, b = 0.874, a = 1},
        scale_with_zoom = true,
        scale = 1.5
    }
    
    local details = {
      lib = "functions",
      category = "portal",
      funct = "replacePortal",
    }
    details.state = "ok"
    ritnlib.utils.pcallLog(details, nil, true)

    return renderId
end


-- Teleportation à la map d'origine des joueurs s'il ne sont pas chez eux
local function returnHome(LuaSurfaceNoHome, LuaSurfaceHome, tabPositionHome, id)
  for _,LuaPlayer in pairs(game.players) do
    if global.teleport.players[LuaPlayer.name] then -- fix bug ness056
      if global.teleport.players[LuaPlayer.name].origine == LuaSurfaceHome.name then
        if LuaPlayer.surface.name == LuaSurfaceNoHome.name then         
          ----
          local details = {
            lib = "functions",
            category = "portal",
            funct = "returnHome",
            player = LuaPlayer.name
          }
          ----
          if tabPositionHome ~= nil or id~=nil then 
            -- fix 2.0.23
            if LuaPlayer.driving then 
              -- on fait sortir le joueur du vehicule
              LuaPlayer.driving = false
            end
            teleport(LuaSurfaceNoHome, id, LuaPlayer, true) -- recupère la position à TP depuis la map où le portail enlevé.
            ritnlib.utils.pcallLog(details, nil, true)
          else
            ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[LuaSurfaceNoHome.name].inventories[LuaPlayer.name])
            local posTP = ritnlib.utils.positionTP(LuaPlayer)
            LuaPlayer.teleport({posTP,posTP}, LuaSurfaceHome.name)
            
            details.destination = LuaSurfaceHome.name
            ritnlib.utils.pcallLog(details, nil, true)
          end
        end
      end
    end
  end

end




----------------------------

local function listLink(surface_name)
  local list = {}
  for _,surfaces in pairs(global.teleport.surfaces) do 
    if surfaces.portals then 
      for _,portal in pairs(surfaces.portals) do 
        if portal.dest == surface_name then 
          table.insert(list, surfaces.name)
        end
      end
    end   
  end
  return list
end


----------------------------
-- Chargement des fonctions
flib.new = new
flib.delete = delete
flib.teleport = teleport
flib.getDestination = getDestination
flib.setDestination = setDestination
flib.getDestinationId = getDestinationId
flib.setDestinationId = setDestinationId
flib.getPositionDestination = getPositionDestination
flib.getPositionId = getPositionId
flib.getId = getId
flib.getRenderId = getRenderId
flib.setRenderId = setRenderId
flib.getIdValue = getIdValue
flib.setIdValue = setIdValue
flib.getValue = getValue
flib.setValue = setValue
flib.listLink = listLink
flib.insertPortal = insertPortal
flib.replacePortal = replacePortal
flib.returnHome = returnHome

-- Retourne la liste des fonctions
return flib