return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()

			vim.keymap.set("n", "<C-c>", "<plug>(comment_toggle_linewise_current)", { desc = "comment current line" })
			vim.keymap.set("v", "<C-c>", "<plug>(comment_toggle_linewise_visual)", { desc = "comment current line(s)" })
		end,
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false, highlight = {
			pattern = [[.*<(KEYWORDS)\s*]],
			keyword = "bg",
		} },
	},
}
