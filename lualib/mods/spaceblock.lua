local module = {}
module.events = {}
-------------------------
local ritnlib = {}
ritnlib.utils =      require(ritnmods.teleport.defines.functions.utils)
-------------------------


-- Fonction utilisé dans le mod spaceblock pour générer la surface en landfill
local function spaceblock(ev)

  local surface=ev.surface
  local area=ev.area
  local tv={}
  local t={}
  local tx
  local base_tile=1

  for x = area.left_top.x, area.right_bottom.x do
      
      for y= a.left_top.y, area.right_bottom.y do

          if((x>-9 and x<8) and (y>-9 and y<8))then
              tx=tx or {} table.insert(tx,{name="landfill",position={x,y}})
          else

              local tile="space-tile-"..base_tile --"out-of-map"
              local rg=false

              if(math.random(1,5)==1)then rg=true tile="space-tile-"..math.random(1,8) end
              
              if(rg)then

                  local zx,zy=x,y
                  tv[zx]=tv[zx] or {}
                  
                  if(not tv[zx][zy])then table.insert(t,{name=tile,position={zx,zy}}) end
                  
                  for i=1,math.random(4,12) do
                      local xy=math.random(1,4)-2
                      zx=zx+(xy==-1 and -1 or (xy==2 and 1 or 0))
                      zy=zy+(xy==0 and -1 or (xy==1 and 1 or 0))
                      tv[zx]=tv[zx] or {}
                      if(math.abs(zx)>8 and math.abs(zy)>8 and not tv[zx][zy])then tv[zx][zy]=true table.insert(t,{name=tile,position={zx,zy}}) end
                  end

              elseif(not tv[x] or not tv[x][y])then
                  table.insert(t,{name=tile,position={x,y}}) tv[x]=tv[x] or {} tv[x][y]=true
              end

          end

      end

  end

  surface.destroy_decoratives{area=area}
  if(tx)then surface.set_tiles(tx) end
  surface.set_tiles(t)
  for k,v in pairs(surface.find_entities_filtered{type="character",invert=true,area=area})do v.destroy{raise_destroy=true} end

end



-- Génère une surface type "Spaceblock" si le mod est actif
local function on_chunk_generated(e)
    if game.active_mods["spaceblock"] then
      spaceblock(e)
      local details = {
        lib = "mods",
        category = "spaceblock",
        state = "ok"
      }
      ritnlib.utils.pcallLog(details, e)
    end
end

module.events[defines.events.on_chunk_generated] = on_chunk_generated

return module