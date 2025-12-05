local M = {}

function M.setup(opts)
	opts = opts or {}

	vim.api.nvim_create_user_command("ZoomToggle", function()
		require("zoom").toggle()
	end, {
		desc = "Toggle Zoom for current window",
	})

    if opts.map ~= false then
        vim.keymap.set("n", "<C-w>z", function()
            require("zoom").toggle()
        end, { noremap = true, silent = true, desc = "Toggle Zoom for current window" })
    end
end

return M
