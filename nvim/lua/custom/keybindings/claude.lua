-- Send the current file + visual selection range to a new Claude session in the toggle terminal
local wk = require 'which-key'

local function send_to_claude()
  local file = vim.fn.expand '%:.'
  if file == '' then
    vim.notify('Buffer has no file name', vim.log.levels.WARN)
    return
  end

  local first, last = vim.fn.line 'v', vim.fn.line '.'
  if first > last then
    first, last = last, first
  end
  local ref = first == last and ('@%s:%d'):format(file, first) or ('@%s:%d-%d'):format(file, first, last)

  -- Leave visual mode, then open the same terminal as <leader>tt (terminal 1) and start claude
  vim.cmd 'normal! \27'
  require('toggleterm').exec("claude '" .. ref:gsub("'", [['\'']]) .. "' ", 1, nil, nil, 'float')
end

wk.add {
  { '<leader>cc', send_to_claude, desc = 'Send file:lines to Claude', mode = 'v' },
}
