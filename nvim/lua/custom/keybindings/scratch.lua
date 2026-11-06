-- Scratch buffer: a throwaway notes pad that discards itself on close
local wk = require 'which-key'

local function open_scratch()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].bufhidden = 'wipe'

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Scratch ',
    title_pos = 'center',
  })

  vim.wo[win].wrap = true

  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true, desc = 'Close scratch buffer' })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true, desc = 'Close scratch buffer' })
end

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>bs', open_scratch, desc = 'Scratch buffer' },
}
