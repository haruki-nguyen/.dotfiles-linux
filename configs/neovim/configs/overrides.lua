local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    -- Lua stuff
    "lua-language-server",
    "stylua",

    -- For C/C++ programming
    "clangd",
    "clang-format",

    -- Others
    "prettier",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
