-- INITIALISATION
if not ritnmods.exchange then ritnmods.exchange = {} end
if not ritnmods.exchange.gui then ritnmods.exchange.gui = {} end
if not ritnmods.exchange.gui.frame then ritnmods.exchange.gui.frame = {} end


-- CREATION DU GUI
local gui_exchange =
  function (p)

    ----
    -- Frame principale
    ----
      frame = p.gui.screen.add{
        type = "frame",
        name = "ritn-gui-exchange",
        caption = {"gui.map-exchange-string"},
      }
      frame.auto_center = true
      frame.style.use_header_filler = true

      frame.style.bottom_padding = 8
      frame.style.top_padding = 4
      frame.style.left_padding = 8
      frame.style.right_padding = 8
      frame.style.maximal_height = 1080
      
      ----
      -- Flow principale
      ----
      MainFlow = frame.add{
        type = "flow",
        name = "Main-Flow",
        direction = "vertical",
      }


      ----
      -- Flow secondaire
      ----

      --  1 Vertical Flow
      VerticalFlowPane = MainFlow.add{
        type = "flow",
        name = "Vertical-Flow-Pane",
        direction = "vertical",
      }


      -- 1 Horizontal Flow
      HorizontalFlow = MainFlow.add{
        type = "flow",
        name = "Horizontal-Flow",
        direction = "horizontal",
      }
      HorizontalFlow.style.top_padding = 8
      HorizontalFlow.style.vertically_stretchable = false
      


      ----
      -- Element dans : 1 Vertical Flow
      ---

      notice_textbox = VerticalFlowPane.add{
        type = "label",
        name = "notice-textbox",
        caption = {"gui-map-generator.exchange-string-instructions"},
      }
      notice_textbox.style.minimal_width = 0
      notice_textbox.style.maximal_width = 450
      notice_textbox.style.padding = 0
      notice_textbox.style.minimal_height = 28
      notice_textbox.style.natural_width = 200
      notice_textbox.style.left_padding = 3
      notice_textbox.style.right_padding = 2

      TextBox = VerticalFlowPane.add{
        type = "text-box",
        name = "ritn-gui-exchange-texte",
      }
      TextBox.style.width = 500
      TextBox.style.height = 250


      ----
      -- Element dans : 1 Horizontal Flow
      ----

      SlotButtonBase1 = HorizontalFlow.add{
        type = "flow",
        name = "SlotButtonBase-Back",
      }

      -- espace entre les boutons
      Filler  = HorizontalFlow.add{
        type = "empty-widget",
        name = "draggable-space",
      }
      Filler.style.width = 250
      Filler.style.height = 40
      Filler.style.horizontally_stretchable = true
      Filler.style.vertically_stretchable = true
      Filler.style.left_margin = 8
      Filler.style.right_margin = 8


      SlotButtonBase2 = HorizontalFlow.add{
        type = "flow",
        name = "SlotButtonBase-Valid",
      }

      ----
      -- Element dans : SlotButtonBase1
      ----

      back_button = SlotButtonBase1.add{
        type = "button",
        name = "ritn-gui-exchange-back-button",
        caption = {"gui.cancel"},
      }
      back_button.style.horizontal_align = "left"
      back_button.style.minimal_width = 112
      back_button.style.height = 32
      back_button.style.natural_height = 32
      back_button.style.font = "default-dialog-button"
      back_button.mouse_button_filter.left = true




      ----
      -- Element dans : SlotButtonBase2
      ----

      valid_button = SlotButtonBase2.add{
        type = "button",
        name = "ritn-gui-exchange-valid-button",
        caption = {"gui.confirm"},
      }
      valid_button.style.horizontal_align = "right"
      valid_button.style.minimal_width = 112
      valid_button.style.height = 32
      valid_button.style.natural_height = 32
      valid_button.style.font = "default-dialog-button"
      valid_button.mouse_button_filter.left = true

  end


---
-- Fonction "GUI"
---

-- Ajout de la fonction de création du GUI
ritnmods.exchange.gui.frame.gui = 
  function(p)
    gui_exchange(p)
  end


    -- close gui
function ritnmods.exchange.gui.frame.close(frame)
  if frame ~= nil then 
    if frame.name == "ritn-gui-exchange" then 
      frame.destroy()
    end
  end
end

    -- open gui
function ritnmods.exchange.gui.frame.open(frame, p)
  ritnmods.exchange.gui.frame.close(frame)
  ritnmods.exchange.gui.frame.gui(p)
end
