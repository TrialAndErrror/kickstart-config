-- Zen mode: closes the file explorer/quickfix/trouble windows and strips
-- padding (line numbers, sign column, statusline) down to just tabs + text.
-- https://github.com/folke/zen-mode.nvim
return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  opts = {
    window = {
      backdrop = 1,
      width = 120,
      height = 1,
      options = {
        signcolumn = 'no',
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = '0',
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = false },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
      todo = { enabled = false },
      kitty = { enabled = false },
      alacritty = { enabled = false },
      wezterm = { enabled = false },
    },
    on_open = function()
      vim.cmd 'Neotree close'
      pcall(vim.cmd, 'Trouble close')
      vim.cmd 'cclose'
      vim.cmd 'lclose'
    end,
  },
}
