local M = {}

---@class ZoomOpts
local defaults = {
	-- TODO: Add option to zoom only in one direction (horizontal/vertical)
	-- TODO: Add option to set custom zoom size (e.g., 80% of screen)
	-- TODO: Add option to exclude certain filetypes or buffer types from zooming
	-- TODO: Add option to automatically zoom on certain events (e.g., opening a file, switching buffers)
	-- TODO: Add option to save zoom state per tab or window
	-- TODO: Add option to customize zoom animation (e.g., duration, easing)
	add_mappings = false,
	mappings = {
		---@type string[]
		toggle = {
			"<C-w>z",
			-- "<leader>z",
		},
	},
}

---@type ZoomOpts
M.options = nil

local function add_mappings()
	if not M.options.add_mappings then
		return
	end

	for _, mapping in ipairs(M.options.mappings.toggle) do
		vim.keymap.set("n", mapping, function()
			require("zoom").toggle()
		end, { noremap = true, silent = true, desc = "Zoom: Toggle zoom for current window" })
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
