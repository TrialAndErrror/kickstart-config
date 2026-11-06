-- LSP keybindings
local wk = require 'which-key'

-- Multiple clients (e.g. vtsls + vue_ls) can return the same location, which makes
-- vim.lsp.buf.* open the quickfix list instead of jumping. Dedupe, then jump if one remains.
local function dedupe_on_list(opts)
  local seen, items = {}, {}
  for _, item in ipairs(opts.items) do
    local path = vim.uv.fs_realpath(item.filename) or item.filename
    local key = path .. ':' .. item.lnum
    if not seen[key] then
      seen[key] = true
      table.insert(items, item)
    end
  end
  if #items == 1 then
    local item = items[1]
    vim.cmd.edit(vim.fn.fnameescape(item.filename))
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
  else
    vim.fn.setqflist({}, ' ', { title = opts.title, items = items })
    vim.cmd.copen()
  end
end

local function definition() vim.lsp.buf.definition { on_list = dedupe_on_list } end

local function type_definition() vim.lsp.buf.type_definition { on_list = dedupe_on_list } end

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>l', group = 'LSP Actions' },
  { '<leader>li', '<cmd>LspInfo<cr>', desc = 'LSP Info' },
  { '<leader>lr', vim.lsp.buf.references, desc = 'References' },
  { '<leader>ld', definition, desc = 'Definition' },
  { '<leader>lD', vim.lsp.buf.declaration, desc = 'Declaration' },
  { '<leader>lt', type_definition, desc = 'Type definition' },
  { '<leader>lh', vim.lsp.buf.hover, desc = 'Hover doc' },
  { '<leader>ls', vim.lsp.buf.signature_help, desc = 'Signature help' },
  { '<leader>lR', '<cmd>LspRestart<cr>', desc = 'Restart LSP' },
}
