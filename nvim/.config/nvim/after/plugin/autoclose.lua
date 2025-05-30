if not pcall(require, "autoclose") then
	return
end

require("autoclose").setup({
	options = {
		disable_when_touch = true,
		disabled_filetypes = { "text", "markdown", "TelescopePrompt", "vim" }
	},
})
