-- Buffer management keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>b', group = 'Buffer Actions' },
  { '<leader>bb', '<cmd>Telescope buffers<cr>', desc = 'Switch buffer' },
  { '<leader>bd', '<cmd>bd<cr>', desc = 'Delete buffer' },
  { '<leader>bn', '<cmd>bnext<cr>', desc = 'Next buffer' },
  { '<leader>bp', '<cmd>bprevious<cr>', desc = 'Previous buffer' },
})