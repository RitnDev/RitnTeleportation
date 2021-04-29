
-- test (debug)
if test == true then
    local tech = data.raw.technology[ritnmods.teleport.defines.name.technology.teleport]
    tech.hidden = false
    tech.enabled = true

    local recipe = data.raw.recipe[ritnmods.teleport.defines.name.recipe.teleporter]
    recipe.enabled = true
    recipe.ingredients = {}
    recipe.energy_required = 0.5

    recipe = data.raw.recipe[ritnmods.teleport.defines.name.recipe.remote]
    recipe.enabled = true
    recipe.ingredients = {}

    recipe = data.raw.recipe[ritnmods.teleport.defines.name.recipe.portal]
    recipe.enabled = true
    recipe.ingredients = {}
    recipe.energy_required = 0.5

    
    data.raw["rocket-silo"]["rocket-silo"].rocket_parts_required = 1
    data.raw.recipe["rocket-part"].ingredients = {{"iron-ore", 1}}
    energy_required = 0.5
    
end