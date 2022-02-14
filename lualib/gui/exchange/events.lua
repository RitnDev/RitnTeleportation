-- INITIALISATION
if not ritnmods.exchange then ritnmods.exchange = {} end
if not ritnmods.exchange.events then ritnmods.exchange.events = {} end


----
-- Function Events
---


-- on player created
function ritnmods.exchange.events.invoke(e)
  local p = game.players[e.player_index]
  local frame = p.gui.screen["ritn-gui-exchange"]
  ritnmods.exchange.gui.frame.open(frame, p)
end


-- on gui click
function ritnmods.exchange.events.action(e)

  local element = e.element.name
  local p = game.players[e.player_index]
  local frame = p.gui.screen["ritn-gui-exchange"]

  if element ~= nil then
    if string.sub(element, -6) == "button" then

      if element == "ritn-gui-exchange-back-button" then 
        ritnmods.exchange.gui.frame.close(frame)
      end

      if element == "ritn-gui-exchange-valid-button" then 
        if frame["Main-Flow"]["Vertical-Flow-Pane"]["ritn-gui-exchange-texte"].text ~= nil then
          local text = frame["Main-Flow"]["Vertical-Flow-Pane"]["ritn-gui-exchange-texte"].text
          if string.sub(text, -3) == "<<<" and string.sub(text, 1, 3) == ">>>" then
            if pcall(function() local mapGen = load("return  " .. serpent.block(game.parse_map_exchange_string(text)))() end) then 
              local mapGen = load("return  " .. serpent.block(game.parse_map_exchange_string(text)))()
              --mapGen.seed = math.random(1,4294967290) --changement de la seed
              local surface = game.create_surface(p.name, mapGen)
              p.teleport({0,0}, surface.name)
              ritnmods.exchange.gui.frame.close(frame)
            else
              frame["Main-Flow"]["Vertical-Flow-Pane"]["ritn-gui-exchange-texte"].text = ""
            end
          else
            frame["Main-Flow"]["Vertical-Flow-Pane"]["ritn-gui-exchange-texte"].text = ""
          end
        else
          frame["Main-Flow"]["Vertical-Flow-Pane"]["ritn-gui-exchange-texte"].text = ""
        end
      end
      
    end
  end

end