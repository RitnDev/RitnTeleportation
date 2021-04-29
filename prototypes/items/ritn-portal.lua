data:extend({


    --Ritn Portal
    {
        --item
        type = "item",
        name = ritnmods.teleport.defines.name.item.portal,
        icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/portal-64.png",
        icon_size = 64,
        stack_size = 10,
        subgroup = ritnmods.teleport.defines.name.item_subgroups.teleport,
        order = "aaa[items]-a[".. ritnmods.teleport.defines.name.item.portal .."]",
        place_result = ritnmods.teleport.defines.name.entity.portal
    },
    {
        --recipe
        type = "recipe",
        name = ritnmods.teleport.defines.name.recipe.portal,
        icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/portal-64.png",
        icon_size = 64,
        energy_required = 10,
        enabled = true,
        ingredients =
        {
            {type="item", name="copper-cable", amount=20},
            {type="item", name="iron-stick", amount=6},
            {type="item", name="iron-chest", amount=6},
            {type="item", name="pipe", amount=4},
            {type="item", name="stone-brick", amount=4},
            {type="item", name="iron-plate", amount=10},
        },
        result = ritnmods.teleport.defines.name.item.portal,
        result_count = 1
    }


})