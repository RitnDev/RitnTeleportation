-------------------------------------------------------------------------------
                                -- FUNCTIONS
-------------------------------------------------------------------------------

-- return sprite for sprite button
local function sprite_button(name, file_name)
	return {
		type = "sprite",
		name = name,
		filename = file_name,
		width = 32,
		height = 32,
		flags = {"gui-icon"},
		mipmap_count = 1,
	}
end



-------------------------------------------------------------------------------

                                --------------
                                --  STYLES  --
                                --------------

-------------------------------------------------------------------------------

---
-- Style : BUTTON MAIN
---

local default_style = data.raw["gui-style"].default

default_style[ritnmods.teleport.defines.name.gui.styles.ritn_normal_sprite_button] = {
	type = "button_style",
	parent = "button",
	padding = 0,
	size = {32,32},
}

default_style[ritnmods.teleport.defines.name.gui.styles.ritn_red_sprite_button] = {
	type = "button_style",
	parent = "red_button",
	padding = 0,
	size = {32,32},
}

default_style[ritnmods.teleport.defines.name.gui.styles.ritn_main_sprite_button] = {
	type = "button_style",
	parent = "button",
	padding = 0,
	size = {40,40},
}



-- SPRITES
data:extend({
	sprite_button(
		ritnmods.teleport.defines.name.sprite.close,
		ritnmods.teleport.defines.graphics.gui.close
	),
	sprite_button(
		ritnmods.teleport.defines.name.sprite.link,
		ritnmods.teleport.defines.graphics.gui.link
	),
	sprite_button(
		ritnmods.teleport.defines.name.sprite.unlink,
		ritnmods.teleport.defines.graphics.gui.unlink
	),
	sprite_button(
		ritnmods.teleport.defines.name.sprite.portal,
		ritnmods.teleport.defines.graphics.gui.portal
	),

	

	
	-- FONTS
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.defaut12,
		from = "default",
		size = 12
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.defaut14,
		from = "default",
		size = 14
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.defaut16,
		from = "default",
		size = 16
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.defaut18,
		from = "default",
		size = 18
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.defaut20,
		from = "default",
		size = 20
	},
	--bold
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.bold12,
		from = "default-bold",
		size = 12
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.bold14,
		from = "default-bold",
		size = 14
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.bold16,
		from = "default-bold",
		size = 16
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.bold18,
		from = "default-bold",
		size = 18
	},
	{
		type = "font",
		name = ritnmods.teleport.defines.name.gui.styles.font.bold20,
		from = "default-bold",
		size = 20
	},


})