---
-- Fonction Surface
---
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local prefix_enemy = ritnmods.teleport.defines.prefix.enemy

-- Système de cessé le feu avec les ennemies lors d'un changement d'état d'un joueur.
local function UpdateCeaseFires(LuaSurface)

  if global.teleport.surfaces[LuaSurface.name] then 

    local forces = {}
		table.insert(forces, "guides")
		if LuaSurface.name == "nauvis" then 
			table.insert(forces, "player")
		else 
			table.insert(forces, LuaSurface.name)
		end

    if global.teleport.surfaces[LuaSurface.name].map_used then 
      -- Map active
      for _,force in pairs(forces) do
        if game.forces[force] then 
          print(">> active enemy : " .. force)
          if LuaSurface.name == "nauvis" then 
            game.forces["enemy"].set_cease_fire(force, false)
          else 
            game.forces["enemy"].set_cease_fire(force, false)
            local enemy = prefix_enemy .. LuaSurface.name
            if game.forces[enemy] then 
              game.forces[enemy].set_cease_fire(force, false)
            end
          end
        end
      end
    else
      -- Map inactive
      for _,force in pairs(forces) do
        if game.forces[force] then 
          print(">> désactive enemy : " .. force)
          if LuaSurface.name == "nauvis" then 
            game.forces["enemy"].set_cease_fire(force, true)
          else 
            game.forces["enemy"].set_cease_fire(force, true)
            local enemy = prefix_enemy .. LuaSurface.name
            if game.forces[enemy] then 
              game.forces[enemy].set_cease_fire(force, true)
            end
          end
        end
      end
    end
  end

end


-- Fonction de creation d'un portail sur la surface
local function create_portal(LuaSurface, position, player_name, raiseBuilt, createBuildEffectSmoke)
    
    local raise_built = false
    local create_build_effect_smoke

    if raiseBuilt ~= nil then raise_built = raiseBuilt end
    if createBuildEffectSmoke ~= nil then create_build_effect_smoke = createBuildEffectSmoke end

    local LuaEntity = LuaSurface.create_entity({
        name = ritnmods.teleport.defines.name.entity.portal,
        position = position,
        force = player_name,
        raise_built = raise_built,
        player = player_name,
        create_build_effect_smoke = create_build_effect_smoke
    })

    return LuaEntity
end


-- Generation de la structure de données global de la surface du joueur.
local function generateSurface(LuaSurface)
  if not global.teleport.surfaces[LuaSurface.name] then
    global.teleport.surfaces[LuaSurface.name] = {
      name = LuaSurface.name,
      exception = false,
      last_use = 0,
      map_used = false,
      value = {
          portal = 0,
          id_portal = 0,
          teleporter = 0,
          id_teleporter = 0,
      },
      portals = {},
      teleporters = {},
      inventories = {},
      players = {},
      finish = settings.startup[ritnmods.teleport.defines.name.settings.restart].value,
    }

    global.teleport.surface_value = global.teleport.surface_value + 1

  else
    global.teleport.surfaces[LuaSurface.name] = {
      name = LuaSurface.name,
      exception = false,
      last_use = 0,
      map_used = false,
      value = {
          portal = 0,
          id_portal = 0,
          teleporter = 0,
          id_teleporter = 0,
      },
      portals = {},
      teleporters = {},
      inventories = {},
      players = {},
      finish = settings.startup[ritnmods.teleport.defines.name.settings.restart].value,
    }
  end
end


local function addPlayer(LuaPlayer)
  local LuaSurface = LuaPlayer.surface
  global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name] = {
    name = LuaPlayer.name,
    tp = true,
    tick = game.tick,
  }
  pcall(function()
    if global.teleport.surfaces[LuaSurface.name].players[LuaPlayer.name] then 
      print(">> player add '" .. LuaPlayer.name .. "' - Surface : " .. LuaSurface.name)
    end
  end)

  global.teleport.surfaces[LuaSurface.name].map_used = ritnlib.utils.tableBusy(global.teleport.surfaces[LuaSurface.name].players)
  UpdateCeaseFires(LuaSurface)
end

local function removePlayer(LuaPlayer, oldSurface)
    for i,player in pairs(global.teleport.surfaces[oldSurface.name].players) do
      if global.teleport.surfaces[oldSurface.name].players[i].name == LuaPlayer.name then 
        global.teleport.surfaces[oldSurface.name].players[i] = nil
        pcall(function()
          if global.teleport.surfaces[oldSurface.name].players[i] == nil then 
            print(">> player removed '" .. LuaPlayer.name .. "' - Surface : " .. oldSurface.name)
          end
        end)
      end 
    end
    
    global.teleport.surfaces[oldSurface.name].map_used = ritnlib.utils.tableBusy(global.teleport.surfaces[oldSurface.name].players)
    UpdateCeaseFires(oldSurface)
end



----------------------------
-- Chargement des fonctions
local flib = {}
flib.create_portal = create_portal
flib.generateSurface = generateSurface
flib.addPlayer = addPlayer
flib.removePlayer = removePlayer
flib.UpdateCeaseFires = UpdateCeaseFires

-- Retourne la liste des fonctions
return flib







