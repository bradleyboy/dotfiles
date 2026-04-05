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
