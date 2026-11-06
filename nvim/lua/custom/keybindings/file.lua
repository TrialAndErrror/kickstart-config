-- File operations keybindings
local wk = require 'which-key'

local function split_in_glow()
  local file = vim.fn.expand '%'
  vim.cmd('vsplit | terminal glow ' .. file)
end

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>f', group = 'File Actions' },
  { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find file' },
  { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
  { '<leader>fs', '<cmd>w<cr>', desc = 'Save file' },
  { '<leader>fS', '<cmd>wa<cr>', desc = 'Save all' },
  { '<leader>fe', '<cmd>e ~/.config/nvim/init.lua<cr>', desc = 'Edit config' },
  { '<leader>fp', split_in_glow, desc = 'Markdown Preview' },

  { '<leader>fR', group = 'Remote File Actions' },
  { '<leader>fRc', '<cmd>RemoteSSHFSConnect<cr>', desc = 'Connect to server' },
  { '<leader>fRf', '<cmd>RemoteSSHFSFindFiles<cr>', desc = 'Find remote file' },
  { '<leader>fRg', '<cmd>RemoteSSHFSLiveGrep<cr>', desc = 'Live grep remote' },
  { '<leader>fRe', '<cmd>RemoteSSHFSEdit<cr>', desc = 'Edit ssh configs' },
}
