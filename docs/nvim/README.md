# Neovim quick-start

One page per plugin, in `docs/nvim/`. Open the one you want, skim the tables,
and try the keys. Config lives in `nvim/` (based on kickstart.nvim).

`<leader>` and `<localleader>` are both **Space**. Press Space and wait: which-key
pops up a menu of everything available (see [which-key](which-key.md)).

## Plugin index

| Plugin | Doc | One-liner |
| --- | --- | --- |
| which-key | [which-key.md](which-key.md) | Popup menu of pending keys |
| Custom keybindings | [custom-keybindings.md](custom-keybindings.md) | All the `<leader>` menus defined in `lua/custom/keybindings/` |
| Telescope | [telescope.md](telescope.md) | Fuzzy finder: files, grep, buffers, git, help |
| Grep tree | [grep-tree.md](grep-tree.md) | Grep results grouped by directory / file, collapsible |
| Neo-tree | [neo-tree.md](neo-tree.md) | File tree sidebar |
| Yazi | [yazi.md](yazi.md) | Full terminal file manager inside nvim |
| Bufferline | [bufferline.md](bufferline.md) | Buffer tabs along the top |
| ToggleTerm | [toggleterm.md](toggleterm.md) | Floating / fullscreen terminal |
| Gitsigns | [gitsigns.md](gitsigns.md) | Gutter signs, stage/reset hunks, blame |
| Neogit | [neogit.md](neogit.md) | Magit-style git UI |
| Diffview | [diffview.md](diffview.md) | Side-by-side diffs, file history, merge tool |
| Octo | [octo.md](octo.md) | GitHub PRs and issues (see also [../octo.md](../octo.md)) |
| Trouble | [trouble.md](trouble.md) | Diagnostics / quickfix / symbols list |
| LSP, Mason, Fidget | [lsp.md](lsp.md) | Go to definition, rename, code actions, tool installer |
| blink.cmp + LuaSnip | [blink-cmp.md](blink-cmp.md) | Autocompletion and snippets |
| Conform | [conform.md](conform.md) | Formatting (manual with `Space f`; no format on save) |
| mini.nvim | [mini.md](mini.md) | Text objects, surround, statusline, scroll animation |
| Treesitter | [treesitter.md](treesitter.md) | Syntax parsers |
| todo-comments | [todo-comments.md](todo-comments.md) | Highlight and search TODO/FIXME |
| render-markdown | [render-markdown.md](render-markdown.md) | Pretty markdown in the buffer |
| Silicon | [silicon.md](silicon.md) | Code screenshots |
| remote-sshfs | [remote-sshfs.md](remote-sshfs.md) | Edit files on remote hosts |
| Flask / Jinja2 support | [flask-jinja.md](flask-jinja.md) | Python + Jinja templates setup |
| lazy.nvim | [lazy.md](lazy.md) | Plugin manager |

## Top 15 things to remember

| Key | Does |
| --- | --- |
| `Space` (wait) | Show the which-key menu |
| `Space Space` | Switch buffers (Telescope) |
| `Space f f` | Find file |
| `Space s g` | Grep the project |
| `Space s t` | Grep the project as a directory/file tree |
| `Space /` | Fuzzy search in current buffer |
| `\` | Reveal current file in the file tree |
| `Space t t` | Floating terminal |
| `Space g g` | Git status (Neogit) |
| `Space x x` | Diagnostics list (Trouble) |
| `Space l d` | Go to definition |
| `Space c a` | Code action |
| `Space c r` | Rename symbol |
| `Space f s` | Save |
| `Ctrl-h/j/k/l` | Move between windows |
| `Esc` | Clear search highlight |

## Core editor settings worth knowing

- Clipboard is shared with the OS (`unnamedplus`): `y` and `p` use the system clipboard.
- Relative numbers are off by default; toggle with `Space t n`.
- Whitespace is visible (`list` on): tabs show as `» `, trailing spaces as `·`. Toggle with `Space t l`.
- Search is case-insensitive unless you type a capital letter.
- `:s///` previews live in a split as you type (`inccommand=split`).
- Indentation is 2 spaces, tabs expanded (guess-indent may override per file).
- Undo history is persisted (`undofile`), so you can undo after reopening a file.
- Mouse is on: click windows, drag splits, click buffer tabs.
- `scrolloff=10`: the cursor stays 10 lines from the top/bottom edge.
- `confirm` is on: `:q` with unsaved changes asks instead of failing.
- Colorscheme: `miniautumn`. Preview others with `Space s c`.
- In a terminal buffer, `Esc Esc` returns to normal mode.
- Yanked text briefly highlights.

## Gotchas in the current config

- **Overlapping prefixes.** `<leader>f`, `<leader>q` and `<leader>s...` are
  both a menu and (for `f` and `q`) a single mapping. If you press `Space f` and
  pause, the single mapping fires (format buffer; for `Space q`, the diagnostic
  location list). Keep typing the second key without pausing.
- **`Space s s` is defined twice**: Telescope's "select Telescope picker" in
  `init.lua` and live grep in `custom/keybindings/search.lua`. Use `Space s g`
  for live grep; it is unambiguous. Check what's live with `Space s k`.
- **`Space h u`** calls gitsigns `undo_stage_hunk`, which newer gitsigns versions
  removed. If it errors, unstage with `Space h s` on a staged hunk instead.
- **`<C-Up>` in Yazi config** is malformed and does not toggle Yazi; use `:Yazi toggle`.
- The `kickstart.plugins.*` extras (debug, lint, autopairs, indent_line,
  kickstart neo-tree/gitsigns) are commented out in `init.lua`, so none of
  their keymaps exist.

## Plugin manager: lazy.nvim now, `vim.pack` later

`init.lua` tracks upstream kickstart.nvim's **`lazy` branch** (upstream's last
commit there was 2026-04-22) plus local additions under `lua/custom/`. Keep
`init.lua` close to upstream so a plain `diff` shows only deliberate changes.

Upstream's `master` has moved to **`vim.pack`**, Neovim 0.12's built-in plugin
manager (documented as experimental, with a lockfile at
`~/.config/nvim/nvim-pack-lock.json`). We are staying on lazy.nvim for now:
every spec in `lua/custom/plugins/` uses lazy.nvim features (`opts`, `config`,
`keys`, `cmd`, `event`, `dependencies`, `build`) that `vim.pack` does not
have, so moving means porting each file by hand and giving up lazy-loading.

**To consider in the future:** a `vim.pack` migration. Suggested approach: try
it in a separate config with `NVIM_APPNAME=nvim-pack nvim` (own config, plugins
and lockfile, so the real config is untouched), port a few plugins, compare
startup and day-to-day feel, and switch only if it is worth it. Replace the
`local.plugins` import with an equivalent loader at the same time.
