-- Project keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>p', group = 'Project Actions' },
  { '<leader>pp', '<cmd>Telescope projects<cr>', desc = 'Switch project' },
})