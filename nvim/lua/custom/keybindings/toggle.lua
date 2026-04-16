-- Toggle keybindings
local wk = require("which-key")

-- Register keybindings with which-key (using wk.add method)
wk.add({
	{ "<leader>t", group = "Toggle Actions" },
	{ "<leader>tn", "<cmd>set rnu!<cr>", desc = "Toggle relative number" },
	{ "<leader>tl", "<cmd>set list!<cr>", desc = "Toggle list chars" },
	{ "<leader>tw", "<cmd>set wrap!<cr>", desc = "Toggle word wrap" },
	{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
	{
		"<leader>td",
		function()
			local hidden = vim.opt.laststatus:get() == 0
			vim.opt.laststatus = hidden and 2 or 0
			vim.opt.ruler = hidden
			vim.opt.number = hidden
			vim.opt.relativenumber = hidden
			vim.opt.signcolumn = hidden and "yes" or "no"
		end,
		desc = "Toggle distraction-free (statusline + numbers)",
	},
})

