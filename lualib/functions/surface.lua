---
-- Fonction Surface
---
---------------------------------------------------------------------------------------------
local util =          require(ritnmods.teleport.defines.mods.vanilla.lib.util)
local crash_site =    require(ritnmods.teleport.defines.mods.vanilla.lib.CrashSite)
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.utils =       require(ritnmods.teleport.defines.functions.utils)
ritnlib.seablock =    require(ritnmods.teleport.defines.mods.seablock)
ritnlib.player =      require(ritnmods.teleport.defines.functions.player)
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
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

  if LuaSurface.name == "nauvis" then 
    if global.teleport.surfaces["nauvis"] then return end
  end

  if not global.teleport.surfaces[LuaSurface.name] then
    global.teleport.surface_value = global.teleport.surface_value + 1
  end

  global.teleport.surfaces[LuaSurface.name] = {
    name = LuaSurface.name,
    exception = false,
    last_use = 0,
    map_used = false,
    origine = {},
    request = {},
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

  print(">> (debug) - function : generateSurface ok !")
end

-- Ajoute un player dans la structure de donnée surface.player()
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

-- Supprime un player dans la structure de donnée surface.player()
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



-- Creation du Lobby d'un joueur
local function createLobby(LuaPlayer)
  local prefix_lobby = ritnmods.teleport.defines.prefix.lobby
  local lobby_name = prefix_lobby .. LuaPlayer.name
  local LuaSurface = game.surfaces[lobby_name]
  local tiles = {}
  
  -- creation de la surface lobby si elle n'existe pas déjà
  if not LuaSurface then LuaSurface = game.create_surface(lobby_name) end
  -- préparation de la téléportation
  for x=-1,1 do
    for y=-1,1 do
      table.insert(tiles, {name = "lab-white", position = {x, y}})
    end
  end

  LuaSurface.set_tiles(tiles) 
  LuaPlayer.clear_items_inside()
  LuaPlayer.teleport({0,0}, lobby_name)
  LuaPlayer.character.active = false
end


-- Creation de la surface et force du joueur
local function createSurface(LuaPlayer)
  -- Si le nombre de surface est uniquement inférieur au max paramétrés.
  if global.teleport.surface_value-1 < global.settings.surfaceMax then 

        --return map_gen avec nouvelle seed
        local map_gen = ritnlib.utils.mapGeneratorNewSeed()

        local LuaSurface = game.create_surface(LuaPlayer.name, map_gen)  
        local tiles = {}
        
        for x=-1,1 do
          for y=-1,1 do
            table.insert(tiles, {name = "lab-white", position = {x, y}})
          end
        end
        
        LuaSurface.set_tiles(tiles) 
        local LuaForce = game.create_force(LuaPlayer.name)
        LuaForce.reset()
        LuaForce.research_queue_enabled = true
        LuaForce.chart(LuaSurface, {{x = -100, y = -100}, {x = 100, y = 100}})
        if game.active_mods["SeaBlock"] then  
          ritnlib.seablock.startMap(LuaSurface)
        end
        
        for k,v in pairs(game.forces) do
          if v.name ~= "enemy" and v.name ~= "neutral" then
            LuaForce.set_friend(v.name,true)
            game.forces["player"].set_friend(LuaForce.name, true)
          end
        end
  
        for r_name,recipe in pairs(LuaPlayer.force.recipes) do
          LuaForce.recipes[r_name].enabled = recipe.enabled
        end

        -- Creation de la structure de map dans les données
        generateSurface(game.surfaces.nauvis)
        global.teleport.surfaces["nauvis"].exception = true
        global.teleport.surfaces["nauvis"].map_used = true
        generateSurface(LuaSurface)
        global.teleport.surfaces[LuaSurface.name].exception = LuaPlayer.admin
        global.teleport.surfaces[LuaSurface.name].inventories[LuaPlayer.name] = ritnlib.inventory.init()
        table.insert(global.teleport.surfaces[LuaSurface.name].origine, LuaPlayer.name)

        -- 1.8.0
        -- Enregistrement de la surface d'origine
        if not global.teleport.players[LuaPlayer.name] then 
          global.teleport.players[LuaPlayer.name] = {origine = LuaSurface.name}
        end
        local origine = global.teleport.players[LuaPlayer.name].origine

        -- Teleportation sur la surface du personnage.
        ritnlib.inventory.save(LuaPlayer, global.teleport.surfaces[origine].inventories[LuaPlayer.name])
        LuaPlayer.teleport({0,0}, origine)
        LuaPlayer.character.active = true

        --Chargement des items
        LuaPlayer.clear_items_inside()
        local items_start_variantes = 1
        -- Variantes avec SpaceBlock
        if game.active_mods["spaceblock"] then
          items_start_variantes = 2
        end
        if game.active_mods["SeaBlock"] then
          items_start_variantes = 3
        end
        ritnlib.player.give_start_item(LuaPlayer, items_start_variantes)
        
        
        -- Add Crash site :
        if items_start_variantes <= 1 then   
          crash_site.create_crash_site(LuaSurface, {-5,-6}, util.copy(global.crashed_ship_items), util.copy(global.crashed_debris_items))
          util.remove_safe(LuaPlayer, global.crashed_ship_items)
          util.remove_safe(LuaPlayer, global.crashed_debris_items)
        end
        
  else
    game.kick_player(LuaPlayer.name, ritnmods.teleport.defines.name.caption.msg.serveur_full)
  end
end



----------------------------
-- Chargement des fonctions
local flib = {}
flib.create_portal = create_portal
flib.generateSurface = generateSurface
flib.addPlayer = addPlayer
flib.removePlayer = removePlayer
flib.UpdateCeaseFires = UpdateCeaseFires
flib.createLobby = createLobby
flib.createSurface = createSurface

-- Retourne la liste des fonctions
return flib







