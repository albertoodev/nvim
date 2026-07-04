return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (Current File)" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff3_horizontal",
			},
		},
	},
}
