
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Don't show the matching stuff.
vim.opt.shortmess:append "c"

-- Complextras.nvim configuration
vim.api.nvim_set_keymap(
  "i",
  "<C-x><C-m>",
  [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-x><C-d>",
  [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
  { noremap = true }
)

local ok, lspkind = pcall(require, "lspkind")
if not ok then
  return
end

lspkind.init()

local cmp = require "cmp"

cmp.setup {
	mapping = {
    ["<c-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<c-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
		["<c-space>"] = cmp.mapping.confirm({ select = true}),
    ["<c-d>"] = cmp.mapping.scroll_docs(-4),
    ["<c-f>"] = cmp.mapping.scroll_docs(4),
    ["<c-e>"] = cmp.mapping.abort(),

    -- ["<c-y>"] = cmp.mapping(
    --   cmp.mapping.confirm {
    --     behavior = cmp.ConfirmBehavior.Insert,
    --     select = true,
    --   },
    --   { "i", "c" }
    -- ),

    -- ["<c-space>"] = cmp.mapping {
    --   i = cmp.mapping.complete(),
    --   c = function(
    --     _ --[[fallback]]
    --   )
    --     if cmp.visible() then
    --       if not cmp.confirm { select = true } then
    --         return
    --       end
    --     else
    --       cmp.complete()
    --     end
    --   end,
    -- },

    ["<tab>"] = cmp.config.disable,

  },

  -- The order of your sources matter (by default). That gives them priority
  -- you can configure:
  --     keyword_length
  --     priority
  --     max_item_count
  --     (more?)
  sources = {
    -- Could enable this only for lua, but nvim_lua handles that already.
    { name = "nvim_lua" },

    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 5 },
  },

  sorting = {
    -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        luasnip = "[snip]",
      },
    },
  },

  experimental = {
    native_menu = false,

    ghost_text = false,
  },
}

-- nvim-cmp highlights 
vim.cmd("hi link CmpItemKind Identifier")

-- Group.new("CmpItemAbbr", g.Comment)
-- Group.new("CmpItemAbbrDeprecated", g.Error)
-- Group.new("CmpItemAbbrMatchFuzzy", g.CmpItemAbbr.fg:dark(), nil, s.italic)
-- Group.new("CmpItemKind", g.Special)
-- Group.new("CmpItemMenu", g.NonText)
