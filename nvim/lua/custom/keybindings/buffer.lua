-- Buffer management keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>b', group = 'Buffer Actions' },
  { '<leader>bb', '<cmd>Telescope buffers<cr>', desc = 'Switch buffer' },
  { '<leader>bd', '<cmd>bd<cr>', desc = 'Delete buffer' },
  { '<leader>bn', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
  { '<leader>bp', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous buffer' },
  { '<leader>bc', '<cmd>BufferLinePick<cr>', desc = 'Pick buffer' },
  { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close other buffers' },
}
