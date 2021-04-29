data:extend({


    --Ritn Teleporter
    {
        --item
        type = "item",
        name = ritnmods.teleport.defines.name.item.teleporter,
        icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/teleporter-64.png",
        icon_size = 64,
        stack_size = 10,
        subgroup = ritnmods.teleport.defines.name.item_subgroups.teleport,
        order = "aaa[items]-a[".. ritnmods.teleport.defines.name.item.teleporter .."]",
        place_result = ritnmods.teleport.defines.name.entity.teleporter
    },
    {
        --recipe
        type = "recipe",
        name = ritnmods.teleport.defines.name.recipe.teleporter,
        icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/teleporter-64.png",
        icon_size = 64,
        energy_required = 5,
        enabled = false,
        ingredients =	{
			{"steel-plate", 100},
			{"copper-plate", 100},
			{"advanced-circuit", 100},
			{"accumulator", 100}
		},
        result = ritnmods.teleport.defines.name.item.teleporter,
        result_count = 1
    }


})