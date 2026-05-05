-- Search keybindings
local wk = require 'which-key'
local builtin = require 'telescope.builtin'

-- Helper: get the current visual selection as a string
local function get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos 'v')
  local _, le, ce = unpack(vim.fn.getpos '.')
  if ls > le or (ls == le and cs > ce) then
    ls, cs, le, ce = le, ce, ls, cs
  end
  local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  if #lines == 0 then
    return ''
  end
  lines[#lines] = lines[#lines]:sub(1, ce)
  lines[1] = lines[1]:sub(cs)
  return table.concat(lines, '\n')
end

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>s', group = 'Search Actions' },
  { '<leader>ss', '<cmd>Telescope live_grep<cr>', desc = 'Search text' },
  { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
  { '<leader>sm', '<cmd>Telescope man_pages<cr>', desc = 'Man pages' },
  { '<leader>sF', builtin.find_files, desc = 'Search Files' },
  {
    '<leader>sf',
    function()
      local word = vim.fn.expand '<cfile>'
      builtin.find_files { default_text = word }
    end,
    desc = 'Search File under cursor',
  },
  {
    '<leader>sf',
    function()
      local sel = get_visual_selection()
      sel = sel:match '^[%s%.%/"\']*(.-)%s*$' or sel
      builtin.find_files { default_text = sel }
    end,
    mode = 'v',
    desc = 'Search File from selection',
  },
  {
    '<leader>ss',
    function()
      local sel = get_visual_selection()
      sel = sel:match '^[%s%.%/"\']*(.-)%s*$' or sel
      builtin.grep_string { search = sel }
    end,
    mode = 'v',
    desc = 'Search text from selection',
  },
}
