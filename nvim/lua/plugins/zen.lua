return {
	"folke/zen-mode.nvim",
	opts = {
		plugins = {
			tmux = { enabled = true }, -- disables the tmux statusline
			alacritty = {
				enabled = true,
				font = "18", -- font size
			},
		},
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
