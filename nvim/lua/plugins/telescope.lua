-- Fuzzy Finder (files, lsp, etc)
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- annoyingly, enabling hidden also shows the git folder
			pickers = {
				find_files = { find_command = { "fd", "--type", "f", "--color", "never", "--hidden", "--exclude", ".git" } },
				live_grep = { additional_args = { "--hidden", "--glob", "!.git" } },
				grep_string = { additional_args = { "--hidden", "--glob", "!.git" } },
				lsp_references = {
					show_line = false,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<C-e>", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- conflicts with hover doc scrolling
		-- vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "//", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find({
				layout_strategy = "vertical",
				layout_config = { prompt_position = "top", width = 0.75, preview_height = 0.6 },
				-- other layout configuration here
				tiebreak = function(entry1, entry2, prompt)
					local start_pos1, _ = entry1.ordinal:find(prompt)
					if start_pos1 then
						local start_pos2, _ = entry2.ordinal:find(prompt)
						if start_pos2 then
							return start_pos1 < start_pos2
						end
					end
					return false
				end,
			})
		end, { desc = "[//] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
