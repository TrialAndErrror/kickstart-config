-- LSP keybindings
local wk = require 'which-key'

wk.add {
  -- 🌐 LSP
  { '<leader>l', group = 'lsp' },
  { '<leader>li', '<cmd>LspInfo<cr>', desc = 'LSP Info' },
  { '<leader>lr', vim.lsp.buf.references, desc = 'References' },
  { '<leader>ld', vim.lsp.buf.definition, desc = 'Definition' },
  { '<leader>lD', vim.lsp.buf.declaration, desc = 'Declaration' },
  { '<leader>lt', vim.lsp.buf.type_definition, desc = 'Type definition' },
  { '<leader>lh', vim.lsp.buf.hover, desc = 'Hover doc' },
  { '<leader>ls', vim.lsp.buf.signature_help, desc = 'Signature help' },
  { '<leader>lR', '<cmd>LspRestart<cr>', desc = 'Restart LSP' },
}