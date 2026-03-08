return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "tokyonight-storm",
				section_separators = "",
				component_separators = "",
			},
			extensions = { "neo-tree", "trouble", "mason", "lazy", "fzf" },
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "diff" },
				lualine_y = { "branch" },
				lualine_z = { "lsp_status" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
