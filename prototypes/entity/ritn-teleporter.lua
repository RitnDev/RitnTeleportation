  --ritn_teleporter

  data:extend({

    {
      type = "container",
      name = ritnmods.teleport.defines.name.entity.teleporter,
      icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/teleporter-64.png",
      icon_size = 64,
      flags = {"placeable-neutral", "placeable-player", "player-creation", "not-blueprintable", "not-deconstructable", "not-flammable", "not-rotatable"},
      minable = {hardness = 0.2, mining_time = 0.5, result = ritnmods.teleport.defines.name.item.teleporter},
      max_health = 10000,
      inventory_size = 0,
      corpse = "lamp-remnants",
      collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
      collision_mask = {"item-layer", "object-layer", "water-tile"},
      selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
      vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
      opening_sound = { filename = ritnmods.teleport.defines.mod_directory .. "/sounds/none.ogg", volume = 0.5 },
      mining_sound = { filename = ritnmods.teleport.defines.mod_directory .. "/sounds/none.ogg", volume = 0.5 },
      build_sound = { filename = ritnmods.teleport.defines.mod_directory .. "/sounds/portal_open.ogg", volume = 0.5 },
      mined_sound = { filename = ritnmods.teleport.defines.mod_directory .. "/sounds/portal_close.ogg", volume = 0.5 },
      picture =
        {
          filename = ritnmods.teleport.defines.mod_directory .. "/graphics/entity/ritn-teleporter/ritn-teleporter.png",
          priority = "high",
          width = 110,
          height = 110,
        },
    }

})