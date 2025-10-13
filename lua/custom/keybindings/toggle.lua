-- Toggle keybindings
local wk = require 'which-key'

wk.add {
  -- 🔀 Toggles
  { '<leader>t', group = 'toggle' },
  { '<leader>tn', '<cmd>set rnu!<cr>', desc = 'Toggle relative number' },
  { '<leader>tl', '<cmd>set list!<cr>', desc = 'Toggle list chars' },
  { '<leader>tw', '<cmd>set wrap!<cr>', desc = 'Toggle word wrap' },
  { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
}