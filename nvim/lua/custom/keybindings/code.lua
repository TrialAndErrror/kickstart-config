-- Code actions keybindings
local wk = require 'which-key'
local silicon = require 'silicon'

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>c', group = 'Code Actions' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },
  {
    '<leader>cq',
    function() vim.lsp.buf.code_action { context = { only = { 'quickfix' } } } end,
    desc = 'Quick fix',
  },
  {
    '<leader>ci',
    function() vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true } end,
    desc = 'Organize/add imports',
  },
  {
    '<leader>cI',
    function() require('custom.auto_import').import_word() end,
    desc = 'Import symbol under cursor',
  },
  { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
  {
    '<leader>cf',
    function() vim.lsp.buf.format { async = true } end,
    desc = 'Format buffer',
  },

  -- Add keybindings for silicon
  {
    '<leader>cs',
    function() silicon.visualise_api {} end,
    desc = 'Capture selection',
    mode = 'v',
  },
  {
    '<leader>cbs',
    function() silicon.visualise_api { to_clip = true, show_buf = true } end,
    desc = 'Capture buffer with selection',
    mode = 'v',
  },
}
