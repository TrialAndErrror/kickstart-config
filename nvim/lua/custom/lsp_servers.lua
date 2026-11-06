-- Language servers and Mason tools beyond kickstart's defaults.
--
-- Loaded by init.lua: `servers` is deep-merged into kickstart's `servers` table (so you can also tweak stock entries
-- such as lua_ls here), and `tools` are extra non-LSP Mason packages to install (formatters, linters, ...).
-- Keys are nvim-lspconfig server names; mason-tool-installer maps them to Mason packages (e.g. html -> html-lsp).
-- Only servers listed here or in init.lua are enabled; anything else installed through :Mason is NOT auto-enabled.
return {
  servers = {
    gopls = {}, -- Go (also used by <leader>cI auto-import)
    golangci_lint_ls = {}, -- Go linting
    basedpyright = {}, -- Python; unlike pyright it can auto-import stdlib symbols (<leader>cI)
    html = {},
    jsonls = {},
    jinja_lsp = {},

    -- Vue 3 hybrid mode: vue_ls forwards TypeScript requests to vtsls, which needs the @vue/typescript-plugin
    -- (shipped inside the vue-language-server Mason package) and has to attach to .vue files too.
    vue_ls = {},
    vtsls = {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                languages = { 'vue' },
                configNamespace = 'typescript',
              },
            },
          },
        },
      },
    },

    -- Merged into kickstart's lua_ls entry (keeps its on_init and format settings).
    lua_ls = {
      settings = { Lua = { completion = { callSnippet = 'Replace' } } },
    },
  },

  tools = {
    'djlint', -- Jinja2/HTML template formatter (wired up in custom/plugins/flask.lua)
  },
}
