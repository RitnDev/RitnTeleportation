-- Si spaceblock est actif
if mods["spaceblock"] then
    data.raw.recipe["spaceblock-water"].icons={
        {
            icon = "__RitnTeleportation__/graphics/icons/waterfill.png",
            icon_size = 128, icon_mipmaps = 5,
        }
    }
    data.raw.item["spaceblock-water"].icons={
        {
            icon = "__RitnTeleportation__/graphics/icons/waterfill.png",
            icon_size = 128, icon_mipmaps = 5,
        }
    }
end

require("prototypes/incompatibility")



