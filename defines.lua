-----------------------------------------
--               DEFINES               --
-----------------------------------------
local defines = {}
-- Mod ID.
defines.mod_id = "RitnTeleportation"
-- Path to the mod's directory.
defines.mod_directory = "__RitnTeleportation__"


-- Library
local classpath = "lualib/"
local modules = classpath .. "modules/"
local core = "core/"
defines.lib = {
    --folders
    classpath = classpath,
    gui = classpath .. "gui/",
    mods = classpath .. "mods/",
    functions = classpath .. "functions/",
    --files
    gvv = "__gvv__.gvv",
    migrations = core .. "migrations",
    modules = core .. "modules",

    events = classpath .. "events",

    gui_portal = modules .. "gui_portal",
    gui_menu = modules .. "gui_menu",
    gui_teleporter = modules .. "gui_teleporter",
    gui_teleporter_remote = modules .. "gui_teleporter_remote",

    portal = modules .. "portal",
    teleporter = modules .. "teleporter",

    player = modules .. "player",
    enemy = modules .. "enemy",
    lobby = modules .. "lobby",
}

-- graphics
local graphics = defines.mod_directory .. "/graphics/"
local gui = graphics .. "gui/"
defines.graphics = {
    gui = {
        main_menu = gui .. "button-main-menu.png",
        close = gui .. "close-white.png",
        link = gui .. "icon-link.png",
        unlink = gui .. "icon-unlink.png",
        portal = gui .. "icon-portal.png",
    },
}


-- functions
defines.functions = {
    utils = defines.lib.functions .. "utils",
    player = defines.lib.functions .. "player",
    portal = defines.lib.functions .. "portal",
    teleporter = defines.lib.functions .. "teleporter",
    inventory = defines.lib.functions .. "inventory",
    surface = defines.lib.functions .. "surface",
    enemy = defines.lib.functions .. "enemy",
    gui = defines.lib.functions .. "gui",
    styles = defines.lib.functions .. "styles",
}


-- mods
defines.mods = {
    vanilla = {
        name = defines.lib.mods .. "vanilla/",
        lib = {},
    },
    spaceblock = defines.lib.mods .."spaceblock",
    seablock = defines.lib.mods .."seablock",
}
-- vanilla
defines.mods.vanilla.lib = {
    CrashSite = defines.mods.vanilla.name .. "crash-site",
    util = defines.mods.vanilla.name .. "util",
}


-- Gui
defines.gui = {}
defines.gui.styles = defines.lib.gui .. "styles"
defines.gui.luaStyle = defines.lib.gui .. "LuaStyle"

defines.gui.portal = {
    action = defines.lib.gui .. "portal/action",
    GuiElements = defines.lib.gui .. "portal/GuiElements",
}
defines.gui.teleporter = {
    action = defines.lib.gui .. "teleporter/action",
    GuiElements = defines.lib.gui .. "teleporter/GuiElements",
}
defines.gui.remote = {
    --action = defines.lib.gui .. "teleporter-remote/action",
    GuiElements = defines.lib.gui .. "teleporter-remote/GuiElements",
}
defines.gui.menu = {
    action = defines.lib.gui .. "menu/action",
    GuiElements = defines.lib.gui .. "menu/GuiElements",
}
-- version of Event-Listener
defines.event_listener = core .. "event-listener"


-- Prefix.
defines.name_prefix = "ritnmods-"
defines.prefix = {
    name = "ritnmods-",
    enemy = "enemy~",
    lobby = "lobby~",
}

-- Name and value
defines.name = {}
defines.value = {}
-- slots value pour inventory.lua
defines.value.inventory_size = 65535
defines.value.portal_not_link = "~~~"


defines.name.customInput = {
    toggle_main_menu = defines.name_prefix .. "toggle-main-menu",
}


-- settings
defines.name.settings = {
    enable_main_button = defines.name_prefix .. "tp-toggle-main-button",
    generate_seed = defines.name_prefix .. "tp-generate-seed",
    command_tp = defines.name_prefix .. "tp-command-tp",
    teleporter_enable = defines.name_prefix .. "tp-teleporter-enable",
    restart = defines.name_prefix .. "tp-restart",
    clean = defines.name_prefix .. "tp-clean",
    surfaceMax = defines.name_prefix .. "tp-surface-max",
    enemy = defines.name_prefix .. "tp-enemy-enable",
    show_research = defines.name_prefix .. "tp-show-research",
}

defines.value.settings = {
    enable_main_button = true,
    show_research = true,
    generate_seed = false,
    command_tp = false,
    teleporter_enable = true,
    restart = false,
    clean = {
        default_value = 0,
        minimum_value = 0,
        maximum_value = 1500,
    },
    surfaceMax = {
        default_value = 10,
        minimum_value = 1,
        maximum_value = 30,
    },
    enemy = true,
}
-- entity
defines.name.entity = {
    portal = "ritn-portal",
    teleporter = "ritn-teleporter",
}
-- item
defines.name.item = {
    portal = "ritn-portal",
    teleporter = "ritn-teleporter",
    remote = "ritn-teleporter-remote",
}
-- item group
defines.name.item_group = {
    teleport = "logistics",
}
-- item subgroup
defines.name.item_subgroups = {
    teleport = "teleportation",
}
-- recipe
defines.name.recipe = {
    portal = "recipe-ritn-portal",
    teleporter = "recipe-ritn-teleporter",
    remote = "recipe-ritn-teleporter-remote",
}
-- technology
defines.name.technology = {
    teleport = "tech-ritn-teleportation",
}
-- sprite
defines.name.sprite = {
    close = "sprite-close",
    link = "sprite-link",
    unlink = "sprite-unlink",
    portal = "sprite-portal",
}

-- GUI elements names
defines.name.gui = {

    -- GUI PORTAL
    main_portal = "portal-gui",
    panel_dialog = "panel-dialog",

    MainFlow = "Main-Flow",
    DialogFlow = "Dialog-Flow",

    LabelLink = "label-link",
    button_link = "button-link",
    button_unlink = "button-unlink",
    

    ListFlow = "List-Flow",
    list = "surfaces-list",

    -- GUI TELEPORTER
    NamerMain = "teleport-namer",
    TextNamer = "TextNamer",

    -- GUI REMOTE
    main_remote = "teleporter-gui",
    NameList = "name-list",
    button_teleport = "button-teleport",

    -- GUI MENU
    menu = {},

    -- COMMONS GUI
    panel_main = "panel-main",
    SurfacesFlow = "Surfaces-Flow",
    ButtonFlow = "Button-Flow",

    Infos = "infos",
    Pane = "pane",
    
    button_close = "button-close",
    button_back = "button-back",
    button_valid = "button-valid",

    styles = {},
    prefix = {
        portal = "portal-",
        teleporter = "teleporter-",
        remote = "remote-",
        menu = "menu-",
        main_menu = "main_menu-",
        surfaces_menu = "surfaces_menu-",
        restart = "restart-",
    },
    
}

-- GUI MENU elements names
defines.name.gui.menu = {

    button_main = "ritn-button-main",

    frame_menu = "frame-menu",
    frame_surfaces = "frame-surfaces",
    frame_restart = "frame-restart",

    flow_common = "flow-common",
    flow_restart = "flow-restart",
    flow_admin = "flow-admin",
    flow_label = "flow-label",

    panel_tp = "panel_tp",
    panel_clean = "panel_clean",

    label_admin = "label-admin",
    label_warning1 = "label-warning1",
    label_warning2 = "label-warning2",

    button_restart = "button-restart",
    button_tp = "button-tp",
    button_clean = "button-clean",
    button_close = "button-close",
    button_valid = "button-valid",
    button_cancel = "button-cancel",

}

defines.name.gui.styles = {

    open_button = "entity_open_button",
    button_main =  "style_button_main",

    ritn_normal_sprite_button = "ritn_normal_sprite_button",
    ritn_red_sprite_button = "ritn_red_sprite_button",
    ritn_main_sprite_button = "ritn_main_sprite_button",

    ritn_small_button = "ritn_small_button",
    ritn_normal_button = "ritn_normal_button",
    ritn_red_button = "ritn_red_button",
    ritn_valid_button = "ritn_valid_button",
    ritn_frame_style = "ritn_frame_style",
    ritn_flow_no_padding = "ritn_flow_no_padding",
    ritn_flow_panel_main = "ritn_flow_panel_main",
    ritn_flow_surfaces = "ritn_flow_surfaces",
    ritn_flow_dialog = "ritn_flow_dialog",
    ritn_remote_listbox = "ritn_remote_listbox",
    ritn_scroll_pane = "ritn_scroll_pane",
    ritn_label = "ritn_label",
    
}



-- GUI element captions.
defines.name.caption = {
    frame_portal = {
        button_tp = {"frame-portal.tp-button"},
        button_link = {"frame-portal.link-button"},
        button_unlink = {"frame-portal.unlink-button"},
        button_close = {"frame-portal.close-button"},
        button_back = {"frame-portal.back-button"},
        button_valid = {"frame-portal.valid-button"},
    },

    msg = {
        serveur_full = {"msg.too-mush-player-kick"},        
        not_link = {"msg.not-link"},
        no_surface = {"msg.no-surfaces"},
        no_select = {"msg.no-selected"},
        dest_not_find = {"msg.dest-not-find"},
        no_access = {"msg.no-access"},
        local_party = {"msg.local"},
        restart = {"msg.restart"},
        cursor = {"msg.cursor"},
        show_research = "msg.show-research",
    },

    frame_teleporter = {
        button_teleport = {"frame-teleporter.teleport-button"},
    },

    frame_menu = {
        titre = {"frame-menu.titre"},
        button_restart = {"frame-menu.button-restart"},
        label_admin = {"frame-menu.label-admin"},
        button_tp= {"frame-menu.button-tp"},
        button_clean = {"frame-menu.button-clean"},
    },

    frame_surfaces = {
        button_close = {"frame-surfaces.button-close"},
        button_valid = {"frame-surfaces.button-valid"},
    },

    frame_restart = {
        titre = {"frame-restart.titre"}, 
        label_warning1 = {"frame-restart.label-warning1"}, 
        label_warning2 = {"frame-restart.label-warning2"}, 
        button_cancel = {"frame-restart.button-cancel"}, 
        button_valid = {"frame-restart.button-valid"}, 
    }
}


----------------
return defines