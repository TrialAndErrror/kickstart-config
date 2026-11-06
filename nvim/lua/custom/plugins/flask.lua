-- Flask / Jinja2 development support
return {
  -- Jinja2 filetype detection. Attached to nvim-treesitter only so it runs early: the python and jinja parsers
  -- are installed automatically the first time such a file is opened (kickstart's treesitter block does that).
  {
    'nvim-treesitter/nvim-treesitter',
    init = function()
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        group = vim.api.nvim_create_augroup('flask-filetypes', { clear = true }),
        callback = function(ev)
          local path = ev.file
          -- .jinja2, .j2, .jinja extensions → htmldjango (Jinja2 syntax)
          if path:match '%.jinja2$' or path:match '%.j2$' or path:match '%.jinja$' then
            vim.bo[ev.buf].filetype = 'htmldjango'
            return
          end
          -- .html files inside a templates/ directory
          if path:match '[/\\]templates[/\\].*%.html$' then vim.bo[ev.buf].filetype = 'htmldjango' end
        end,
      })
    end,
  },

  -- djlint formatter for Jinja2/HTML template files (the package itself is installed via lua/custom/lsp_servers.lua)
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.htmldjango = { 'djlint' }
      opts.formatters_by_ft.jinja = { 'djlint' }
      opts.formatters_by_ft.jinja2 = { 'djlint' }
    end,
  },
}
