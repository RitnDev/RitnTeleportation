data:extend({


{
    --ritn-portal
      type = "technology",
      name = ritnmods.teleport.defines.name.technology.teleport,
      icon = ritnmods.teleport.defines.mod_directory .. "/graphics/technology/teleporter-64.png",
      icon_size = 64,
      hidden = true,
      enabled = false,
      effects = {
        {type = "unlock-recipe", recipe = ritnmods.teleport.defines.name.recipe.teleporter },
        {type = "unlock-recipe", recipe = ritnmods.teleport.defines.name.recipe.remote },
      },
      prerequisites = {"electric-energy-accumulators", "advanced-electronics"},
      unit = {
        count = 500,
        ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"chemical-science-pack", 1}
        },
        time = 60
      },
      order="b-a-a"
}


})
