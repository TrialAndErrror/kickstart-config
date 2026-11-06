# Conform

[conform.nvim](https://github.com/stevearc/conform.nvim) formats code with
external formatters, falling back to the LSP.

Config: `init.lua` and `custom/plugins/flask.lua`.

## Behavior

- **No format on save** (kickstart's default): format with `Space f` when you
  want it.
- Formatters by filetype: `htmldjango`, `jinja`, `jinja2` use `djlint`.
  Everything else falls back to the LSP formatter. That includes Lua: `stylua`
  runs as a language server (it is in the servers table), and `.stylua.toml` in
  the config root sets the style (2 spaces, single quotes).

## Keys

| Key | Does |
| --- | --- |
| `Space f` (then pause) | Format buffer with conform (normal / visual) |
| `Space c f` | Format buffer with `vim.lsp.buf.format` (does not use conform) |

Careful with `Space f`: it is also the File menu prefix, so type `Space f f`
etc. without pausing to avoid formatting.

## Ex commands

```vim
:ConformInfo               " which formatters apply and whether they are installed
:lua require('conform').format()
```

To turn on format-on-save for a filetype, add it to `enabled_filetypes` in
`format_on_save` in `init.lua` (empty by default; that is a deliberate change
from stock, so keep it small). To add a formatter, add it to `formatters_by_ft`
and install it with Mason (`:MasonInstall prettier`), or list it in `tools` in
`custom/lsp_servers.lua` so a fresh machine installs it too.
