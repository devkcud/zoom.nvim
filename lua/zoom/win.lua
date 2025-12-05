local M = {}

-- TODO: Hide statusline/tabline when zoomed
-- TODO: Add animation when zooming in/out
-- TODO: Add support for percentage-based zooming

-- FIXME: When switching windows (C-w h|j|k|l), the zoom state should be toggled off

local zoomed = false
local restore_cmd = nil

local function is_available()
	return vim.fn.winwidth(0) < vim.o.columns or vim.fn.winheight(0) < vim.o.lines
end

function M.toggle()
	-- FIXME: If the window is floating, resizing may not work as expected

	if not is_available() then
		vim.notify("Zoom: Not enough space to zoom", vim.log.levels.WARN)
		return
	end

	if not zoomed then
		restore_cmd = vim.fn.winrestcmd()

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
-- TODO: Add support for floating windows

return M
