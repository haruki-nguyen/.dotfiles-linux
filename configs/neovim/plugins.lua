local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	-- LSP, syntax highlighting, etc.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	-- UI
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Editing and moving
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		init = function()
			require("core.utils").load_mappings("autosession")
		end,
		config = function()
			require("custom.configs.autosession")
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"phaazon/hop.nvim",
		cmd = { "HopChar2MW" },
		init = function()
			require("core.utils").load_mappings("hop")
		end,
		config = function()
			require("hop").setup()
		end,
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeShow", "UndotreeToggle", "UndotreeFocus" },
		init = function()
			require("core.utils").load_mappings("undotree")
		end,
		config = function()
			vim.g.undotree_WindowLayout = 2
		end,
	},
}

return plugins
