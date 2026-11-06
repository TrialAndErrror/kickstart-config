return {
  'hat0uma/csvview.nvim',
  ft = { 'csv', 'tsv' },
  opts = {
    parser = { comments = { '#' } },
    view = { display_mode = 'border' }, -- or "highlight"
    keymaps = {
      textobject_field_inner = { 'if', mode = { 'o', 'x' } },
      textobject_field_outer = { 'af', mode = { 'o', 'x' } },
      jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
      jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
      jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
      jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
    },
  },
  cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  config = function(_, opts)
    require('csvview').setup(opts)
    local function enable()
      vim.opt_local.wrap = false
      require('csvview').enable()
    end
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'csv', 'tsv' },
      callback = enable,
    })
    -- the first CSV buffer's FileType event fired before this config ran
    if vim.bo.filetype == 'csv' or vim.bo.filetype == 'tsv' then enable() end
  end,
}
