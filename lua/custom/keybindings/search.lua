-- Search keybindings
local wk = require 'which-key'

wk.add {
  -- 🔍 Search
  { '<leader>s', group = 'search' },
  { '<leader>ss', '<cmd>Telescope live_grep<cr>', desc = 'Search text' },
  { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
  { '<leader>sm', '<cmd>Telescope man_pages<cr>', desc = 'Man pages' },
}