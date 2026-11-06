-- AI chat / inline assistant backed by OpenRouter.
-- Requires the OPENROUTER_API_KEY environment variable.
-- https://github.com/olimorris/codecompanion.nvim
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- NOTE: nvim-treesitter omitted: it is already installed and loaded by kickstart's init.lua.
    -- NOTE: nvim-cmp omitted: this config uses blink.cmp.
  },
  config = function()
    -- Uses the built-in `openrouter` adapter (reads $OPENROUTER_API_KEY), restricted
    -- to the team's pinned models in lua/custom/ai_models.lua (offered by `ga` in a chat).
    local ai = require 'custom.ai_models'
    local models = ai.choices()
    local adapter = { name = 'openrouter', model = ai.models[ai.default] }

    require('codecompanion').setup {
      opts = { log_level = 'DEBUG' }, -- TEMP: see ~/.local/state/nvim/codecompanion.log; remove once working
      adapters = {
        http = {
          openrouter = function()
            return require('codecompanion.adapters').extend('openrouter', {
              schema = { model = { default = ai.models[ai.default], choices = models } },
            })
          end,
        },
      },
      interactions = {
        chat = { adapter = adapter },
        inline = { adapter = adapter },
      },
    }

    require('which-key').add { { '<leader>a', group = '[A]I' } }
    vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[A]I [C]hat Toggle' })
    vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<cr>', { desc = '[A]I [A]ctions Menu' })
    vim.keymap.set('v', '<leader>ax', '<cmd>CodeCompanionChat Add<cr>', { desc = '[A]I Add Visual Selection to Chat' })
  end,
}
