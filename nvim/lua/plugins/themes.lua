return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("tokyonight").setup({
				styles = {},
				dim_inactive = true,
				lualine_bold = true,
			})

			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight-storm")
		end,
	},

	-- {
	-- 	"marko-cerovac/material.nvim",
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("material").setup({
	-- 			styles = { -- Give comments style such as bold, italic, underline etc.
	-- 				comments = { italic = true },
	-- 			},
	-- 			plugins = { -- Uncomment the plugins that you use to highlight them
	-- 				-- Available plugins:
	-- 				-- "coc",
	-- 				-- "colorful-winsep",
	-- 				-- "dap",
	-- 				-- "dashboard",
	-- 				-- "eyeliner",
	-- 				"fidget",
	-- 				-- "flash",
	-- 				"gitsigns",
	-- 				-- "harpoon",
	-- 				-- "hop",
	-- 				-- "illuminate",
	-- 				-- "indent-blankline",
	-- 				-- "lspsaga",
	-- 				"mini",
	-- 				-- "neogit",
	-- 				-- "neotest",
	-- 				"neo-tree",
	-- 				-- "neorg",
	-- 				-- "noice",
	-- 				"nvim-cmp",
	-- 				-- "nvim-navic",
	-- 				-- "nvim-tree",
	-- 				"nvim-web-devicons",
	-- 				-- "rainbow-delimiters",
	-- 				-- "sneak",
	-- 				"telescope",
	-- 				-- "trouble",
	-- 				"which-key",
	-- 				-- "nvim-notify",
	-- 			},
	-- 			contrast = {
	-- 				floating_windows = true,
	-- 			},
	-- 			high_visibility = {
	-- 				darker = true,
	-- 			},
	-- 			-- lualine_style = "stealth",
	-- 		})
	--
	-- 		-- vim.cmd.colorscheme("material-darker")
	-- 	end,
	-- },
}
