-- Window management keybindings
local wk = require 'which-key'

wk.add {
  -- 🪟 Window management
  { '<leader>w', group = 'window' },
  { '<leader>ws', '<cmd>split<cr>', desc = 'Split horizontal' },
  { '<leader>wv', '<cmd>vsplit<cr>', desc = 'Split vertical' },
  { '<leader>wd', '<cmd>close<cr>', desc = 'Close window' },
  { '<leader>wo', '<cmd>only<cr>', desc = 'Only window' },
}