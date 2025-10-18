return {
  'xTacobaco/cursor-agent.nvim',
  event = 'VeryLazy',
  config = function()
    require('cursor-agent').setup {
      cursor_animations = true,
      animation_speed = 0.3,
    }
    vim.keymap.set('n', '<leader>cc', ':CursorAgent<CR>', { desc = 'Cursor Agent: Toggle terminal' })
    vim.keymap.set('v', '<leader>cc', ':CursorAgentSelection<CR>', { desc = 'Cursor Agent: Send selection' })
    vim.keymap.set('n', '<leader>cC', ':CursorAgentBuffer<CR>', { desc = 'Cursor Agent: Send buffer' })
  end,
}
