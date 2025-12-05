local M = {}

local zoomed = false
local restore_cmd = nil

function M.toggle()
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

return M
