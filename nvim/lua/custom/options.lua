-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- enforce 2-space indentation globally
vim.opt.tabstop = 2 -- display width of a tab character
vim.opt.shiftwidth = 2 -- number of spaces for each indent level
vim.opt.softtabstop = 2 -- number of spaces a <Tab> inserts/deletes in insert mode
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- smart autoindenting on new lines
vim.opt.breakindent = true -- maintain indent when wrapping lines

-- Load custom keybindings
require 'custom.keybindings'
