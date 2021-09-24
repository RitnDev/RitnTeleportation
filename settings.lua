--INITIALIZE
if not ritnmods then ritnmods = {} end
if not ritnmods.teleport then ritnmods.teleport = {
    defines = require("defines")
} end

data:extend {

	{
		-- Activation du bouton menu
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.enable_main_button,
		setting_type = "runtime-per-user",
		default_value = ritnmods.teleport.defines.value.settings.enable_main_button,
		order = ritnmods.teleport.defines.name_prefix .. "tp-01"
	},
	{
		-- Activation du bouton menu
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.show_research,
		setting_type = "runtime-per-user",
		default_value = ritnmods.teleport.defines.value.settings.show_research,
		order = ritnmods.teleport.defines.name_prefix .. "tp-02"
	},

	{
		-- Même map pour tous ?
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.generate_seed,
		setting_type = "startup",
		default_value = ritnmods.teleport.defines.value.settings.generate_seed,
		order = ritnmods.teleport.defines.name_prefix .. "tp-01"
	},
	--[[
	{
		-- Autorisation de la commande tp
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.command_tp,
		setting_type = "startup",
		default_value = ritnmods.teleport.defines.value.settings.command_tp,
		order = ritnmods.teleport.defines.name_prefix .. "tp-02"
	},]]
	{
		-- Activation des téléporteurs
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.teleporter_enable,
		setting_type = "startup",
		default_value = ritnmods.teleport.defines.value.settings.teleporter_enable,
		order = ritnmods.teleport.defines.name_prefix .. "tp-03"
	},
	{
		-- Activation des équipes ennemies
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.restart,
		setting_type = "startup",
		default_value = ritnmods.teleport.defines.value.settings.restart,
		order = ritnmods.teleport.defines.name_prefix .. "tp-04"
	},
	{
		-- Void requester chest size.
		type = "int-setting",
		name = ritnmods.teleport.defines.name.settings.clean,
		setting_type = "runtime-global",
		default_value = ritnmods.teleport.defines.value.settings.clean.default_value,
		minimum_value = ritnmods.teleport.defines.value.settings.clean.minimum_value,
		maximum_value = ritnmods.teleport.defines.value.settings.clean.maximum_value,
		order = ritnmods.teleport.defines.name_prefix .. "tp-05"
	},
	{
		-- Activation des équipes ennemies
		type = "bool-setting",
		name = ritnmods.teleport.defines.name.settings.enemy,
		setting_type = "startup",
		default_value = ritnmods.teleport.defines.value.settings.enemy,
		order = ritnmods.teleport.defines.name_prefix .. "tp-06"
	},

}