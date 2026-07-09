-- Autosave session state so tmux-resurrect can reopen it after a devbox
-- suspension (see @resurrect-strategy-nvim in ~/dotfiles/.tmux.conf)
return {
	"tpope/vim-obsession",
	config = function()
		if vim.fn.argc() == 0 then
			vim.cmd("Obsession")
		end
	end,
}
