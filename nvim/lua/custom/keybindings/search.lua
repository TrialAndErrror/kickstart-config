-- Search keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>s', group = 'Search Actions' },
  { '<leader>ss', '<cmd>Telescope live_grep<cr>', desc = 'Search text' },
  { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
  { '<leader>sm', '<cmd>Telescope man_pages<cr>', desc = 'Man pages' },
})