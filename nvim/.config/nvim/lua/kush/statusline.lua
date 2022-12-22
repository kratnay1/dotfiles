local M = {}
local api, cmd, opt, diag = vim.api, vim.cmd, vim.opt, vim.diagnostic

local function get_hl_group_color(group, color)
	local group_table = api.nvim_get_hl_by_name(group, true)
	return string.format("#%06x", group_table[color])
end

local colors = {}
local function set_colors()
	colors = {
		bg_statusline = get_hl_group_color("StatusLine", "background"),
		fg_diagnostic_error = get_hl_group_color("DiagnosticError", "foreground"),
		fg_diagnostic_warn = get_hl_group_color("DiagnosticWarn", "foreground"),
		fg_diagnostic_info = get_hl_group_color("DiagnosticInfo", "foreground"),
		fg_comment = get_hl_group_color("Comment", "foreground"),
	}
end

set_colors()

local function get_git_branch()
	local branch = ""
	cmd("hi StrBranch cterm=bold guifg=" .. "#8e8e8e" .. " guibg=#393939")
	if vim.fn.isdirectory ".git" ~= 0 then
		branch = vim.fn.system("git branch --show-current | tr -d '\n'")
		return "%#StrBranch#" .. "| " .. " " .. branch .. "%* "
	end
	return "%#StrBranch#%*"
end

local function get_diagnostics()
	local errors = diag.get(0, { severity = diag.severity.ERROR })
	local warnings = diag.get(0, { severity = diag.severity.WARN })
	local hints_infos = diag.get(0, { severity = { min = diag.severity.HINT, max = diag.severity.INFO } })

	local error_group, warnings_group, hints_and_info_group = "%#StrErr#", "%#StrWarning#", "%#StrInfo#"
	local err, warn, info = "", "", ""

	cmd("hi StrErr cterm=bold guifg=" .. "#8e8e8e" .. " guibg=" .. colors.bg_statusline)
	cmd("hi StrWarning cterm=bold guifg=" .. "#8e8e8e" .. " guibg=" .. colors.bg_statusline)
	cmd("hi StrInfo cterm=bold guifg=" .. "#8e8e8e" .. " guibg=" .. colors.bg_statusline)

	if #errors > 0 then
		cmd("hi StrErr cterm=bold guifg=" .. colors.fg_diagnostic_error .. " guibg=" .. colors.bg_statusline)
		-- error_group = "%#StrErr#"
		err = err .. " (" .. errors[1].lnum + 1 .. ")"
	end
	if #warnings > 0 then
		cmd("hi StrWarning cterm=bold guifg=" .. colors.fg_diagnostic_warn .. " guibg=" .. colors.bg_statusline)
		-- warnings_group = "%#StrWarning#"
		warn = warn .. " (" .. warnings[1].lnum + 1 .. ")"
	end
	if #hints_infos > 0 then
		cmd("hi StrInfo cterm=bold guifg=" .. colors.fg_diagnostic_info .. " guibg=" .. colors.bg_statusline)
		-- hints_and_info_group = "%#StrInfo#"
		info = info .. " (" .. hints_infos[1].lnum + 1 .. ")"
	end

	return error_group .. err .. "%* " .. warnings_group .. warn .. "%* " .. hints_and_info_group .. info .. "%*"
end

local function set_statusline_content()
	local persent_sign = "%%"
	cmd("hi StrRightSide cterm=bold guifg=" .. "#8e8e8e" .. " guibg=" .. colors.bg_statusline)
	local right_side = "%#StrRightSide#" .. string.format("%%p%s | %%Lℓ | ", persent_sign) .. "%*"

	local buffer_name = api.nvim_buf_get_name(0)
	local buffer_name_nvimtree = string.find(buffer_name, "NvimTree")
	local buffer_name_packer = string.match(buffer_name, "%[%w-%]$")
	local buffer_name_doc = string.find(buffer_name, "/doc/") and string.find(buffer_name, ".txt")
	local buffer_name_fugitive = string.find(buffer_name, ".git/index")
	local string_format = "%=%s%%="

	local content = ""
	if buffer_name_nvimtree then
		content = string.format(string_format, "NvimTree")
	elseif buffer_name_doc then
		content = string.format("%%=Help - %s%%=", string.match(buffer_name, "[%s%w_]-%.%w-$")) .. right_side
	elseif buffer_name_packer then
		content = string.format(string_format, "Packer")
	elseif buffer_name_fugitive then
		content = string.format(string_format, "Fugitive")
	else
		local diagnostics = string.format("%s%%=", get_diagnostics())
		local git_branch = get_git_branch()
		cmd("hi StrFilename cterm=bold guifg=" .. "#8e8e8e" .. " guibg=" .. colors.bg_statusline)
		local filename = "%#StrFilename#" .. "| %f | " .. "%*"
		content = diagnostics .. git_branch .. filename .. right_side
	end

	opt.statusline = content
end

local statusline_group = api.nvim_create_augroup("StatuslineGroup", {
	clear = true,
})

-- api.nvim_create_autocmd({
-- 	"OptionSet",
-- }, {
-- 	pattern = "background",
-- 	callback = set_colors,
-- 	group = statusline_group,
-- })

api.nvim_create_autocmd({
	"BufAdd",
	"BufEnter",
	"FocusGained",
	"ColorScheme",
}, {
	pattern = "*",
	callback = set_colors,
	group = statusline_group,
})

api.nvim_create_autocmd({
	"BufAdd",
	"BufEnter",
	"BufWritePost",
	"FocusGained",
	"ColorScheme",
	"DiagnosticChanged",
}, {
	pattern = "*",
	callback = set_statusline_content,
	group = statusline_group,
})

return M
