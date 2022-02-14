-- INITIALISATION
---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.player =      require(ritnmods.teleport.defines.functions.player)
ritnlib.teleporter =  require(ritnmods.teleport.defines.functions.teleporter)
ritnlib.inventory =   require(ritnmods.teleport.defines.functions.inventory)
ritnlib.utils =           require(ritnmods.teleport.defines.functions.utils)
---------------------------------------------------------------------------------------------
local ritnGui = {}
ritnGui.remote =            require(ritnmods.teleport.defines.gui.remote.GuiElements)
---------------------------------------------------------------------------------------------
local module = {}
module.events = {}


  
-- Mise en place de l'entité portail sur le terrain
local function teleporter_place(e)
  local LuaEntity = e.created_entity
  local LuaPlayer = game.players[e.player_index]
  local prefix_restart = ritnmods.teleport.defines.name.gui.prefix.restart
  
  
  if not LuaEntity then return end
  if not LuaEntity.valid then return end
  if not LuaPlayer then return end

  local surface = LuaEntity.surface

  if surface.name ~= global.teleport.players[LuaPlayer.name].origine then return end
  -- No characters
  if LuaPlayer.character == nil then return end
  if LuaEntity.name ~= ritnmods.teleport.defines.name.entity.teleporter then return end
  -- On ouvre pas la fenêtre de portail si l'interface restart est déjà ouverte
  local center = LuaPlayer.gui.center
  local frame_restart = center[prefix_restart .. ritnmods.teleport.defines.name.gui.menu.frame_restart]
  if frame_restart then return end

  local details = {
    lib = "modules",
    category = "teleporter"
  }

  if LuaPlayer.name ~= nil then 
    details.state = LuaPlayer.name .." -> place teleporter"
    ritnlib.utils.pcallLog(details, e)
  end

  if LuaEntity.name == ritnmods.teleport.defines.name.entity.teleporter then
    if global.teleport.players[LuaPlayer.name].origine == surface.name then

      local idValue = ritnlib.teleporter.getIdValue(surface) + 1
      ritnlib.teleporter.setIdValue(surface, idValue) -- id_value + 1   
      
      local renderId = rendering.draw_text{
        text="teleporter" .. idValue,
        surface=surface,
        target=LuaEntity,
        alignment = "center",
        target_offset={0, -2.0},
        color = {r = 0.115, g = 0.955, b = 0.150, a = 1},
        scale_with_zoom = true,
        scale = 1.5
      }
      LuaEntity.destructible = false

      local table_prep = ritnlib.teleporter.new(idValue, LuaEntity.position, renderId, 1)
 

      table.insert(global.teleport.surfaces[surface.name].teleporters , table_prep)
      ritnlib.teleporter.setValue(surface, ritnlib.teleporter.getValue(surface) + 1) -- value + 1

      ritnGui.remote.close(LuaPlayer) -- fermeture du GUI remote s'il est ouvert.

      details.state = "place"
      ritnlib.utils.pcallLog(details, e)
    else
      LuaPlayer.insert{name = ritnmods.teleport.defines.name.item.teleporter, count = 1}
      LuaEntity.destroy()
    end
  end

end



-- Quand on enlève le teleporter sur le terrain
local function teleporter_breaks(e)

    local isDied = false
    local LuaEntity = {}
    local LuaSurface = {}

    LuaEntity = e.entity
    LuaSurface = LuaEntity.surface

    -- Vérifie que l'entité est bien un portail
    if LuaEntity.name == ritnmods.teleport.defines.name.entity.teleporter then   
      local LuaPlayer = {}
      local TabPosition = {}

      -- Position du portail enlevé
      TabPosition = LuaEntity.position

      local details = {
        lib = "modules",
        category = "portal",
        event_name = "on_player_mined_entity",
        func = "teleporter_breaks",
      }
      ritnlib.utils.pcallLog(details)


      if e.cause ~= nil then 
        -- Suppression de la structure "teleporter" dans global.teleport.surfaces[surface.name].teleporters
        ritnlib.teleporter.delete(LuaSurface, TabPosition)
        details.state = LuaSurface.name .." -> break teleporter"
        ritnlib.utils.pcallLog(details)
        return 
      end

      if e.player_index == nil then return else 
        LuaPlayer = game.players[e.player_index]
        
        details.state = LuaSurface.name .." -> break teleporter"
        ritnlib.utils.pcallLog(details)

        if global.teleport.players[LuaPlayer.name].origine == LuaEntity.surface.name then 
          -- Suppression de la structure "teleporter" dans global.teleport.surfaces[surface.name].teleporters
          ritnlib.teleporter.delete(LuaSurface, TabPosition)
          if LuaPlayer.cursor_stack 
          and LuaPlayer.cursor_stack.valid 
          and LuaPlayer.cursor_stack.valid_for_read 
          and LuaPlayer.cursor_stack.name == ritnmods.teleport.defines.name.item.remote then
            ritnGui.remote.open(LuaPlayer)
          else
            ritnGui.remote.close(LuaPlayer)
          end
        else
          e.buffer.clear()
          
          local LuaEntity1 = LuaSurface.create_entity({ 
            name = ritnmods.teleport.defines.name.entity.teleporter,
            position = TabPosition,
            force = LuaEntity.last_user.name,
            raise_built = false,
            player = LuaEntity.last_user.name,
            create_build_effect_smoke = false
          })
          LuaEntity1.destructible = false
          
          local name = ritnlib.teleporter.getNamePosition(LuaSurface, TabPosition)
          
          local renderId = rendering.draw_text{
            text=name,
            surface=LuaSurface,
            target=LuaEntity1,
            alignment = "center",
            target_offset={0, -2.0},
            color = {r = 0.115, g = 0.955, b = 0.150, a = 1},
            scale_with_zoom = true,
            scale = 1.5
          }
          
          ritnlib.teleporter.setRenderId(LuaSurface, TabPosition, renderId)

        end
      end

    end

end


local function on_player_cursor_stack_changed(e) 
  local LuaPlayer = game.players[e.player_index]
  -- modif 2.0.10
  if LuaPlayer == nil then return end
  if LuaPlayer.cursor_stack.count == 0 then return end
  
  local LuaItemStack = LuaPlayer.cursor_stack
  if LuaItemStack == nil then return end
  if LuaItemStack.valid == false then return end
  
  if LuaItemStack.name == ritnmods.teleport.defines.name.item.teleporter then 
    ritnlib.inventory.clearCursor(LuaPlayer, ritnmods.teleport.defines.name.item.teleporter, true)

    local details = {
      lib = "modules",
      category = "teleporter",
    }
    ritnlib.utils.pcallLog(details, e)
  end
end


----------------------------------------------------------------------------
-- events
module.events[defines.events.on_player_mined_entity] = teleporter_breaks
module.events[defines.events.on_built_entity] = teleporter_place

-- Autres events
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed

return module
