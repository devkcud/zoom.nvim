local M = {}

-- TODO: Hide statusline/tabline when zoomed
-- TODO: Add animation when zooming in/out
-- TODO: Add support for percentage-based zooming
-- TODO: Add option to zoom only in one direction (horizontal/vertical)

-- FIXME: When switching windows (C-w h|j|k|l), the zoom state should be toggled off
vim.api.nvim_create_autocmd("WinEnter", {
	-- HACK: This is a possible solution for the issue, but will not be translated when we switch to independent window states eventually
	-- FIXME: This may cause cursor flickering when switching windows (especially with smear-cursor)
	callback = function()
		if M.is_zoomed() then
			M.restore()
		end
	end,
})

-- FIXME: Keep track of zoomed windows instead of a global state
-- This would allow multiple windows to be zoomed independently.
-- However, it would require more complex state management and
-- may lead to conflicts with splits and their rules.
local zoomed = false
local restore_cmd = nil

local function is_available()
	return vim.fn.winwidth(0) < vim.o.columns or vim.fn.winheight(0) < vim.o.lines
end

function M.toggle()
	-- TODO: Add support for floating windows (this gonna be a pain)
	if vim.api.nvim_win_get_config(0).relative ~= "" then
		vim.notify("Zoom: cannot zoom floating windows", vim.log.levels.WARN)
		return
	end

	if not is_available() then
		vim.notify("Zoom: Not enough space to zoom", vim.log.levels.WARN)
		return
	end

	if not zoomed then
		restore_cmd = vim.fn.winrestcmd()

		-- TODO: Actually "hide" other windows instead of just resizing
		vim.cmd("resize")
		vim.cmd("vertical resize")

		zoomed = true
	else
		if restore_cmd then
			vim.cmd(restore_cmd)
		end

		restore_cmd = nil
		zoomed = false
	end
end

function M.is_zoomed()
	return zoomed
end

function M.restore()
	if zoomed then
		M.toggle()
	end
end

function M.zoom()
	if not zoomed then
		M.toggle()
	end
end

-- TODO: Add integration with other plugins (e.g., auto-restore on buffer switch)

return M
