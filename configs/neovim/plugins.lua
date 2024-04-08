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
        event = "VeryLazy",
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

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("custom.configs.nvim-dap-ui")
    end,
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
