-- Git keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>g', group = 'Git Actions' },
  { '<leader>gs', '<cmd>Neogit<cr>', desc = 'Git status' },
  { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'Git branches' },
  { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Git commits' },
})