local languages = {
	"bash",
	"c",
	"css",
	"diff",
	"html",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
}

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})
		require("nvim-treesitter").install(languages)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = languages,
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
