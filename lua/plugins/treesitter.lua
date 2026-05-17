local function is_large(_, bufnr)
	return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 100 * 1024
end

return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		auto_install = true,
		highlight = {
			enable = true,
			disable = is_large,
		},
		indent = {
			enable = true,
			disable = function(lang, bufnr)
				return lang == "json" or is_large(lang, bufnr)
			end,
		},
	},
}
