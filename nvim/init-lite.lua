vim.opt.runtimepath:prepend(vim.fn.stdpath("config"))
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/tokyonight.nvim")

require("basics")
require("keymaps")

require("tokyonight").setup({
	styles = {},
	dim_inactive = true,
	lualine_bold = true,
})
vim.cmd.colorscheme("tokyonight-storm")

local colors = require("tokyonight.colors").setup({ style = "storm" })
local black = colors.black

local mode_colors = {
	n = { bg = colors.blue, label = "NORMAL" },
	i = { bg = colors.green, label = "INSERT" },
	v = { bg = colors.magenta, label = "VISUAL" },
	V = { bg = colors.magenta, label = "V-LINE" },
	["\22"] = { bg = colors.magenta, label = "V-BLOCK" },
	R = { bg = colors.red, label = "REPLACE" },
	c = { bg = colors.yellow, label = "COMMAND" },
	t = { bg = colors.green1, label = "TERMINAL" },
	s = { bg = colors.magenta, label = "SELECT" },
	S = { bg = colors.magenta, label = "S-LINE" },
	["\19"] = { bg = colors.magenta, label = "S-BLOCK" },
}

local default_mode = { bg = colors.blue, label = "NORMAL" }

function LiteStatusline()
	local m = mode_colors[vim.fn.mode()] or default_mode
	local hl_name = "LiteMode_" .. m.label:gsub("-", "")
	if vim.fn.hlexists(hl_name) == 0 or vim.api.nvim_get_hl(0, { name = hl_name }).bg ~= tonumber(m.bg:sub(2), 16) then
		vim.api.nvim_set_hl(0, hl_name, { fg = black, bg = m.bg, bold = true })
	end
	return "%#" .. hl_name .. "# " .. m.label .. " %#StatusLine#"
end

vim.opt.statusline = "%!v:lua.LiteStatusline()"
vim.opt.laststatus = 2
