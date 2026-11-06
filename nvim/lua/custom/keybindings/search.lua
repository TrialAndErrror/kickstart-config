-- Search keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>s', group = 'Search Actions' },
  { '<leader>ss', '<cmd>Telescope live_grep<cr>', desc = 'Search text' },
  { '<leader>st', function() require('custom.grep_tree').prompt() end, desc = 'Grep results as tree' },
  { '<leader>sT', function() require('custom.grep_tree').word() end, desc = 'Grep word as tree' },
  { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
  { '<leader>sm', '<cmd>Telescope man_pages<cr>', desc = 'Man pages' },
  { '<leader>sc', '<cmd>Telescope colorscheme enable_preview=true<cr>', desc = 'Colorscheme picker' },
}
