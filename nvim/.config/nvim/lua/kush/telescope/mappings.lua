if not pcall(require, "telescope") then
  return
end

local sorters = require "telescope.sorters"

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = "n"
  local rhs = string.format("<cmd>lua R('kush.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)

  local map_options = {
    noremap = true,
    silent = true,
  }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })

-- Dotfiles
map_tele("<space>en", "edit_neovim")

-- Files
map_tele("<c-g>", "project_files")
map_tele("<c-q>", "buffers")
map_tele("<space>fb", "file_browser")
map_tele("<space>fa", "search_all_files")

-- Git
map_tele("<space>gs", "git_status")
map_tele("<space>gc", "git_commits")

return map_tele
