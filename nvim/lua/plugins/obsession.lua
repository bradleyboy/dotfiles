-- Autosave session state so tmux-resurrect can reopen it after a devbox
-- suspension (see @resurrect-strategy-nvim in ~/dotfiles/.tmux.conf)
return {
	"tpope/vim-obsession",
	config = function()
		-- Deferred to VimEnter: starting Obsession during plugin setup runs
		-- mksession! immediately, which would clobber an existing Session.vim
		-- before `nvim -S` (which runs after plugin setup) can source it.
		-- When a session was loaded (v:this_session is set), obsession has
		-- already resumed tracking it, so don't start a fresh one.
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 and vim.v.this_session == "" then
					vim.cmd("Obsession")
				end
			end,
		})
	end,
}
