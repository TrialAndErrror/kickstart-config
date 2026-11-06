local function guess_base_branch(default)
  local cmd =
    [[git show-branch -a 2>/dev/null | grep '\*' | grep -v "\[$(git rev-parse --abbrev-ref HEAD)\]" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//']]
  local ok, result = pcall(vim.fn.system, { 'bash', '-c', cmd })
  if not ok then return default end

  result = vim.trim(result or '')
  if result == '' then return default end

  result = result:gsub('^remotes/', '')

  -- Only strip a leading "<remote>/" if <remote> is an actual configured remote,
  -- so branch names like "bug/fix-critical-message" are left alone.
  local remotes_out = vim.fn.system 'git remote'
  for remote_name in remotes_out:gmatch '[^\r\n]+' do
    local prefix = '^' .. vim.pesc(remote_name) .. '/'
    if result:match(prefix) then
      result = result:gsub(prefix, '')
      break
    end
  end

  return result
end
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope.nvim', -- optional, but nice for pickers
  },
  keys = {
    { '<leader>gr', '<cmd>Octo search is:pr is:open review-requested:@me<cr>', desc = 'Octo: PRs awaiting my review' },
    { '<leader>gR', '<cmd>Octo pr list<cr>', desc = 'Octo: all PRs' },
  },
  config = function()
    require('octo').setup()

    -- Octo has no option for this: open the review "changed files" panel as a
    -- centered floating window (half the screen wide) instead of a split across the
    -- bottom, so the diff panes keep the full height. Toggle it with Octo's
    -- <localleader>b mapping to hide/show it during review.
    local FilePanel = require('octo.reviews.file-panel').FilePanel
    local float_width_ratio = 0.5
    local float_max_height = 20
    function FilePanel:open()
      if not self:buf_loaded() then self:init_buffer() end
      if self:is_open() then return end

      local width = math.floor(vim.o.columns * float_width_ratio)
      local height = math.min(float_max_height, math.max(3, vim.api.nvim_buf_line_count(self.bufid)))
      self.size = height
      self.winid = vim.api.nvim_open_win(self.bufid, true, {
        relative = 'editor',
        row = math.floor((vim.o.lines - height) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = 'minimal',
        border = 'rounded',
        title = ' Changed files ',
        title_pos = 'center',
        zindex = 40,
      })

      for k, v in pairs(FilePanel.winopts) do
        vim.api.nvim_set_option_value(k, v, { win = self.winid, scope = 'local' })
      end
    end

    -- Auto-hide the changed-files float after picking a file from it (<cr>), so it
    -- doesn't cover the diff. Bring it back with <localleader>b.
    local Layout = require('octo.reviews.layout').Layout
    local orig_set_current_file = Layout.set_current_file
    function Layout:set_current_file(file, focus)
      local from_panel = self.file_panel:is_focused()
      orig_set_current_file(self, file, focus)
      if from_panel then self.file_panel:close() end
    end

    -- Octo's ]q / [q / ]Q / [Q (and the unviewed variants) bail out unless the files
    -- panel is open. Since the panel auto-hides above, let them run while it's hidden.
    for _, name in ipairs {
      'select_next_file',
      'select_prev_file',
      'select_first_file',
      'select_last_file',
      'select_next_unviewed_file',
      'select_prev_unviewed_file',
    } do
      local orig = Layout[name]
      Layout[name] = function(self, ...)
        local panel = self.file_panel
        if panel:is_open() then return orig(self, ...) end
        panel.is_open = function() return true end
        local ok, err = pcall(orig, self, ...)
        panel.is_open = nil -- fall back to the class method
        if not ok then error(err) end
      end
    end

    -- <localleader><space> (Space Space): from a diff pane, mark the current file as
    -- viewed and move to the next file (on the last file it stays put and shows a
    -- notification instead of wrapping). Octo's version looks up the file under the
    -- cursor in the files panel, which errors when the panel is hidden. Inside the
    -- panel it keeps Octo's behavior (toggle the file under the cursor).
    local octo_mappings = require 'octo.mappings'
    local orig_toggle_viewed = octo_mappings.toggle_viewed
    octo_mappings.toggle_viewed = function()
      local layout = require('octo.reviews').get_current_layout()
      if not layout then return end
      if layout.file_panel:is_focused() then return orig_toggle_viewed() end
      local file = layout:get_current_file()
      if not file then return end
      if file.viewed_state ~= 'VIEWED' then file:toggle_viewed() end
      if layout.selected_file_idx == #layout.files then
        -- Last file: stay put instead of wrapping to the first, and say so.
        local remaining = 0
        for _, f in ipairs(layout.files) do
          if f ~= file and f.viewed_state ~= 'VIEWED' then remaining = remaining + 1 end
        end
        local msg = 'Last file reviewed.'
        if remaining > 0 then
          msg = msg .. string.format(' %d other file(s) not yet viewed.', remaining)
        else
          msg = msg .. ' All files viewed. Submit with <localleader>vs or close with <C-c>.'
        end
        vim.notify(msg, vim.log.levels.WARN, { title = 'Octo review' })
        return
      end
      layout:select_next_file()
    end

    local utils = require 'octo.utils'
    local orig_get_repo_info = utils.get_repo_info
    utils.get_repo_info = function(repo)
      local info = orig_get_repo_info(repo)
      if info and info.defaultBranchRef and info.defaultBranchRef.name then
        local base = guess_base_branch(info.defaultBranchRef.name)
        if base ~= info.defaultBranchRef.name then
          info = vim.deepcopy(info) -- don't mutate octo's internal cache
          info.defaultBranchRef.name = base
        end
      end
      return info
    end
  end,
}
