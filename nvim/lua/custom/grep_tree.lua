-- Tree-style grep results (like JetBrains "Find in Files"):
--   Found occurrences  N results
--     <directory>  N results
--       <file>  N results
--         <line>: <matching text>
--
-- Backed by ripgrep (--json). No plugin dependencies.
--
-- Buffer keys:
--   <CR>/o  toggle node, or open the match under the cursor
--   <Tab>   toggle node          l/h  expand / collapse (h on a leaf jumps to parent)
--   E / C   expand all / collapse all
--   R       re-run search        q    close

local M = {}

local ns = vim.api.nvim_create_namespace 'grep_tree'
local state = {
  buf = nil,
  term = nil,
  root = nil, -- directory the search ran in
  dirs = {}, -- ordered list of { path, files = { {path, matches} }, count }
  collapsed = {}, -- key -> true
  lines = {}, -- buffer line index -> node
  origin_win = nil,
}

local function icon(name, is_dir)
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then return is_dir and '' or '' end
  if is_dir then return '' end
  local i = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'), { default = true })
  return i or ''
end

local function plural(n) return n .. (n == 1 and ' result' or ' results') end

--- Rebuild the buffer contents from state.
local function render()
  local buf = state.buf
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then return end
  local out, hls, map = {}, {}, {}
  local total = 0
  for _, d in ipairs(state.dirs) do
    total = total + d.count
  end

  local function add(text, node, extra)
    out[#out + 1] = text
    map[#out] = node
    for _, h in ipairs(extra or {}) do
      hls[#hls + 1] = { #out - 1, h[1], h[2], h[3] }
    end
  end

  local function count_hl(text, count_str)
    local s = text:find(count_str, 1, true)
    return s and { 'Comment', s - 1, #text } or nil
  end

  local head = ('▾ Found occurrences of "%s"  %s'):format(state.term, plural(total))
  add(head, { type = 'root' }, { { 'Title', 0, #head } })

  for _, d in ipairs(state.dirs) do
    local dkey = 'd:' .. d.path
    local dopen = not state.collapsed[dkey]
    local ctext = plural(d.count)
    local line = ('  %s %s  %s'):format(dopen and '▾' or '▸', d.path == '' and '.' or d.path, ctext)
    local extra = { { 'Directory', 0, #line - #ctext - 2 } }
    extra[#extra + 1] = count_hl(line, ctext)
    add(line, { type = 'dir', key = dkey }, extra)

    if dopen then
      for _, f in ipairs(d.files) do
        local fkey = 'f:' .. f.path
        local fopen = not state.collapsed[fkey]
        local fname = vim.fn.fnamemodify(f.path, ':t')
        local fc = plural(#f.matches)
        local fl = ('      %s %s %s  %s'):format(fopen and '▾' or '▸', icon(fname), fname, fc)
        local fx = { { 'Normal', 0, #fl - #fc - 2 } }
        fx[#fx + 1] = count_hl(fl, fc)
        add(fl, { type = 'file', key = fkey, file = f.path }, fx)

        if fopen then
          for _, m in ipairs(f.matches) do
            local num = tostring(m.lnum)
            local prefix = ('          %s  '):format(num)
            local text = m.text
            local l = prefix .. text
            local mx = { { 'LineNr', 0, #prefix } }
            for _, sm in ipairs(m.subs) do
              mx[#mx + 1] = { 'Search', #prefix + sm[1], #prefix + sm[2] }
            end
            add(l, { type = 'match', file = f.path, lnum = m.lnum, col = m.col }, mx)
          end
        end
      end
    end
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for _, h in ipairs(hls) do
    if h[1] then vim.api.nvim_buf_set_extmark(buf, ns, h[1], h[3], { end_col = h[4], hl_group = h[2] }) end
  end
  state.lines = map
end

local function node_at_cursor()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  return state.lines[row], row
end

local function toggle(node)
  if node.key then state.collapsed[node.key] = not state.collapsed[node.key] or nil end
end

local function set_all(collapsed)
  state.collapsed = {}
  if collapsed then
    for _, d in ipairs(state.dirs) do
      for _, f in ipairs(d.files) do
        state.collapsed['f:' .. f.path] = true
      end
    end
  end
end

local function open_match(node)
  local win = state.origin_win
  if not (win and vim.api.nvim_win_is_valid(win)) or win == vim.api.nvim_get_current_win() then
    -- pick any non-tree window, else make one
    win = nil
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_buf(w) ~= state.buf then
        win = w
        break
      end
    end
    if not win then
      vim.cmd 'aboveleft split'
      win = vim.api.nvim_get_current_win()
    end
  end
  vim.api.nvim_set_current_win(win)
  vim.cmd('edit ' .. vim.fn.fnameescape(state.root .. '/' .. node.file))
  vim.api.nvim_win_set_cursor(0, { node.lnum, math.max(node.col - 1, 0) })
  vim.cmd 'normal! zz'
end

local function keep_cursor(fn)
  local _, row = node_at_cursor()
  fn()
  render()
  pcall(vim.api.nvim_win_set_cursor, 0, { math.min(row, #state.lines), 0 })
end

local function parent_row(row)
  local node = state.lines[row]
  local want = node.type == 'match' and 'file' or node.type == 'file' and 'dir' or 'root'
  for r = row - 1, 1, -1 do
    if state.lines[r].type == want then return r end
  end
end

local function setup_buffer(buf)
  local function map(lhs, fn, desc) vim.keymap.set('n', lhs, fn, { buffer = buf, nowait = true, silent = true, desc = 'GrepTree: ' .. desc }) end
  local function activate()
    local node = node_at_cursor()
    if not node then return end
    if node.type == 'match' then
      open_match(node)
    elseif node.type ~= 'root' then
      keep_cursor(function() toggle(node) end)
    end
  end
  map('<CR>', activate, 'open / toggle')
  map('o', activate, 'open / toggle')
  map('<Tab>', function()
    local node = node_at_cursor()
    if node and node.key then keep_cursor(function() toggle(node) end) end
  end, 'toggle')
  map('l', function()
    local node = node_at_cursor()
    if node and node.key and state.collapsed[node.key] then keep_cursor(function() toggle(node) end) end
  end, 'expand')
  map('h', function()
    local node, row = node_at_cursor()
    if not node then return end
    if node.key and not state.collapsed[node.key] then
      keep_cursor(function() toggle(node) end)
    else
      local p = parent_row(row)
      if p then vim.api.nvim_win_set_cursor(0, { p, 0 }) end
    end
  end, 'collapse / go to parent')
  map('E', function()
    keep_cursor(function() set_all(false) end)
  end, 'expand all')
  map('C', function()
    keep_cursor(function() set_all(true) end)
  end, 'collapse all files')
  map('R', function() M.search(state.term, { root = state.root }) end, 're-run search')
  map('q', function() vim.cmd 'close' end, 'close')
end

local function ensure_window()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_buf(w) == state.buf then
        vim.api.nvim_set_current_win(w)
        return
      end
    end
  else
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].buftype = 'nofile'
    vim.bo[state.buf].bufhidden = 'hide'
    vim.bo[state.buf].swapfile = false
    vim.bo[state.buf].filetype = 'greptree'
    pcall(vim.api.nvim_buf_set_name, state.buf, 'GrepTree')
    setup_buffer(state.buf)
  end
  vim.cmd 'botright 15split'
  vim.api.nvim_win_set_buf(0, state.buf)
  local wo = vim.wo[0]
  wo.number, wo.relativenumber, wo.wrap, wo.signcolumn, wo.cursorline, wo.foldenable = false, false, false, 'no', true, false
end

--- Run a search and show the tree.
---@param term string
---@param opts? { root?: string }
function M.search(term, opts)
  opts = opts or {}
  if not term or term == '' then return end
  if vim.fn.executable 'rg' == 0 then
    vim.notify('GrepTree: ripgrep (rg) not found', vim.log.levels.ERROR)
    return
  end
  local cur = vim.api.nvim_get_current_win()
  if not (state.buf and vim.api.nvim_win_get_buf(cur) == state.buf) then state.origin_win = cur end
  state.root = opts.root or vim.fn.getcwd()
  state.term = term
  state.collapsed = {}

  vim.system(
    { 'rg', '--json', '--smart-case', '--hidden', '--glob', '!.git', '--', term },
    { cwd = state.root, text = true },
    vim.schedule_wrap(function(res)
      if res.code ~= 0 and res.code ~= 1 then
        vim.notify('GrepTree: rg failed: ' .. (res.stderr or ''), vim.log.levels.ERROR)
        return
      end
      local by_dir, order = {}, {}
      for raw in (res.stdout or ''):gmatch '[^\n]+' do
        local ok, ev = pcall(vim.json.decode, raw)
        if ok and ev.type == 'match' and ev.data.path and ev.data.path.text then
          local path = ev.data.path.text:gsub('^%./', '')
          local dir = vim.fn.fnamemodify(path, ':h')
          if dir == '.' then dir = '' end
          local d = by_dir[dir]
          if not d then
            d = { path = dir, files = {}, byfile = {}, count = 0 }
            by_dir[dir] = d
            order[#order + 1] = d
          end
          local f = d.byfile[path]
          if not f then
            f = { path = path, matches = {} }
            d.byfile[path] = f
            d.files[#d.files + 1] = f
          end
          local text = (ev.data.lines.text or ''):gsub('\n$', '')
          -- strip leading whitespace, keeping match offsets aligned
          local lead = #text:match '^%s*'
          text = text:sub(lead + 1)
          local subs = {}
          for _, sm in ipairs(ev.data.submatches or {}) do
            local s, e = sm['start'] - lead, sm['end'] - lead
            if e > 0 then subs[#subs + 1] = { math.max(s, 0), math.min(e, #text) } end
          end
          f.matches[#f.matches + 1] = {
            lnum = ev.data.line_number,
            col = (ev.data.submatches[1] and ev.data.submatches[1]['start'] or 0) + 1,
            text = text,
            subs = subs,
          }
          d.count = d.count + 1
        end
      end
      table.sort(order, function(a, b) return a.path < b.path end)
      for _, d in ipairs(order) do
        table.sort(d.files, function(a, b) return a.path < b.path end)
      end
      state.dirs = order
      if #order == 0 then
        vim.notify('GrepTree: no results for "' .. term .. '"', vim.log.levels.INFO)
        return
      end
      ensure_window()
      render()
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
    end)
  )
end

function M.prompt()
  vim.ui.input({ prompt = 'Grep tree: ' }, function(input) M.search(input) end)
end

function M.word() M.search(vim.fn.expand '<cword>') end

function M.setup()
  vim.api.nvim_create_user_command('GrepTree', function(a)
    if a.args == '' then
      M.prompt()
    else
      M.search(a.args)
    end
  end, { nargs = '?', desc = 'Tree-style grep results' })
end

return M
