---------------------------------------------------------------------------------------------
-- >>  GUI MENU
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.enemy =       require(ritnmods.teleport.defines.functions.enemy)
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
-- Variables :
local prefix_enemy = ritnmods.teleport.defines.prefix.enemy
---------------------------------------------------------------------------------------------
local module = {}
module.events = {}


-- Remplace les entitées "spawner" de la force "enemy" par la force "enemy~[player_name]"
local function on_chunk_generated(e)
    local area = e.area
    local position = e.position
    local LuaSurface = e.surface

    if LuaSurface.name == "nauvis" then return end
    if string.sub(LuaSurface.name, 1, 6) == "lobby~" then return end -- add 1.8.2
    if global.enemy.setting == false then return end
    if global.enemy.value == false then return end

    local TabEntities = LuaSurface.find_entities_filtered{area=area, force="enemy"}
    for i,entity in pairs(TabEntities) do
        entity.force = prefix_enemy .. LuaSurface.name
    end
end


--Creation de la force enemy de la map joueur
local function on_player_changed_surface(e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface

    if LuaSurface.name == "nauvis" then return end
    if string.sub(LuaSurface.name, 1, 6) == "lobby~" then return end -- add 1.8.2
    if global.enemy.setting == false then return end
    if global.enemy.value == false then return end

    local force_name = prefix_enemy .. LuaSurface.name

    if not game.forces[force_name] then
        local LuaForce = game.create_force(force_name)
        LuaForce.reset()
        LuaForce.reset_evolution()
        LuaForce.ai_controllable = true
        LuaForce.set_cease_fire("enemy", true)
        game.forces["enemy"].set_cease_fire(LuaForce, true)
    end

    local details = {
      lib = "modules",
      category = "enemy",
      state = "ok"
    }
    ritnlib.utils.pcallLog(details, e)

end


---
-- Commandes: 
---

commands.add_command("evo", "", 
  function (e)
    local LuaPlayer = game.players[e.player_index]
    local LuaSurface = LuaPlayer.surface
    LuaSurface.print({"msg.evo", LuaSurface.name, ritnlib.enemy.getEvoFactor(LuaSurface,"%d.%d%%")},{r=0,g=1,b=0,a=1})
  end
)


module.events[defines.events.on_chunk_generated] = on_chunk_generated
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface

return module

