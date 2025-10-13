-- Project keybindings
local wk = require 'which-key'

wk.add {
  -- 📁 Projects
  { '<leader>p', group = 'project' },
  { '<leader>pp', '<cmd>Telescope projects<cr>', desc = 'Switch project' },
}