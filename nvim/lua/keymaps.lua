-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Bunch of things b/c I am too old to change now
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-s>", ":w<cr>", { desc = "old school save", silent = true })
vim.keymap.set("n", "<C-q>", ":q<cr>", { desc = "old school quit", silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<cr>", { desc = "old school save", silent = true })
vim.keymap.set("n", "<leader>w", ":w<cr>", { desc = "save file", silent = true })
vim.keymap.set("n", "<leader>x", ":bd<cr>", { desc = "close current buffer", silent = true })
vim.keymap.set("n", "<leader>ba", ":%bd!<cr>", { desc = "delete all buffers", silent = true })
vim.keymap.set("i", "jj", "<Esc>", { desc = "exit back to normal mode" })
vim.keymap.set("n", "4", "$", { desc = "lazy skip to end of line" })
vim.keymap.set("n", "<leader>ne", ":e ~/dotfiles/nvim/init.lua<cr>", { desc = "edit nvim config" })

vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<c-f>"
	end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<c-b>"
	end
end, { silent = true, expr = true })
