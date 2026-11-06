# Trouble

[trouble.nvim](https://github.com/folke/trouble.nvim) is a tidy list window for
diagnostics, quickfix, location list, LSP references/definitions and symbols.

Config: `custom/plugins/trouble.lua` (defaults) and `custom/keybindings/trouble.lua`.
Loads on first `:Trouble`.

## Keys

| Key | Opens |
| --- | --- |
| `Space x x` | Diagnostics for the whole workspace |
| `Space x X` | Diagnostics for the current buffer only |
| `Space x s` | Symbols outline (doesn't steal focus) |
| `Space x l` | LSP definitions / references / etc. on the right |
| `Space x L` | Location list |
| `Space x Q` | Quickfix list |

Each key toggles: press it again to close.

## Inside the Trouble window

| Key | Does |
| --- | --- |
| `j` / `k` | Move |
| `Enter` | Jump to the item |
| `o` | Jump and close Trouble |
| `Ctrl-s` / `Ctrl-v` | Jump in a split / vertical split |
| `p` | Toggle auto-preview |
| `P` | Toggle the preview |
| `r` | Refresh |
| `i` | Inspect the item |
| `za` / `zo` / `zc` | Toggle / open / close the group under the cursor |
| `zR` / `zM` | Open / close all groups |
| `q` | Close |
| `?` | Help: all keys |

## Ex commands

```vim
:Trouble diagnostics toggle
:Trouble diagnostics toggle filter.buf=0       " current buffer
:Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR
:Trouble symbols toggle focus=false
:Trouble lsp toggle win.position=right
:Trouble lsp_references toggle
:Trouble qflist toggle
:Trouble loclist toggle
:Trouble todo toggle                            " if todo-comments is loaded
:Trouble close
:Trouble refresh
```

## Tips

- Use it with Telescope: `Ctrl-q` in a picker fills quickfix, then `Space x Q`.
- Jump between diagnostics without Trouble using `]d` and `[d`; `Ctrl-w d`
  shows the current line's diagnostic in a float.
