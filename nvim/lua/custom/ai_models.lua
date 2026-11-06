-- Pinned OpenRouter models the team is allowed to use with codecompanion.nvim.
-- Everything here must have a Zero Data Retention endpoint (our OpenRouter account
-- enforces ZDR): https://openrouter.ai/api/v1/endpoints/zdr
-- To change a version, edit it here and commit so everyone moves together.
local M = {}

-- identifier -> OpenRouter model ID (dated slugs pin a specific release)
M.models = {
  haiku = 'anthropic/claude-haiku-5.5-20261007',
  glm = 'z-ai/glm-5.3-flash-20260826',
  deepseek = 'deepseek/deepseek-v4.1-flash-20260910',
}

-- Order shown in the model picker (`ga` in a chat buffer)
M.order = { 'haiku', 'glm', 'deepseek' }

-- Identifier of the default model
M.default = 'haiku'

--- Model IDs in picker order
---@return string[]
function M.choices()
  return vim.tbl_map(function(key) return M.models[key] end, M.order)
end

return M
