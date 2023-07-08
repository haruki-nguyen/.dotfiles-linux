---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "catppuccin",
	theme_toggle = { "catppuccin", "one_light" },

	hl_override = highlights.override,
	hl_add = highlights.add,

	cmp = {
		style = "flat_dark",
	},

	nvdash = {
		load_on_startup = true,
		buttons = {
			{ "󰦛  Restore last session", "Spc r s", "SessionRestore" },
			{ "  Find File", "Spc f f", "Telescope find_files" },
			{ "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
			{ "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
			{ "  Bookmarks", "Spc m a", "Telescope marks" },
		},
	},

	cheatsheet = { theme = "simple" },
}

M.plugins = "custom.plugins"

M.mappings = require("custom.mappings")

return M
