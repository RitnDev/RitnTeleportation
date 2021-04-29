data:extend({

    {
        --item
        type = "tool",
        name = ritnmods.teleport.defines.name.item.remote,
        icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/teleporter-remote.png",
        icon_size = 64, icon_mipmaps = 4,
        stack_size = 1,
        durability = 10,
        subgroup = ritnmods.teleport.defines.name.item_subgroups.teleport,
        order = "aaa[items]-aa[".. ritnmods.teleport.defines.name.item.remote .."]",
    },
    {
        --recipe
        type = "recipe",
        name = ritnmods.teleport.defines.name.recipe.remote,
        icon = ritnmods.teleport.defines.mod_directory .. "/graphics/icons/teleporter-remote.png",
        icon_size = 64, icon_mipmaps = 4,
        energy_required = 1,
        enabled = false,
        ingredients =
        {
            {type="item", name="radar", amount=1},
            {type="item", name="iron-plate", amount=2},
        },
        result = ritnmods.teleport.defines.name.item.remote,
        result_count = 1
    }


})


