return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		root_dir = function(bufnr, on_dir)
			if vim.fs.root(bufnr, { "deno.json" }) then
				return
			end

			local root = vim.fs.root(bufnr, { "package.json" })
			if root then
				on_dir(root)
			end
		end,
		single_file_support = false,
		settings = {
			tsserver_max_memory = 8192,

			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,

				-- Ensure we always import from absolute paths
				importModuleSpecifierPreference = "non-relative",
			},
		},
	},
}
