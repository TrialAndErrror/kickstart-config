-- Cohesive Git workflow: Neogit (Magit-like UI) + Diffview + Gitsigns
return {
	-- 1) Neogit
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			{ "sindrets/diffview.nvim", lazy = true }, -- optional, enables great diffs
		},
		cmd = "Neogit", -- lazy-load on :Neogit
		keys = {
			{
				"<leader>gg",
				function()
					require("neogit").open({ kind = "auto" })
				end,
				desc = "Neogit (status)",
			},
			{
				"<leader>gc",
				function()
					require("neogit").action("commit.commit")
				end,
				desc = "Neogit Commit",
			},
			{
				"<leader>gp",
				function()
					require("neogit").action("pull.pull")
				end,
				desc = "Neogit Pull",
			},
			{
				"<leader>gP",
				function()
					require("neogit").action("push.push")
				end,
				desc = "Neogit Push",
			},
			{
				"<leader>gb",
				function()
					require("neogit").action("branch.checkout")
				end,
				desc = "Neogit Checkout Branch",
			},
		},
		config = function()
			require("neogit").setup({
				integrations = { diffview = true },
				disable_commit_confirmation = true,
				use_magit_keybindings = true,
			})
		end,
	},

	-- 2) Diffview
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewRefresh" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File History (buffer)" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: Repo History" },
		},
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
				view = { merge_tool = { layout = "diff3_mixed" } },
				hooks = {
					diff_buf_read = function()
						vim.opt_local.wrap = false
						vim.opt_local.list = false
					end,
				},
			})
		end,
	},

	-- 3) Gitsigns
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- load on editing files
		keys = {
			{
				"]h",
				function()
					require("gitsigns").next_hunk()
				end,
				desc = "Next Hunk",
			},
			{
				"[h",
				function()
					require("gitsigns").prev_hunk()
				end,
				desc = "Prev Hunk",
			},
			{
				"<leader>hs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Stage Hunk",
				mode = { "n", "v" },
			},
			{
				"<leader>hr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Reset Hunk",
				mode = { "n", "v" },
			},
			{
				"<leader>hS",
				function()
					require("gitsigns").stage_buffer()
				end,
				desc = "Stage Buffer",
			},
			{
				"<leader>hu",
				function()
					require("gitsigns").undo_stage_hunk()
				end,
				desc = "Undo Stage Hunk",
			},
			{
				"<leader>hR",
				function()
					require("gitsigns").reset_buffer()
				end,
				desc = "Reset Buffer",
			},
			{
				"<leader>hp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Preview Hunk",
			},
			{
				"<leader>hb",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = "Blame Line (full)",
			},
			{
				"<leader>hd",
				function()
					require("gitsigns").diffthis()
				end,
				desc = "Diff This",
			},
			{
				"<leader>hD",
				function()
					require("gitsigns").diffthis("~")
				end,
				desc = "Diff vs HEAD",
			},
			{ "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select Hunk", mode = { "o", "x" } },
		},
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "契" },
					topdelete = { text = "契" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				current_line_blame = true,
				current_line_blame_opts = { delay = 300 },
				preview_config = { border = "rounded" },
			})
		end,
	},
}
