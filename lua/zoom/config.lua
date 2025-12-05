local M = {}

---@class ZoomOpts
local defaults = {
	-- TODO: Add option to zoom only in one direction (horizontal/vertical)
	-- TODO: Add option to set custom zoom size (e.g., 80% of screen)
	-- TODO: Add option to exclude certain filetypes or buffer types from zooming
	-- TODO: Add option to automatically zoom on certain events (e.g., opening a file, switching buffers)
	-- TODO: Add option to save zoom state per tab or window
	-- TODO: Add option to customize zoom animation (e.g., duration, easing)
	mappings = {
		enabled = false,
		notify = false,
		actions = {
			---@type string[]|false
			toggle = {
				"<C-w>z",
				-- "<leader>z",
			},
		},
	},
}

---@type ZoomOpts
M.options = nil

local function add_mappings()
	if not M.options.mappings.enabled then
		return
	end

	local keymaps = 0

	for action_name, keys in pairs(M.options.mappings.actions) do
        if keys == false then
            goto continue
        end

		for _, key in ipairs(keys) do
			vim.keymap.set("n", key, function()
				local funcs = require("zoom.win")
				local fn = funcs[action_name]

				if fn then
					fn()
				else
					vim.notify("Zoom: action '" .. action_name .. "' not found", vim.log.levels.ERROR)
				end
			end, { noremap = true, silent = true })

			keymaps = keymaps + 1
		end

        ::continue::
	end

	if M.options.mappings.notify then
		vim.notify("Zoom: " .. keymaps .. " key mappings enabled", vim.log.levels.INFO)
	end
end

---@param options? ZoomOpts
function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
	add_mappings()
end

return setmetatable(M, {
	__index = function(_, key)
		if key == "options" then
			M.setup()
		end
		return rawget(M, key)
	end,
})
