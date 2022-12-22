-- automatically install packer on any machine I clone my config to
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

vim.cmd [[packadd packer.nvim]]

local has = function(x)
	return vim.fn.has(x) == 1
end

local is_mac = has "macunix"

return require("packer").startup(function(use)
	-- let packer manage itself
	use "wbthomason/packer.nvim"

	-- Telescope 
	use { "nvim-lua/plenary.nvim" }
	use { "nvim-telescope/telescope.nvim" }

	-- Telescope extensions
	use { "nvim-telescope/telescope-fzf-writer.nvim" }
	use { "nvim-telescope/telescope-packer.nvim" }
	use { "nvim-telescope/telescope-fzy-native.nvim" }
	use { "nvim-telescope/telescope-github.nvim" }
	use { "nvim-telescope/telescope-symbols.nvim" }
	use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
	use { "nvim-telescope/telescope-file-browser.nvim" }
	use { "nvim-telescope/telescope-ui-select.nvim" }
	-- clipboard manager that integrates with telescope
	use {
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("neoclip").setup()
		end,
	}
	if not is_mac then
		use "nvim-telescope/telescope-cheat.nvim"
		use { "nvim-telescope/telescope-arecibo.nvim", rocks = { "openssl", "lua-http-parser" } }
	end

	-- LSP
	use "neovim/nvim-lspconfig"
	use "j-hui/fidget.nvim"
	use "nvim-lua/lsp_extensions.nvim"
	use "onsails/lspkind-nvim"
	use "jose-elias-alvarez/nvim-lsp-ts-utils"
	use "simrat39/rust-tools.nvim"
	use "tjdevries/nlua.nvim"
	use {
		"folke/lsp-trouble.nvim",
		cmd = "Trouble",
		config = function()
			-- Can use P to toggle auto movement
			require("trouble").setup {
				auto_preview = false,
				auto_fold = true,
			}
		end,
	}
	use {
		"ericpubu/lsp_codelens_extensions.nvim",
		config = function()
			require("codelens_extensions").setup()
		end,
	}

	-- Completion
	-- Sources
	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-nvim-lua"
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-nvim-lsp-document-symbol"
	use "saadparwaiz1/cmp_luasnip"
	-- Comparators
	use "lukas-reineke/cmp-under-comparator"
	-- Extras
	use "tjdevries/complextras.nvim" 

	-- treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate"
	}

	-- fzf
	use { "junegunn/fzf", run = "./install --all" }
	use { "junegunn/fzf.vim" }

	-- font icons 
	use "kyazdani42/nvim-web-devicons"

	-- bufferline 
	use { "akinsho/bufferline.nvim", tag = "v2.*" }

	-- easily delete, change, and add common surroundings in pairs
	use "tpope/vim-surround"

	-- comment with gcc, gc + motion
	use "tpope/vim-commentary"

	-- navigate seamlessly between vim splits and tmux panes 
	use "christoomey/vim-tmux-navigator"

	-- embed vim statusline in tmux statusline
	use "vimpostor/vim-tpipeline"

	-- adds a git gutter to indicate modified lines
	use "airblade/vim-gitgutter"

	-- simple folding for python
	use "tmhedberg/SimpylFold"

	-- only update folds on save or when toggling or moving between folds
	use "Konfekt/FastFold"

	-- pasting with indentation adjusted to destination context
	use "sickill/vim-pasta"

	-- syntax highlighting for TOML
	use "cespare/vim-toml"

	-- syntax highlighting for javascript
	use "yuezk/vim-js"

	-- syntax highlighting and indenting for React (jsx, tsx)
	use "maxmellon/vim-jsx-pretty"

	if packer_bootstrap then
		require("packer").sync()
	end
end)
