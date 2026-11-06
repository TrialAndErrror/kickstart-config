# LSP, Mason, Fidget

The Language Server Protocol gives you go-to-definition, hover docs, rename,
diagnostics and code actions.

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): server configs.
- [mason.nvim](https://github.com/mason-org/mason.nvim) + `mason-lspconfig` +
  `mason-tool-installer`: install servers and tools from inside nvim.
- [fidget.nvim](https://github.com/j-hui/fidget.nvim): bottom-right progress
  notifications ("indexing...").

Config: `init.lua` (kickstart LSP block), `custom/lsp_servers.lua` (our servers
and tools), `custom/keybindings/{lsp,code}.lua`.

Servers enabled and installed automatically: `lua_ls` and `stylua` (kickstart's),
plus `gopls`, `golangci_lint_ls`, `basedpyright`, `html`, `jsonls`, `jinja_lsp`,
`vtsls` and `vue_ls`, and the extra tool `djlint`. Add more in
`custom/lsp_servers.lua`.

**Only servers listed in `init.lua` or `custom/lsp_servers.lua` are enabled**
(`automatic_enable = false`). Installing a server by hand in `:Mason` installs it
but does not start it; add it to `custom/lsp_servers.lua`.

## Go to / look up

| Key | Does |
| --- | --- |
| `Space l d` or `grd` | Definition (`grd` uses Telescope) |
| `Space l D` or `grD` | Declaration |
| `Space l t` or `grt` | Type definition |
| `Space l r` or `grr` | References (`grr` uses Telescope) |
| `gri` | Implementations |
| `Space l h` or `K` | Hover documentation |
| `Space l s` | Signature help (also `Ctrl-s` in insert mode) |
| `gO` | Document symbols (Telescope) |
| `gW` | Workspace symbols (Telescope) |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward after navigating |

## Change code

| Key | Does |
| --- | --- |
| `Space c a` or `gra` | Code action (visual mode too) |
| `Space c q` | Quick fixes only |
| `Space c i` | Organize imports |
| `Space c r` or `grn` | Rename symbol |
| `Space c f` | Format buffer |

## Diagnostics

| Key | Does |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `Ctrl-w d` | Float with the diagnostic for this line |
| `Space s d` | Telescope diagnostics |
| `Space q` | Diagnostics to location list |
| `Space x x` / `Space x X` | Trouble list ([trouble.md](trouble.md)) |

Warnings and errors are underlined; all severities show as inline virtual text.
Jumping with `]d` / `[d` opens the diagnostic float automatically. (This is
kickstart's global diagnostic config near the top of `init.lua`.)

## Other

| Key | Does |
| --- | --- |
| `Space t h` | Toggle inlay hints (when the server supports them) |
| `Space l i` | `:LspInfo` |
| `Space l R` | `:LspRestart` |

Cursor-hold highlights other uses of the symbol under the cursor.

## Mason

```vim
:Mason                   " UI: i install, X uninstall, u update, U update all, / filter, g? help
:MasonInstall prettier
:MasonUninstall prettier
:MasonUpdate
:MasonLog
:MasonToolsInstall       " install everything in ensure_installed
:MasonToolsUpdate
```

Formatters and linters work as soon as they're installed. A language *server* also
has to be listed in `custom/lsp_servers.lua` before it starts.

## Debug commands

```vim
:LspInfo                         " attached clients (or :checkhealth vim.lsp)
:LspRestart
:LspLog                          " log file
:checkhealth vim.lsp
:lua vim.print(vim.lsp.get_clients())
```

## Auto-import (`Space c I`)

Put the cursor on an undefined name (`defaultdict`, `Path`, `fmt`) and press
`Space c I` to add its import. Implemented in `custom/auto_import.lua`.

| Situation | Result |
| --- | --- |
| One place provides the name | The import is added at the top of the file |
| Several do (e.g. `Path` from `pathlib` or `zipfile`) | A picker asks which one |
| Go and gopls has no exact match | Falls back to organize-imports, which adds missing `pkg.Name` imports |
| Nothing found | A warning says so |

It asks the language server for completions at the token and applies only the
import edit, never the completion text. It then tries quickfix code actions
that mention "import".

- **Go:** `gopls`.
- **Python:** `basedpyright`. Plain `pyright` and `pylsp` do not suggest
  standard-library imports, which is why `basedpyright` is in the server list.
  A stray `pyright` or `pylsp` in Mason is harmless: it is not enabled, so it
  can't produce duplicate diagnostics or duplicate import choices.
- Other languages work if their server offers auto-import (e.g. `vtsls`).

`Space c i` is different: it organizes all imports in the file.
