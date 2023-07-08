---@type MappingsTable
local M = {}

M.general = {
	n = {
		["<C-h>"] = { "<cmd> TmuxNavigateLeft <CR>", "Window left" },
		["<C-l>"] = { "<cmd> TmuxNavigateRight <CR>", "Window left" },
		["<C-j>"] = { "<cmd> TmuxNavigateDown <CR>", "Window left" },
		["<C-k>"] = { "<cmd> TmuxNavigateUp <CR>", "Window left" },
	},
}

M.autosession = {
	n = {
		["<leader>rs"] = { "<cmd> SessionRestore <CR>", "Restore last session" },
	},
}

M.hop = {
	n = {
		["<leader>j"] = { "<cmd> HopChar2MW <CR>", "Jump to chars" },
	},
	v = {
		["<leader>j"] = { "<cmd> HopChar2MW <CR>", "Jump to chars" },
	},
}

M.undotree = {
	n = {
		["<leader>us"] = { "<cmd> UndotreeShow <CR><C-w>h", "Show Undotree" },
		["<leader>ut"] = { "<cmd> UndotreeToggle <CR>", "Toggle Undotree" },
		["<leader>uf"] = { "<cmd> UndotreeFocus <CR>", "Focus Undotree" },
	},
}

return M
