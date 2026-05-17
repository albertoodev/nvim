return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			callback = function()
				local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
				if size > 100 * 1024 or size == -2 then
					return
				end
				lint.try_lint()
			end,
		})
	end,
}
