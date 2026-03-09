return {
	"esmuellert/nvim-eslint",
	dependencies = { "neovim/nvim-lspconfig" },
	opts = {
		settings = {
			workingDirectory = function(bufnr)
				return { directory = vim.fs.root(bufnr, { "package.json" }) }
			end,
		},
	},
}
