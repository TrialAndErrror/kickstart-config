-- Add the import for the token under the cursor (Python, Go, and anything else
-- whose language server supports auto-import).
--
-- Strategy, in order (first that yields something wins):
--   1. LSP completion at the token: servers like pyright/gopls return the exact
--      symbol with `additionalTextEdits` that add the import. We apply ONLY those
--      edits, never the completion text itself. Several candidates -> pick one.
--   2. LSP quickfix code actions whose title mentions "import" (for the
--      diagnostics on the cursor line).
--   3. Go only: `source.organizeImports` (what goimports does), which adds
--      missing std/known packages for `pkg.Name` usages.

local M = {}

local function notify(msg, level) vim.notify('AutoImport: ' .. msg, level or vim.log.levels.INFO) end

--- Word under the cursor and the (0-based) end column of it.
local function word_at_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local s, e = col + 1, col + 1 -- 1-based inclusive scan from cursor
  local function is_word(c) return c ~= '' and c:match '[%w_]' ~= nil end
  if not is_word(line:sub(s, s)) then return nil end
  while s > 1 and is_word(line:sub(s - 1, s - 1)) do
    s = s - 1
  end
  while is_word(line:sub(e + 1, e + 1)) do
    e = e + 1
  end
  return line:sub(s, e), row - 1, s - 1, e -- word, row0, start_col0, end_col0 (exclusive)
end

local function client_of(id) return vim.lsp.get_client_by_id(id) end

local function describe(item, edits)
  local d = item.labelDetails and (item.labelDetails.description or item.labelDetails.detail)
  d = d or item.detail
  if d and d ~= '' then return d end
  return (edits[1] and edits[1].newText or ''):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
end

--- Run `choices` (list of { label, apply }) : apply directly or ask.
local function choose(choices, word)
  if #choices == 0 then return false end
  if #choices == 1 then
    choices[1].apply()
    notify(('%s: %s'):format(word, choices[1].label))
    return true
  end
  vim.ui.select(choices, {
    prompt = 'Import ' .. word .. ' from:',
    format_item = function(c) return c.label end,
  }, function(c)
    if c then c.apply() end
  end)
  return true
end

--- Step 1: completion items with additionalTextEdits.
local function from_completion(bufnr, word, row, ecol, done)
  local clients = vim.lsp.get_clients { bufnr = bufnr, method = 'textDocument/completion' }
  if #clients == 0 then return done {} end
  local choices, seen, pending = {}, {}, 0

  local function finish_one()
    pending = pending - 1
    if pending <= 0 then done(choices) end
  end

  local function add(client, item, edits)
    local key = vim.json.encode(edits)
    if seen[key] then return end
    seen[key] = true
    choices[#choices + 1] = {
      label = describe(item, edits),
      apply = function() vim.lsp.util.apply_text_edits(edits, bufnr, client.offset_encoding) end,
    }
  end

  pending = #clients
  for _, client in ipairs(clients) do
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
      position = { line = row, character = ecol },
      context = { triggerKind = 1 },
    }
    -- convert byte col to the client's encoding
    local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
    params.position.character = vim.str_utfindex(line, client.offset_encoding, ecol, false)

    client:request('textDocument/completion', params, function(err, result)
      if err or not result then return finish_one() end
      local items = result.items or result
      local matches = {}
      for _, it in ipairs(items) do
        if it.label == word or it.filterText == word or (it.label or ''):gsub('%s.*$', '') == word then matches[#matches + 1] = it end
      end
      if #matches == 0 then return finish_one() end
      local left = #matches
      local function one_resolved()
        left = left - 1
        if left == 0 then finish_one() end
      end
      for _, it in ipairs(matches) do
        if it.additionalTextEdits and #it.additionalTextEdits > 0 then
          add(client, it, it.additionalTextEdits)
          one_resolved()
        elseif client:supports_method 'completionItem/resolve' then
          client:request('completionItem/resolve', it, function(_, resolved)
            local full = resolved or it
            if full.additionalTextEdits and #full.additionalTextEdits > 0 then add(client, full, full.additionalTextEdits) end
            one_resolved()
          end, bufnr)
        else
          one_resolved()
        end
      end
    end, bufnr)
  end
end

--- Step 2: quickfix code actions that mention "import".
local function from_code_actions(bufnr, row, scol, ecol, done)
  local clients = vim.lsp.get_clients { bufnr = bufnr, method = 'textDocument/codeAction' }
  if #clients == 0 then return done {} end
  local diags = {}
  for _, d in ipairs(vim.diagnostic.get(bufnr, { lnum = row })) do
    if d.user_data and d.user_data.lsp then diags[#diags + 1] = d.user_data.lsp end
  end
  local choices, pending = {}, #clients
  local function finish_one()
    pending = pending - 1
    if pending == 0 then done(choices) end
  end
  for _, client in ipairs(clients) do
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
      range = { start = { line = row, character = scol }, ['end'] = { line = row, character = ecol } },
      context = { diagnostics = diags, only = { 'quickfix' } },
    }
    client:request('textDocument/codeAction', params, function(_, actions)
      for _, action in ipairs(actions or {}) do
        if (action.title or ''):lower():find 'import' then
          choices[#choices + 1] = {
            label = action.title,
            apply = function()
              local function run(a)
                if a.edit then vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding) end
                if a.command then client:exec_cmd(a.command, { bufnr = bufnr }) end
              end
              if not action.edit and not action.command and client:supports_method 'codeAction/resolve' then
                client:request('codeAction/resolve', action, function(_, r) run(r or action) end, bufnr)
              else
                run(action)
              end
            end,
          }
        end
      end
      finish_one()
    end, bufnr)
  end
end

--- Step 3 (Go): organize imports synchronously-ish.
local function go_organize(bufnr)
  if vim.bo[bufnr].filetype ~= 'go' then return false end
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = {} }, apply = true }
  notify 'organized imports (gopls)'
  return true
end

function M.import_word()
  local bufnr = vim.api.nvim_get_current_buf()
  local word, row, scol, ecol = word_at_cursor()
  if not word then return notify('no identifier under the cursor', vim.log.levels.WARN) end
  if #vim.lsp.get_clients { bufnr = bufnr } == 0 then return notify('no LSP attached to this buffer', vim.log.levels.WARN) end

  from_completion(bufnr, word, row, ecol, function(choices)
    if choose(choices, word) then return end
    from_code_actions(bufnr, row, scol, ecol, function(actions)
      if choose(actions, word) then return end
      if go_organize(bufnr) then return end
      notify(('no import found for "%s"'):format(word), vim.log.levels.WARN)
    end)
  end)
end

return M
