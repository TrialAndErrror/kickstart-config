-- Quit keybindings
local wk = require 'which-key'

wk.add {
  -- ❌ Quit
  {
    mode = { 'n', 'v' },
    { '<leader>q', group = 'quit' },
    { '<leader>qq', '<cmd>qa<cr>', desc = 'Quit all' },
    { '<leader>qs', '<cmd>wq<cr>', desc = 'Save & quit' },
  },
}