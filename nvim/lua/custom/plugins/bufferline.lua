-- Bufferline shows every open buffer as a clickable tab across the top of the editor.
-- Click a tab to jump to that buffer; drag a tab to reorder it (built in, needs mouse=a).
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  event = 'VeryLazy',
  opts = {
    options = {
      mode = 'buffers',
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      diagnostics = 'nvim_lsp',
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
      left_mouse_command = 'buffer %d',
      right_mouse_command = 'bdelete! %d',
      close_command = 'bdelete! %d',
    },
  },
}
