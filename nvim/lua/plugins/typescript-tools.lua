return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		root_dir = function(fname)
			local util = require("lspconfig").util
			if util.root_pattern("deno.json")(fname) then
				return nil
			end

			return util.root_pattern("package.json")(fname)
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
