-- Local tweaks on top of kickstart's mini.nvim block in init.lua (which sets up mini.ai, mini.surround and
-- mini.statusline). This spec only adds an `init` hook, so kickstart's own `config` stays in charge.
return {
  'nvim-mini/mini.nvim',
  version = '*',
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      once = true,
      callback = function()
        -- Markdown fenced code block textobject: `yic` yanks inside the fence, `yac` includes it.
        -- Set on mini.ai's live config table so kickstart's own setup call is left untouched.
        local ai = require 'mini.ai'
        ai.config.custom_textobjects = vim.tbl_extend('force', ai.config.custom_textobjects or {}, {
          c = { '```[^\n]*\n().-()\n[ \t]*```' },
        })

        -- Animate scrolling (<C-d>, <C-u>, <C-f>, <C-b>, zz, ...) so you can see where you're going.
        -- Other animations are off. Raise the duration below to slow it down.
        local animate = require 'mini.animate'
        animate.setup {
          scroll = {
            timing = animate.gen_timing.linear { duration = 150, unit = 'total' },
          },
          cursor = { enable = false },
          resize = { enable = false },
          open = { enable = false },
          close = { enable = false },
        }

        -- Mouse wheel events fire in rapid bursts, which fights the scroll animation and makes wheel scrolling
        -- jumpy/stuck. Scroll the wheel natively (no animation) by pausing mini.animate while wheel events arrive.
        local wheel_timer = assert(vim.uv.new_timer())
        local function wheel(key)
          return function()
            vim.g.minianimate_disable = true
            wheel_timer:stop()
            wheel_timer:start(150, 0, vim.schedule_wrap(function() vim.g.minianimate_disable = false end))
            local lines = tonumber(vim.o.mousescroll:match 'ver:(%d+)') or 3
            vim.cmd.normal { lines .. key, bang = true }
          end
        end
        vim.keymap.set({ 'n', 'x' }, '<ScrollWheelUp>', wheel '\25', { desc = 'Scroll up (no animation)' })
        vim.keymap.set({ 'n', 'x' }, '<ScrollWheelDown>', wheel '\5', { desc = 'Scroll down (no animation)' })
      end,
    })
  end,
}
