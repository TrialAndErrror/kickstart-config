-- File operations keybindings
local wk = require 'which-key'

wk.add {
  -- 🔁 File operations
  { '<leader>f', group = 'file' },
  { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find file' },
  { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
  { '<leader>fs', '<cmd>w<cr>', desc = 'Save file' },
  { '<leader>fS', '<cmd>wa<cr>', desc = 'Save all' },
  { '<leader>fe', '<cmd>e ~/.config/nvim/init.lua<cr>', desc = 'Edit config' },
}