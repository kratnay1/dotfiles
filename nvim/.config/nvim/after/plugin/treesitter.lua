if not pcall(require, "nvim-treesitter") then
  return
end

local _ = require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "go",
    "html",
		"css",
    "javascript",
    "json",
    "markdown",
    "python",
    "query",
    "rust",
    "toml",
    "tsx",
    "typescript",
		"yaml",
  },

  highlight = {
    enable = true,
    use_languagetree = false,
		additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
      node_incremental = "<M-w>", -- increment to the upper named parent
      node_decremental = "<M-C-w>", -- decrement to the previous node
      scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
    },
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true,

      goto_next_start = {
        ["]p"] = "@parameter.inner",
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[p"] = "@parameter.inner",
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },

    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",

        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",

        ["av"] = "@variable.outer",
        ["iv"] = "@variable.inner",
      },
    },

  },

}

