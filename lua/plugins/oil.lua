return {
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {
			diagnostic_symbols = {
				error = "E",
				warn = "W",
				info = "I",
				hint = "H",
			},
		},
	},
	{
		"malewicz1337/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
		config = function()
			require("oil-git").setup({
				debounce_ms = 200,
				show_file_highlights = true,
				show_directory_highlights = true,
				show_file_symbols = true,
				show_directory_symbols = true,
				symbols = {
					file = {
						added = "+",
						modified = "~",
						renamed = "->",
						deleted = "D",
						copied = "C",
						conflict = "!",
						untracked = "?",
						ignored = "o",
					},
					directory = {
						added = "*",
						modified = "*",
						renamed = "*",
						deleted = "*",
						copied = "*",
						conflict = "!",
						untracked = "*",
						ignored = "o",
					},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			local oil = require("oil")

			local function parse_output(proc)
				local result = proc:wait()
				local ret = {}
				if result.code == 0 then
					for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
						line = line:gsub("/$", "")
						ret[line] = true
					end
				end
				return ret
			end

			local git_status_cache = setmetatable({}, {
				__index = function(self, key)
					local ignore_proc = vim.system(
						{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
						{ cwd = key, text = true }
					)
					local tracked_proc = vim.system(
						{ "git", "ls-tree", "HEAD", "--name-only" },
						{ cwd = key, text = true }
					)
					local ret = {
						ignored = parse_output(ignore_proc),
						tracked = parse_output(tracked_proc),
					}
					rawset(self, key, ret)
					return ret
				end,
			})

			oil.setup({
				default_file_explorer = true,
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				lsp_file_methods = {
					enabled = true,
					timeout_ms = 1000,
					autosave_changes = false,
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, bufnr)
						local dir = oil.get_current_dir(bufnr)
						if not dir then
							return false
						end
						local status = git_status_cache[dir]
						return status.ignored[name] and not status.tracked[name]
					end,
				},
				float = {
					padding = 2,
					border = "rounded",
				},
			})
			vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })
			vim.keymap.set("n", "<leader>e", oil.toggle_float, { desc = "Float" })
			vim.keymap.set("n", "<leader>oc", function()
				for k in pairs(git_status_cache) do
					git_status_cache[k] = nil
				end
				require("oil").util.run_after_load(0, function()
					vim.cmd("edit!")
				end)
			end, { desc = "Clear Oil Git Cache" })
		end,
	},
}
