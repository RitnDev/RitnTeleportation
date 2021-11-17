---
-- Module "lobby"
---
local prefix_lobby = ritnmods.teleport.defines.prefix.lobby


local function on_chunk_generated(e)
    local LuaSurface=e.surface
    local area=e.area
    local tv={}
    local tab_tiles={}
    local tx
    local base_tile=1

    -- seulement si la map commence par : "lobby~"
    if string.sub(LuaSurface.name,1,6) == prefix_lobby then 
  
        for x = area.left_top.x, area.right_bottom.x do 
            for y= area.left_top.y, area.right_bottom.y do
                if((x>-2 and x<1) and (y>-2 and y<1))then
                    tx=tx or {} table.insert(tx,{name="refined-concrete",position={x,y}})
                else
                    local tile="out-of-map"
                    table.insert(tab_tiles, {name=tile,position={x,y}}) tv[x]=tv[x] or {} tv[x][y]=true
                end
            end
        end
    
        LuaSurface.destroy_decoratives{area=area}
        if(tx)then LuaSurface.set_tiles(tx) end
        LuaSurface.set_tiles(tab_tiles)
        for k,v in pairs(LuaSurface.find_entities_filtered{type="character",invert=true,area=area})do v.destroy{raise_destroy=true} end
    end
end



----------------------
local module = {}
module.events = {}
----------------------
module.events[defines.events.on_chunk_generated] = on_chunk_generated
----------------------
return module