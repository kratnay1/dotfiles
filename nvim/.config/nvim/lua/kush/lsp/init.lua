local imap = require("kush.keymap").imap
local nmap = require("kush.keymap").nmap

local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
  return
end

local is_mac = vim.fn.has "macunix" == 1

local lspconfig_util = require "lspconfig.util"

local ok, nvim_status = pcall(require, "lsp-status")
if not ok then
  nvim_status = nil
end

local telescope_mapper = require "kush.telescope.mappings"

local ts_util = require "nvim-lsp-ts-utils"

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local augroup_format = vim.api.nvim_create_augroup("my_lsp_format", { clear = true })
local autocmd_format = function(async, filter)
  vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format { async = async, filter = filter }
    end,
  })
end

local filetype_attach = setmetatable({
	-- python = function()
	-- 	autocmd_format(false)
	-- end,

  go = function()
    autocmd_format(false)
  end,

	-- html = function()
	-- 	autocmd_format(false)
	-- end,

  scss = function()
    autocmd_format(false)
  end,

  css = function()
    autocmd_format(false)
  end,

  rust = function()
    telescope_mapper("<space>wf", "lsp_workspace_symbols", {
      ignore_filename = true,
      query = "#",
    }, true)

    autocmd_format(false)
  end,

  typescript = function()
    autocmd_format(false, function(clients)
      return vim.tbl_filter(function(client)
        return client.name ~= "tsserver"
      end, clients)
    end)
  end,
}, {
  __index = function()
    return function() end
  end,
})

local buf_nnoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0

  nmap(opts)
end

local buf_inoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0

  imap(opts)
end

local custom_attach = function(client)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  if nvim_status then
    nvim_status.on_attach(client)
  end

  buf_inoremap { "<c-s>", vim.lsp.buf.signature_help }

  buf_nnoremap { "<space>cr", vim.lsp.buf.rename }
  buf_nnoremap { "<space>ca", vim.lsp.buf.code_action }

  buf_nnoremap { "gd", vim.lsp.buf.definition }
  buf_nnoremap { "gD", vim.lsp.buf.declaration }
  buf_nnoremap { "gt", vim.lsp.buf.type_definition }
	buf_nnoremap { "gi", vim.lsp.buf.implementation }

  buf_nnoremap { "<space>lr", "<cmd>lua R('kush.lsp.codelens').run()<CR>" }
  buf_nnoremap { "<space>rr", "LspRestart" }

  telescope_mapper("gr", "lsp_references", nil, true)
  telescope_mapper("<space>gi", "lsp_implementations", nil, true)
  telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
  telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)

  if filetype ~= "lua" then
    buf_nnoremap { "K", vim.lsp.buf.hover, { desc = "lsp:hover" } }
  end

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_exec([[
			hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=#404040
			hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=#404040
			hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=#404040
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
  end

  if client.server_capabilities.codeLensProvider then
		vim.cmd [[
		augroup lsp_document_codelens
		au! * <buffer>
		autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
		autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
		augroup END
		]]
  end

  -- Attach any filetype specific options to the client
  filetype_attach[filetype](client)
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
-- if nvim_status then
--   updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
-- end
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
-- TODO: uncomment after cmp set up
-- updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

-- TODO: check if this is the problem.
-- updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

-- vim.lsp.buf_request(0, "textDocument/codeLens", { textDocument = vim.lsp.util.make_text_document_params() })

local servers = {
	bashls = true,
	dockerls = true,
  gdscript = true,
  html = true,
  pyright = true,
  vimls = true,
  yamlls = true,
  eslint = true,

  cmake = (1 == vim.fn.executable "cmake-language-server"),

  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
    -- Required for lsp-status
    init_options = {
      clangdFileStatus = true,
    },
    handlers = nvim_status and nvim_status.extensions.clangd.setup() or nil,
  },

  gopls = {
    root_dir = function(fname)
      local Path = require "plenary.path"

      local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
      local absolute_fname = Path:new(fname):absolute()

      if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
        return absolute_cwd
      end

      return lspconfig_util.root_pattern("go.mod", ".git")(fname)
    end,

    settings = {
      gopls = {
        codelenses = { test = true },
      },
    },

    flags = {
      debounce_text_changes = 200,
    },
  },

  omnisharp = {
    cmd = { vim.fn.expand "~/build/omnisharp/run", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  },

  -- rust_analyzer = {
  --   cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  -- },
	rust_analyzer = true,

  elmls = true,
  cssls = true,

  tsserver = {
    init_options = ts_util.init_options,
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },

    on_attach = function(client)
      custom_attach(client)

      ts_util.setup { auto_inlay_hints = false }
      ts_util.setup_client(client)
    end,
  },
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

if is_mac then
  local sumneko_cmd, sumneko_env = nil, nil
  require("nvim-lsp-installer").setup {
    automatic_installation = false,
    ensure_installed = { "sumneko_lua" },
  }

  sumneko_cmd = {
    vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server",
  }

  local process = require "nvim-lsp-installer.core.process"
  local path = require "nvim-lsp-installer.core.path"

  sumneko_env = {
    cmd_env = {
      PATH = process.extend_path {
        path.concat { vim.fn.stdpath "data", "lsp_servers", "sumneko_lua", "extension", "server", "bin" },
      },
    },
  }

  setup_server("sumneko_lua", {
    settings = {
      Lua = {
      --   diagnostics = {
      --     globals = {
      --       -- Colorbuddy
      --       "Color",
      --       "c",
      --       "Group",
      --       "g",
      --       "s",

      --       -- Custom
      --       "RELOAD",
      --     },
      --   },

        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  })
else
  -- Load lua configuration from nlua.
  _ = require("nlua.lsp.nvim").setup(lspconfig, {
    cmd = sumneko_cmd,
    cmd_env = sumneko_env,
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,

    root_dir = function(fname)
      return lspconfig_util.find_git_ancestor(fname) or lspconfig_util.path.dirname(fname)
    end,
  })
end

local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- vim.cmd("hi DiagnosticError guifg=#995977") 
vim.cmd("hi DiagnosticError guifg=#b8497d") 
-- vim.cmd("hi DiagnosticWarn guifg=#a69883") 
vim.cmd("hi DiagnosticWarn guifg=#b89e77") 
vim.cmd("hi DiagnosticHint guifg=#909090") 
vim.cmd("hi DiagnosticInfo guifg=#909090") 

return {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
}
