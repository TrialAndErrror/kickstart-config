-- Git keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>g', group = 'Git Actions' },
  { '<leader>gt', '<cmd>Telescope git_branches<cr>', desc = 'Git branches (Telescope)' },
  { '<leader>gT', '<cmd>Telescope git_commits<cr>', desc = 'Git commits (Telescope)' },
  { '<leader>gS', '<cmd>Telescope git_status<cr>', desc = 'Git status (Telescope)' },
})