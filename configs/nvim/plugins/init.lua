return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- format on save
		config = function()
			require("configs.conform")
		end,
	},

	-- LSP, mason, and treesitter
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"clangd",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
			},
		},
	},
}
