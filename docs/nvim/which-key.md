# which-key

[which-key.nvim](https://github.com/folke/which-key.nvim) shows a popup of the
keys that can follow whatever you have typed so far. It is how you browse this
config's menus.

Config: `init.lua` (delay 0, so the popup appears immediately).

## How to use

| Do this | Result |
| --- | --- |
| Press `Space` and pause | Popup of all leader groups |
| `Space` then a letter (e.g. `g`) | Popup for that group |
| Press `Backspace` in the popup | Go up one level |
| `Esc` in the popup | Dismiss |
| `Space s k` | Telescope list of **every** keymap (searchable) |
| `?` in the popup | Show which-key's own help |
| `"`, `'`, `` ` ``, `z=`, `<C-w>`, `g`, `z` | Popups for registers, marks, spelling, windows, and `g`/`z` prefixes |

## Top-level leader groups

| Prefix | Group |
| --- | --- |
| `Space b` | Buffer actions |
| `Space c` | Code actions |
| `Space f` | File actions (and `Space f R` remote) |
| `Space g` | Git actions |
| `Space h` | Git hunks |
| `Space l` | LSP actions |
| `Space p` | Project actions |
| `Space q` | Quit |
| `Space s` | Search |
| `Space t` | Toggles |
| `Space w` | Windows |
| `Space x` | Trouble / diagnostics |

Full tables are in [custom-keybindings.md](custom-keybindings.md).

## Adding your own

Custom groups are registered in `nvim/lua/custom/keybindings/*.lua`
with `wk.add({ { '<leader>x', group = 'Name' }, { '<leader>xy', cmd, desc = '...' } })`.
Add a new file and `require` it from `custom/keybindings/init.lua`.
