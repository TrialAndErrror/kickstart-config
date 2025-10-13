-- Buffer management keybindings
local wk = require 'which-key'

wk.add {
  -- 🔄 Buffers
  { '<leader>b', group = 'buffer' },
  { '<leader>bb', '<cmd>Telescope buffers<cr>', desc = 'Switch buffer' },
  { '<leader>bd', '<cmd>bd<cr>', desc = 'Delete buffer' },
  { '<leader>bn', '<cmd>bnext<cr>', desc = 'Next buffer' },
  { '<leader>bp', '<cmd>bprevious<cr>', desc = 'Previous buffer' },
}