-- Window management keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>w', group = 'Window Actions' },
  { '<leader>ws', '<cmd>split<cr>', desc = 'Split horizontal' },
  { '<leader>wv', '<cmd>vsplit<cr>', desc = 'Split vertical' },
  { '<leader>wd', '<cmd>close<cr>', desc = 'Close window' },
  { '<leader>wo', '<cmd>only<cr>', desc = 'Only window' },
})