-- Code actions keybindings
local wk = require 'which-key'

-- Register keybindings with which-key (using wk.add method)
wk.add({
  { '<leader>c', group = 'Code Actions' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },
  { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
  { '<leader>cf', function()
    vim.lsp.buf.format { async = true }
  end, desc = 'Format buffer' },
})