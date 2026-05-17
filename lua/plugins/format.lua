return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			dart = { "dart_format" },
		},
		format_on_save = function(bufnr)
			local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
			if size > 100 * 1024 or size == -2 then
				return nil
			end
			return { timeout_ms = 1000, lsp_fallback = true }
		end,
	},
}
