-- Window management keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>w', group = 'Window Actions' },
  { '<leader>ww', '<C-w>w', desc = 'Switch to next window/panel' },
  { '<leader>wW', '<C-w>W', desc = 'Switch to previous window/panel' },
  { '<leader>wh', '<C-w>h', desc = 'Go to left window' },
  { '<leader>wj', '<C-w>j', desc = 'Go to bottom window' },
  { '<leader>wk', '<C-w>k', desc = 'Go to top window' },
  { '<leader>wl', '<C-w>l', desc = 'Go to right window' },
  { '<leader>ws', '<cmd>split<cr>', desc = 'Split horizontal' },
  { '<leader>wv', '<cmd>vsplit<cr>', desc = 'Split vertical' },
  { '<leader>wd', '<cmd>close<cr>', desc = 'Close window' },
  { '<leader>wo', '<cmd>only<cr>', desc = 'Only window' },
  { '<leader>w=', '<C-w>=', desc = 'Equalize window sizes' },
  { '<leader>w+', '<C-w>+', desc = 'Increase window height' },
  { '<leader>w-', '<C-w>-', desc = 'Decrease window height' },
  { '<leader>w>', '<C-w>>', desc = 'Increase window width' },
  { '<leader>w<', '<C-w><', desc = 'Decrease window width' },
  { '<leader>wr', '<C-w>r', desc = 'Rotate windows' },
  { '<leader>wx', '<C-w>x', desc = 'Exchange windows' },
})