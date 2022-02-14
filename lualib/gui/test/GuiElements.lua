---------------------------------------------------------------------------------------------
local ritnlib = {}
ritnlib.gui =         require(ritnmods.teleport.defines.functions.gui)
ritnlib.styles =      require(ritnmods.teleport.defines.functions.styles)
---------------------------------------------------------------------------------------------
-- Properties
local visible = false
local modGui = require("mod-gui")


local function create_gui(LuaPlayer)
    local left = modGui.get_frame_flow(LuaPlayer)
    local content = {}

    content.main = ritnlib.gui.createFlowV(
        left,
        "test-flow-common"
    )

    content.frame = ritnlib.gui.createFrame(
        content.main,
        "test-frame-test",
        "Téléporteur"
    )
    ritnlib.styles.ritn_frame_remote_style(content.frame.style)

    content.frameInside = ritnlib.gui.createFrame(
        content.frame,
        "test-frame-inside"
    )
    content.frameInside.style = "inside_deep_frame"
    content.frameInside.style.horizontally_stretchable = true 
    content.frameInside.style.vertically_stretchable = true


    content.Pane = ritnlib.gui.createScrollPane(
        content.frameInside,
        "test-pane-test"
    )
    ritnlib.styles.ritn_scroll_pane(content.Pane.style)
    content.Pane.style.horizontally_stretchable = true 
    content.Pane.style.vertically_stretchable = true
    --content.Pane.style.vertical_spacing = 2
    
    for i=1,10 do 

        -- flow
        content["flowInput" .. i] = ritnlib.gui.createFlowV(
            content.Pane,
            "test-flow-input" .. i
        )
        content["flowInput" .. i].style.horizontally_stretchable = true 
        content["flowInput" .. i].style.height = 28
        content["flowInput" .. i].style.padding = 0
        

        -- frame
        content["frameInput" .. i] = ritnlib.gui.createFrame(
            content["flowInput" .. i],
            "test-frame-input" .. i,
            "",
            "horizontal"
        )
        content["frameInput" .. i].style.horizontally_stretchable = true 
        content["frameInput" .. i].style.vertically_stretchable = true
        content["frameInput" .. i].style.padding = 0



        -- label
        content["labelInput" .. i] = ritnlib.gui.createLabel(
            content["frameInput" .. i],
            "test-label-Input" .. i,
            "Test " .. i
        )

        -- Filler
        content["filler" .. i] = ritnlib.gui.createEmptyWidget(content["frameInput" .. i])
        content["filler" .. i].style = "draggable_space"
        content["filler" .. i].style.vertically_stretchable = true
        content["filler" .. i].style.width = 40


    end

    
    









    -- button teleport
    content.button_teleport = ritnlib.gui.createButton(
        content.frame,
        "test-button-teleport",
        "Téléporter"
    )
    ritnlib.styles.ritn_small_button(content.button_teleport.style)


end





---
-- Fonction "GUI"
---


-- close gui
local function close(LuaPlayer)
    local left = modGui.get_frame_flow(LuaPlayer)
    local frame = left["test-flow-common"]
  
    if frame then 
      frame.destroy()
    end
  end
  
  
  -- open gui
  local function open(LuaPlayer)
    close(LuaPlayer)
    create_gui(LuaPlayer)
  end
  
  
  ------------------------------
  local luaGui = {}
  luaGui.open = open
  luaGui.close = close
  
  return luaGui