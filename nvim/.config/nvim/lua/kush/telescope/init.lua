local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"

local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local _ = pcall(require, "nvim-nonicons")

local M = {}

function M.edit_neovim()
  local opts = {
		results_title = "",
		border_thickness = 0.1,
		sorting_strategy = "ascending",
		layout_strategy = "flex",
		layout_config = {
			width = 0.6,
			height = 0.7,

			prompt_position = "top",

			horizontal = {
				width = { padding = 0.15 },
			},
			vertical = {
				preview_height = 0.75,
			},
			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
		previewer = false,
    cwd = "~/.config/nvim",

    mappings = {
      i = {
        ["<C-y>"] = false,
      },
    },
  }
  require("telescope.builtin").find_files(opts)
end

function M.buffers()
	local opts = {
		results_title = "",
		layout_strategy = "flex",
		layout_config = {
			width = 0.6,
			height = 0.7,

			prompt_position = "top",

			horizontal = {
				width = { padding = 0.15 },
			},
			vertical = {
				preview_height = 0.75,
			},
			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},
		previewer = false,
	}
	require("telescope.builtin").buffers(opts)
end

function M.curbuf()
  local opts = themes.get_dropdown {
		results_title = "",
		layout_strategy = "flex",
		layout_config = {
			width = 0.6,
			height = 0.7,

			prompt_position = "top",

			horizontal = {
				width = { padding = 0.15 },
			},
			vertical = {
				preview_height = 0.75,
			},
			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},
  }
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.live_grep()
  require("telescope.builtin").live_grep {
		layout_config = {
			width = 0.6,
			height = 0.7,

			prompt_position = "top",

			horizontal = {
				width = { padding = 0.15 },
			},
			vertical = {
				preview_height = 0.75,
			},
			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},
    -- shorten_path = true,
    previewer = false,
    fzf_separator = "|>",
  }
end

function M.grep_last_search(opts)
  opts = opts or {}

  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

  opts.path_display = { "shorten" }
  opts.word_match = "-w"
  opts.search = register

  require("telescope.builtin").grep_string(opts)
end

-- git_files if it's a git dir, otherwise find_files
function M.project_files()
  local opts = {
		results_title = "",
		layout_strategy = "flex",
		layout_config = {
			width = 0.6,
			height = 0.7,

			prompt_position = "top",

			horizontal = {
				width = { padding = 0.15 },
			},
			vertical = {
				preview_height = 0.75,
			},
			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},
	}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

function M.help_tags()
  require("telescope.builtin").help_tags {
		results_title = "",
    show_version = true,
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
		results_title = "",
    find_command = { "rg", "--no-ignore", "--files" },
  }
end

function M.file_browser()
  local opts

  opts = {
		results_title = "",
    attach_mappings = function(prompt_bufnr, map)
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      local modify_cwd = function(new_cwd)
        local finder = current_picker.finder

        finder.path = new_cwd
        finder.files = true
        current_picker:refresh(false, { reset_prompt = true })
      end

      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)

      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)

      -- local modify_depth = function(mod)
      --   return function()
      --     opts.depth = opts.depth + mod
      --
      --     current_picker:refresh(false, { reset_prompt = true })
      --   end
      -- end
      --
      -- map("i", "<M-=>", modify_depth(1))
      -- map("i", "<M-+>", modify_depth(-1))

      map("n", "yy", function()
        local entry = action_state.get_selected_entry()
        vim.fn.setreg("+", entry.value)
      end)

      return true
    end,
  }

  require("telescope").extensions.file_browser.file_browser(opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
		results_title = "",
    border = true,
    previewer = false,
    shorten_path = false,
  }

  -- Can change the git icons using this.
  -- opts.git_icons = {
  --   changed = "M"
  -- }

  require("telescope.builtin").git_status(opts)
end

function M.git_commits()
  require("telescope.builtin").git_commits {
		results_title = "",
  }
end

return setmetatable({}, {
  __index = function(_, k)

    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
