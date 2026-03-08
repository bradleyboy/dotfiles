local sourcegraph = require("utils.sourcegraph")

-- 2. Create the user command
vim.api.nvim_create_user_command(
	-- The name of the command you will use, e.g., :SourceBrowserOpen
	"SourceGraphOpen",

	-- The Lua function to call
	sourcegraph.open_from_command,

	-- Command attributes. This is the crucial part!
	{
		-- This tells Neovim that the command can accept a range.
		-- If called from visual mode, it will automatically get the selection's range.
		-- If called from normal mode, the range will be the current line.
		range = true,
		desc = "Open current file/selection in Sourcegraph",
	}
)

-- 3. Set up the keymaps to use the new command
-- Use <Cmd> for a silent, non-recording command execution.

-- Normal mode keymap
vim.keymap.set("n", "<leader>sG", "<Cmd>SourceGraphOpen<CR>", {
	desc = "Open current line in source browser",
})

-- Visual mode keymap
vim.keymap.set("v", "<leader>sG", ":SourceGraphOpen<CR>gv", {
	desc = "Open selection in source browser",
})
