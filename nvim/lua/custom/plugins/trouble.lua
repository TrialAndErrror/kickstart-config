-- Trouble: pretty list for diagnostics, quickfix, loclist, and LSP references/symbols.
-- https://github.com/folke/trouble.nvim
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  cmd = 'Trouble',
  opts = {},
}
