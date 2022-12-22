-- part of this config was taken from tjdevries

if not pcall(require, "telescope") then
	return
end

local actions = require "telescope.actions"
-- local action_state = require "telescope.actions.state"
local action_layout = require "telescope.actions.layout"


require('telescope').setup {
	defaults = {
		results_title = "",
		prompt_prefix = "> ",
		selection_caret = "> ",
		entry_prefix = "  ",
		multi_icon = "<>",

		layout_strategy = "horizontal",
		layout_config = {
			width = 0.95,
			height = 0.85,
			prompt_position = "top",

			horizontal = {
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					else
						return math.floor(cols * 0.6)
					end
				end,
			},

			vertical = {
				width = 0.9,
				height = 0.95,
				preview_height = 0.5,
			},

			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},

		selection_strategy = "reset",
		sorting_strategy = "ascending",
		scroll_strategy = "cycle",
		color_devicons = true,

		mappings = {
			i = {
				["<c-x>"] = false,
				["<c-s>"] = actions.select_horizontal,
				["<c-n>"] = "move_selection_next",

				["<c-d>"] = actions.results_scrolling_down,
				["<c-i>"] = actions.results_scrolling_up,

				-- These are new :)
				["<M-p>"] = action_layout.toggle_preview,
				-- ["<c-m>"] = action_layout.toggle_mirror,

				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				-- This is nicer when used with smart-history plugin.
				-- ["<C-k>"] = actions.cycle_history_next,
				-- ["<C-j>"] = actions.cycle_history_prev,
				-- ["<c-g>s"] = actions.select_all,
				-- ["<c-g>a"] = actions.add_selection,

				-- ["<esc>"] = actions.close,

				["<C-w>"] = function()
					vim.api.nvim_input "<c-s-w>"
				end,
			},

			n = {
				["<C-d>"] = actions.results_scrolling_down,
				["<C-i>"] = actions.results_scrolling_up,
			},
		},

		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

		-- history = {
		-- 	path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
		-- 	limit = 100,
		-- },
	},

	pickers = {
		fd = {
			mappings = {
				n = {
					["kj"] = "close",
				},
			},
		},

		git_branches = {
			mappings = {
				i = {
					["<C-a>"] = false,
				},
			},
		},
	},

	extensions = {
		fzy_native = {
			override_generic_sorter = true,
			override_file_sorter = true,
		},

		fzf_writer = {
			use_highlighter = false,
			minimum_grep_characters = 6,
		},

		["ui-select"] = {
			require("telescope.themes").get_dropdown {
				-- even more opts
			}
		},
	}
}

-- require("telescope").load_extension "dap"
-- require("telescope").load_extension "notify"
require("telescope").load_extension "file_browser"
require("telescope").load_extension "ui-select"
require("telescope").load_extension "fzf"
require("telescope").load_extension "neoclip"

-- pcall(require("telescope").load_extension, "smart_history")
-- pcall(require("telescope").load_extension, "frecency")
pcall(require("telescope").load_extension, "gh")

vim.cmd("hi link TelescopeMatching Identifier")
vim.cmd("hi link TelescopeBorder Comment")
vim.cmd("hi link TelescopeTitle TelescopeNormal")
