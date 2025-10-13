-- Git keybindings
local wk = require 'which-key'

wk.add {
  -- 🧲 Git
  { '<leader>g', group = 'git' },
  { '<leader>gs', '<cmd>Neogit<cr>', desc = 'Git status' },
  { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'Git branches' },
  { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Git commits' },
}