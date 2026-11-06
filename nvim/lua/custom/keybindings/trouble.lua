-- Trouble (diagnostics/quickfix list) keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>x', group = 'Trouble/Diagnostics' },
  { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (workspace)' },
  { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Diagnostics (buffer)' },
  { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols' },
  { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP definitions/references' },
  { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
  { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
}
