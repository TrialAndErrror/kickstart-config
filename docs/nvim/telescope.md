# Telescope

[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) is a fuzzy
finder for everything: files, text, buffers, git, help, keymaps, diagnostics.
Extensions loaded: `fzf` (fast sorting), `ui-select` (dropdown for
`vim.ui.select`, e.g. code action menus), `remote-sshfs`.

Config: `init.lua`, plus `custom/keybindings/{search,file,buffer,git}.lua`.

## Launching

| Key | Picker |
| --- | --- |
| `Space Space` | Open buffers |
| `Space /` | Fuzzy find in current buffer (dropdown) |
| `Space s f` | Files in cwd |
| `Space f f` | Files in cwd (same, from the File menu) |
| `Space f r` / `Space s .` | Recent files |
| `Space s g` | Live grep (needs `ripgrep`) |
| `Space s w` | Grep the word under the cursor |
| `Space s t` | Not Telescope: grep results as a collapsible tree, see [grep-tree.md](grep-tree.md) |
| `Space s /` | Live grep in open buffers only |
| `Space s d` | Diagnostics |
| `Space s r` | Resume the last picker |
| `Space s h` | Help tags |
| `Space s k` | All keymaps |
| `Space s n` | Neovim config files |
| `Space s m` | Man pages |
| `Space s c` | Colorscheme picker with live preview |
| `Space s s` | Telescope's list of all pickers (also bound to live grep; see [README](README.md#gotchas-in-the-current-config)) |
| `Space b b` | Buffers |
| `Space g t` | Git branches |
| `Space g T` | Git commits |
| `Space g S` | Git status |
| `Space p p` | Projects (extension not installed here) |
| `gO` / `gW` | LSP document / workspace symbols (in LSP buffers) |
| `grr` `gri` `grd` `grt` | LSP references / implementations / definitions / type definitions |

## Inside a picker

Type to filter. The prompt starts in insert mode.

| Key (insert) | Does |
| --- | --- |
| `Ctrl-n` / `Ctrl-p` (or arrows) | Next / previous result |
| `Enter` | Open |
| `Ctrl-x` | Open in horizontal split |
| `Ctrl-v` | Open in vertical split |
| `Ctrl-t` | Open in new tab |
| `Ctrl-u` / `Ctrl-d` | Scroll preview up / down |
| `Tab` / `Shift-Tab` | Select and move |
| `Ctrl-q` | Send all results to quickfix |
| `Alt-q` | Send selected to quickfix |
| `Ctrl-/` | Show picker mappings (`?` in normal mode) |
| `Ctrl-c` / `Esc` (normal mode) | Close |

Normal mode in the prompt (press `Esc` once): `j`/`k` move, `gg`/`G` jump,
`dd` on a buffer picker entry deletes that buffer, `?` help.

## Handy prompt tricks

- `'foo` exact match, `^foo` prefix, `foo$` suffix, `!foo` exclude (fzf syntax).
- In live grep: `foo  *.lua` style filtering is not built in; use `Space s /`
  or `Ctrl-q` then quickfix for more.
- `:Telescope` with no args lists all pickers; `:Telescope <Tab>` completes.

## Useful Ex commands

```vim
:Telescope find_files hidden=true
:Telescope live_grep search_dirs={"src"}
:Telescope buffers sort_mru=true
:Telescope current_buffer_fuzzy_find
:Telescope git_files
:Telescope git_bcommits
:Telescope lsp_references
:Telescope todo-comments todo      " via todo-comments (:TodoTelescope)
:Telescope resume
```
