vim.filetype.add({ extension = { jsonl = "json", jsonc = "json" } })

vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
		if size > 100 * 1024 or size == -2 then
			vim.b.large_file = true
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
			vim.bo.syntax = "off"
		end
	end,
})

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd.checktime()
		end
	end,
})

local _sigusr1 = (vim.uv or vim.loop).new_signal()
_sigusr1:start("sigusr1", function()
	vim.schedule(function()
		require("theme").setup()
		vim.cmd("redraw!")
	end)
end)

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "**/lua/theme/colors.lua",
	callback = function()
		vim.opt_local.swapfile = false
		vim.opt_local.undofile = false
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
