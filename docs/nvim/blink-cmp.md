# blink.cmp and LuaSnip

[blink.cmp](https://github.com/saghen/blink.cmp) is the autocompletion engine
and [LuaSnip](https://github.com/L3MON4D3/LuaSnip) the snippet engine.
Completion appears as you type in insert mode.

Config: `init.lua` (preset `default`; sources: LSP, path, snippets;
documentation popup does not open automatically; signature help on).

## Insert-mode keys (default preset)

| Key | Does |
| --- | --- |
| `Ctrl-y` | Accept the selected item |
| `Ctrl-n` / `Down` | Next item |
| `Ctrl-p` / `Up` | Previous item |
| `Ctrl-e` | Close the menu |
| `Ctrl-space` | Open the menu / toggle documentation |
| `Ctrl-b` / `Ctrl-f` | Scroll the documentation up / down |
| `Tab` / `Shift-Tab` | Next / previous snippet placeholder |
| `Ctrl-k` | Toggle signature help |

`Enter` does **not** accept in this preset; use `Ctrl-y`.

## Command line

Completion also works in `:` and `/`: `Tab` / `Shift-Tab` cycle, `Ctrl-y`
accepts (check `:help blink-cmp` for your version's cmdline preset).

## Snippets

Type a snippet trigger, accept it with `Ctrl-y`, then `Tab` through the
placeholders. LuaSnip loads friendly-snippets only if installed; none is in this
config, so you mainly see LSP-provided snippets. Add your own with
`require('luasnip').add_snippets(...)` or `:LuaSnipListAvailable`.

## Tips

- In Lua files, `lua_ls` is configured with the nvim runtime files, so `vim.*`
  completes.
- To make documentation auto-popup, set `documentation.auto_show = true` in `init.lua`.
