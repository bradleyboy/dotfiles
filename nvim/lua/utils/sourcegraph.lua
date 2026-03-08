local M = {}

local function get_base_url()
	local host = os.getenv("SOURCEGRAPH_URL")
	if not host then
		return nil
	end
	return host .. "/-/blob/%s?L%d-%d"
end

local function get_git_relative_path()
	local git_root = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
	if vim.v.shell_error ~= 0 then
		return vim.fn.expand("%:p") -- Fallback to absolute path
	end
	local full_path = vim.fn.expand("%:p")
	return string.sub(full_path, #git_root + 2)
end

--- This function is designed to be called by a user command.
--- @param args A table provided by nvim_create_user_command.
---             It contains line1, line2, and range.
function M.open_from_command(args)
	local base_url = get_base_url()
	if not base_url then
		print("SOURCEGRAPH_URL is not set")
		return
	end

	-- The line numbers are now passed directly by the command infrastructure.
	-- If no range is given (normal mode), line1 and line2 will be the same.
	local start_line = args.line1
	local end_line = args.line2

	local file_path = get_git_relative_path()
	if not file_path or file_path == "" then
		print("Error: Could not determine file path.")
		return
	end

	-- Your Sourcegraph URL format doesn't require URL encoding the path.
	local url = string.format(base_url, file_path, start_line, end_line)

	-- Determine the OS-specific command to open a URL
	local open_cmd = "xdg-open" -- Default for Linux
	if vim.fn.has("macunix") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start"
	end

	-- Execute the command asynchronously
	vim.fn.jobstart({ open_cmd, url })

	-- Optional: Print a confirmation message
	print("Opening in browser: " .. url)
end

return M
