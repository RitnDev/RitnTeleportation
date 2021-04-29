---
-- Fonction Portal
---
local flib = {}
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.remote =            require(ritnmods.teleport.defines.gui.remote.GuiElements)
ritnGui.teleporter =        require(ritnmods.teleport.defines.gui.teleporter.GuiElements)
---------------------------------------------------------------------------------------------

-- getDestination
local function getDestination(LuaSurface, position)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.position.x == position.x and portal.position.y == position.y then
          return portal.dest
      end
    end
  end
end

-- setDestination
local function setDestination(LuaSurface, position, strDest)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.position.x == position.x and portal.position.y == position.y then
          portal.dest = strDest
      end
    end
  end
end

-- getDestinationId
local function getDestinationId(LuaSurface, id)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.id == id then
          return portal.dest
      end
    end
  end
end

-- setDestinationId
local function setDestinationId(LuaSurface, id, strDest)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.id == id then
          portal.dest = strDest
      end
    end
  end
end


-- getPositionDestination
local function getPositionDestination(LuaSurface, LuaSurface_dest)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface_dest.name].portals) do
    if portal.teleport == 1 then
      if portal.dest == LuaSurface.name then
          return portal.position
      end
    end
  end
end

-- getPositionDestination
local function getPositionId(LuaSurface, id)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.id == id then
          return portal.position
      end
    end
  end
end

----------------------------------------------------------------------------------

-- getId
local function getId(LuaSurface, position)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.position.x == position.x and portal.position.y == position.y then
        return portal.id
      end
    end
  end
end

----------------------------------------------------------------------------------

-- getRenderId
local function getRenderId(LuaSurface, position)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.position.x == position.x and portal.position.y == position.y then
        if portal.render_id then
          return portal.render_id
        else
          return -1
        end
      end
    end
  end
end

-- setRenderId
local function setRenderId(LuaSurface, position, renderId)
  for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].portals) do
    if portal.teleport == 1 then
      if portal.position.x == position.x and portal.position.y == position.y then
          portal.render_id = renderId
      end
    end
  end
end

----------------------------------------------------------------------------------

-- getIdValue
local function getIdValue(LuaSurface)
  return global.teleport.surfaces[LuaSurface.name].value.id_portal
end

-- setIdValue
local function setIdValue(LuaSurface, value)
  global.teleport.surfaces[LuaSurface.name].value.id_portal = value
end

----------------------------------------------------------------------------------

-- getPortalValue
local function getValue(LuaSurface)
  return global.teleport.surfaces[LuaSurface.name].value.portal
end

-- setPortalValue
local function setValue(LuaSurface, value)
  global.teleport.surfaces[LuaSurface.name].value.portal = value
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


--local function verifLink(LuaSurface, id, LuaPlayer)


----------------------------------------------------------------------------------

-- Téléportation entre portail
local function teleport(LuaSurface, id, LuaPlayer, instantTP)
  ritnlib.utils.ritnLog(">> (debug) - portal teleport - function ok")
  if not id then return end
  if LuaPlayer.driving then return end
  -- No characters
  if LuaPlayer.character == nil then return end
  
  -- fix 1.5.8
  local instant = false
  if instantTP ~= nil then instant = instantTP end

  -- fix 1.4.62
  if global.teleport.surfaces[LuaSurface.name] then 
    if global.teleport.surfaces[LuaSurface.name].players then 
      if global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name] then 
        if instant == false then
          if global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name].tp == true then return end
        end
      end
    end
  end
  
  -- Récupère la surface de destination
  local LuaSurface_dest = game.surfaces[getDestinationId(LuaSurface, id)]

  if LuaSurface_dest ~= nil then
      if global.teleport.surfaces[LuaSurface_dest.name] then
        if getValue(LuaSurface_dest) ~= 0 then
          
          local pos2 = nil

          for id, portal in pairs(global.teleport.surfaces[LuaSurface_dest.name].portals) do
              if portal.dest == LuaSurface.name then
                  pos2 = portal.position
              end
          end

          if pos2 == nil then
            LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.dest_not_find)
              return
          end

          local id2 = getId(LuaSurface_dest, pos2)

          if id2 == nil then
            LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.dest_not_find)
          else
              if LuaPlayer.name == LuaSurface.name or LuaPlayer.name == LuaSurface_dest.name then
                
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
                  print(">> " .. LuaPlayer.name .." -> " .. LuaSurface_dest.name)
                  ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name])
                  if LuaPlayer.name == LuaSurface_dest.name then
                    LuaPlayer.teleport({pos2.x+1.1,pos2.y+1.1},LuaSurface_dest)
                  else
                    LuaPlayer.teleport({pos2.x-1.1,pos2.y+1.1},LuaSurface_dest)
                  end
              else
                LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.no_access)
              end
          end
        else
          LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.dest_not_find)
          return
        end
      end
      
  else
    LuaPlayer.print(ritnmods.teleport.defines.name.caption.msg.not_link)
    if Luasurface_dest ~= ritnmods.teleport.defines.value.portal_not_link then 
      setDestinationId(LuaSurface, id, ritnmods.teleport.defines.value.portal_not_link)

      local renderId = getRenderId(LuaSurface, getPositionId(LuaSurface, id))
      if renderId ~= -1 then 
        rendering.set_text(renderId, ritnmods.teleport.defines.value.portal_not_link) -- Change text
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

-- Retourne la liste des fonctions
return flib