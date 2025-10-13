return {
  'xTacobaco/cursor-agent.nvim',
  event = 'VeryLazy',
  config = function()
    require('cursor-agent').setup {
      cursor_animations = true,
      animation_speed = 0.3,
    }
    vim.keymap.set('n', '<leader>ca', ':CursorAgent<CR>', { desc = 'Cursor Agent: Toggle terminal' })
    vim.keymap.set('v', '<leader>ca', ':CursorAgentSelection<CR>', { desc = 'Cursor Agent: Send selection' })
    vim.keymap.set('n', '<leader>cA', ':CursorAgentBuffer<CR>', { desc = 'Cursor Agent: Send buffer' })
  end,
}
