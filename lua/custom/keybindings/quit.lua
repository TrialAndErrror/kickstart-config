-- Quit keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>q', group = 'Quit Actions' },
  { '<leader>qq', '<cmd>qa<cr>', desc = 'Quit all' },
  { '<leader>qs', '<cmd>wq<cr>', desc = 'Save & quit' },
}, { mode = { 'n', 'v' } })