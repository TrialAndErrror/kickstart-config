-- Code actions keybindings
local wk = require 'which-key'

wk.add {
  -- 🧪 Code actions
  { '<leader>c', group = 'code' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },
  { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
  {
    '<leader>cf',
    function()
      vim.lsp.buf.format { async = true }
    end,
    desc = 'Format buffer',
  },
}