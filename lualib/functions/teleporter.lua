---
-- Fonction Teleporter
---
local flib = {}
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------

-- getIdValue
local function getIdValue(LuaSurface)
  local result
  pcall(function() 
    result = global.teleport.surfaces[LuaSurface.name].value.id_teleporter
  end)
  return result
end

-- setIdValue
local function setIdValue(LuaSurface, value)
  pcall(function() 
    global.teleport.surfaces[LuaSurface.name].value.id_teleporter = value
  end)
end

----------------------------------------------------------------------------------

-- getTeleporterValue
local function getValue(LuaSurface)
  local result
  pcall(function() 
    result = global.teleport.surfaces[LuaSurface.name].value.teleporter
  end)
  return result
end

-- setTeleporterValue
local function setValue(LuaSurface, value)
  pcall(function() 
    global.teleport.surfaces[LuaSurface.name].value.teleporter = value
  end)
end

----------------------------------------------------------------------------------

-- getId
local function getId(LuaSurface, position)
  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then
  if position ~= nil then
  ------
    if global.teleport.surfaces[LuaSurface.name].teleporters then
      for i,teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
        if teleporter.teleport == 1 then
          if teleporter.position.x == position.x and teleporter.position.y == position.y then
            return teleporter.id
          end
        end
      end
    end
  ------
  end
  end
  end
end

----------------------------------------------------------------------------------

-- getName
local function getNamePosition(LuaSurface, position)
  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then
  if position ~= nil then
  ------
    if global.teleport.surfaces[LuaSurface.name].teleporters then
      for i,teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
        if teleporter.teleport == 1 then
          if teleporter.position.x == position.x and teleporter.position.y == position.y then
            return teleporter.name
          end
        end
      end
    end
  ------
  end
  end
  end
end

local function getNameId(LuaSurface, id)
  if LuaSurface ~= nil then
  if global.teleport.surfaces[LuaSurface.name] ~= nil then
  if id ~= nil then
  ------
    if global.teleport.surfaces[LuaSurface.name].teleporters then
      for i,teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
        if teleporter.teleport == 1 then
          if teleporter.id == id then
            return teleporter.name
          end
        end
      end
    end
  ------
  end
  end
  end
end

-- setName
local function setNameId(LuaSurface, id, name)
  if global.teleport.surfaces[LuaSurface.name].teleporters then
    for i,teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
      if teleporter.teleport == 1 then
        if teleporter.id == id then
          teleporter.name = name
        end
      end
    end
  end
end

----------------------------------------------------------------------------------

-- getRenderId
local function getRenderId(LuaSurface, position)
  if global.teleport.surfaces[LuaSurface.name].teleporters then
    for i,teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
      if teleporter.teleport == 1 then
        if teleporter.position.x == position.x and teleporter.position.y == position.y then
          if teleporter.render_id then
            return teleporter.render_id
          else
            return -1
          end
        end
      end
    end
  else return -1
  end
end

-- setRenderId
local function setRenderId(LuaSurface, position, renderId)
  if global.teleport.surfaces[LuaSurface.name].teleporters then
    for i,teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
      if teleporter.teleport == 1 then
        if teleporter.position.x == position.x and teleporter.position.y == position.y then
          teleporter.render_id = renderId
        end
      end
    end
  end
end

----------------------------------------------------------------------------------

-- getPosition
local function getPosition(LuaSurface, name)
  if global.teleport.surfaces[LuaSurface.name].teleporters then
    for i, teleporter in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
      if teleporter.teleport == 1 then
        if teleporter.name == name then
          return teleporter.position
        end
      end
    end
  end
end

----------------------------------------------------------------------------------

-- New
local function new(id, position, renderId, type)    
  local name_teleporter = "teleporter" .. id
 
  local teleporter = 
    {
      id = id,
      position = position,
      name = name_teleporter,
      render_id = renderId,
      teleport = type,
    }
  return teleporter
end



-- Suppression de la structure "portal" dans global.teleport.surfaces[surface.name].portals
local function delete(LuaSurface, TabPosition)
    local id = getId(LuaSurface, TabPosition)
          
    for i,portal in pairs(global.teleport.surfaces[LuaSurface.name].teleporters) do
        if portal.id == id then
          global.teleport.surfaces[LuaSurface.name].teleporters[i] = nil
        end
    end      
    setValue(LuaSurface, getValue(LuaSurface) - 1)
end
  
----------------------------------------------------------------------------------
  
-- Teleporte le Joueur
local function teleport(LuaPlayer, LuaSurface, name)
    if LuaPlayer ~= nil and LuaPlayer.character ~= nil then
        if LuaSurface ~= nil then
          if name ~= nil then
            local position = getPosition(LuaSurface, name)
            local decalage = ritnlib.utils.positionTP(LuaPlayer, 1.0)
            LuaPlayer.teleport({position.x + decalage,position.y + decalage}, LuaSurface)
          end
        end
    end 
end

----------------------------------------------------------------------------------

----------------------------
-- Chargement des fonctions
flib.new = new
flib.delete = delete
flib.teleport = teleport
flib.getIdValue = getIdValue
flib.setIdValue = setIdValue
flib.getValue = getValue
flib.setValue = setValue
flib.getId = getId
flib.getNamePosition = getNamePosition
flib.getNameId = getNameId
flib.setNameId = setNameId
flib.getRenderId = getRenderId
flib.setRenderId = setRenderId
flib.getPosition =getPosition

-- Retourne la liste des fonctions
return flib