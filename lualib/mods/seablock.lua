-------------------------
--      SEABLOCK       --
-------------------------
local ritnlib = {}
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
-------------------------

local function giveresearch(force)
  local techs = {
    'landfill'
  }
  local newforce = force.technologies['sb-startup1'].researched == false
  for _,v in ipairs(techs) do
    force.technologies[v].researched = true
  end
  if newforce then
    force.add_research("sb-startup1")
  end
end
-------------------------

local function giveitems(entity)
  local landfill = 'landfill'
  if settings.startup['sb-default-landfill'] and game.item_prototypes[settings.startup['sb-default-landfill'].value] then
    landfill = settings.startup['sb-default-landfill'].value
  end
  local stuff = {
    {landfill, 1000},
    {"stone", 50},
    {"small-electric-pole", 50},
    {"small-lamp", 12},
    {"iron-plate", 1200},
    {"basic-circuit-board", 200},
    {"stone-pipe", 100},
    {"stone-pipe-to-ground", 50},
    {"stone-brick", 500},
    {"pipe", 22},
    {"copper-pipe", 5},
    {"iron-gear-wheel", 20},
    {"iron-stick", 96},
    {"pipe-to-ground", 2}
  }
  if game.item_prototypes["wind-turbine-2"] then
    table.insert(stuff, {"wind-turbine-2", 120})
  else
    table.insert(stuff, {"solar-panel", 38})
    table.insert(stuff, {"accumulator", 32})
  end
  for _,v in ipairs(stuff) do
    entity.insert{name = v[1], count = v[2]}
  end
end
-------------------------

local function haveitem(player, itemname, crafted)
  local unlock = global.unlocks[itemname]
  -- Special case for basic-circuit because it is part of starting equipment
  if unlock and (itemname ~= 'basic-circuit-board' or crafted) then
    for _,v in ipairs(unlock) do
      if player.force.technologies[v] then
        player.force.technologies[v].researched = true
      end
    end
  end
end
-------------------------

local function startMap(LuaSurface)
    if game.players[LuaSurface.name] then 
        local chest = LuaSurface.create_entity({name = "rock-chest", position = {0,0}, force = game.forces.neutral})
        giveitems(chest)
    end
    local details = {
      lib = "mods",
      category = "seablock",
      funct = "startMap",
      state = "ok"
    }
    ritnlib.utils.pcallLog(details)
end


-----------------------
local seablock = {}
seablock.startMap = startMap

return seablock

