return {
  '0oAstro/silicon.lua',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function() require('silicon').setup {} end,
}
