local M = {}

---@class ZoomStateEntry
---@field zoomed boolean
---@field restore_cmd string?

---@alias ZoomStateType 'win' | 'tab'

---@class ZoomState
---@field windows table<string, ZoomStateEntry>
---@field tabs table<string, ZoomStateEntry>

---@type ZoomState
M.state = {
	windows = {},
	tabs = {},
}

local function get_state_dir()
	local dir = vim.fn.stdpath("data") .. "/zoom"
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	return dir
end

local function get_state_file()
	local file = get_state_dir() .. "/state.json"

	if vim.fn.filereadable(file) == 0 then
		local f = io.open(file, "w")
		if not f then
			error("Could not create zoom state file", 0)
		end

		f:write("{}")
		f:close()
	end

	return file
end

---@return ZoomState|nil
local function read_file()
	local path = get_state_file()

	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()
	if content == "" then
		return nil
	end

	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		return nil
	end

	return data
end

---@return boolean
local function write_file()
	local path = get_state_file()

	local file = io.open(path, "w")
	if not file then
		return false
	end

	local ok, json = pcall(vim.json.encode, M.state)
	if not ok then
		file:close()
		return false
	end

	file:write(json)
	file:close()

	return true
end

---@param type ZoomStateType
---@param state ZoomStateEntry
---@return boolean
function M.save_state(type, state)
	local id
	if type == "win" then
		id = tostring(vim.api.nvim_get_current_win())
		M.state.windows[id] = state
	elseif type == "tab" then
		id = tostring(vim.api.nvim_get_current_tabpage())
		M.state.tabs[id] = state
	else
		return false
	end
	return write_file()
end

---@param type ZoomStateType
---@return ZoomStateEntry?
function M.load_state(type)
	local data = read_file()
	if data then
		M.state = {
			windows = data.windows or {},
			tabs = data.tabs or {},
		}
	end

	local id
	if type == "win" then
		id = tostring(vim.api.nvim_get_current_win())
		return M.state.windows[id]
	elseif type == "tab" then
		id = tostring(vim.api.nvim_get_current_tabpage())
		return M.state.tabs[id]
	end

	return nil
end

---@param type ZoomStateType
---@param id? number
---@return boolean
function M.clear_state(type, id)
	if type == "win" then
		if id then
			M.state.windows[tostring(id)] = nil
		else
			M.state.windows = {}
		end
	elseif type == "tab" then
		if id then
			M.state.tabs[tostring(id)] = nil
		else
			M.state.tabs = {}
		end
	else
		return false
	end

	return write_file()
end

---@param type ZoomStateType
---@return boolean
function M.has_state(type)
	return M.load_state(type) ~= nil
end

return M
