# Custom keybindings

Everything here is defined in `nvim/lua/custom/keybindings/` and shows up
in [which-key](which-key.md). `Space` is the leader. Plugin-specific keys are in
each plugin's own page.

## Global (no leader)

| Key | Mode | Does |
| --- | --- | --- |
| `Esc` | n | Clear search highlight |
| `Esc Esc` | terminal | Leave terminal mode |
| `Ctrl-h/j/k/l` | n | Focus left/down/up/right window |
| `\` | n | Reveal current file in Neo-tree |
| `]h` / `[h` | n | Next / previous git hunk |

## Space Space and quick finds

| Key | Does |
| --- | --- |
| `Space Space` | Buffer list (Telescope) |
| `Space /` | Fuzzy find in the current buffer |
| `Space .` | Yazi at the current file |
| `Space -` | Yazi at the working directory |

## `Space b` Buffers

| Key | Does |
| --- | --- |
| `bb` | Switch buffer (Telescope) |
| `bn` / `bp` | Next / previous buffer |
| `bc` | Pick a buffer by letter (BufferLine pick) |
| `bd` | Delete buffer |
| `bo` | Close all other buffers |
| `bs` | Scratch buffer (see below) |

**Scratch buffer** (`Space b s`): a centered floating markdown pad. It is
throwaway and wipes itself on close. `q` or `Esc` closes it.

## `Space c` Code

| Key | Mode | Does |
| --- | --- | --- |
| `ca` | n | Code action |
| `cq` | n | Quick fixes only |
| `ci` | n | Organize/add imports (applies immediately) |
| `cI` | n | Import the symbol under the cursor (Python / Go), see [lsp.md](lsp.md#auto-import-space-c-i) |
| `cr` | n | Rename symbol |
| `cf` | n | Format buffer (via `vim.lsp.buf.format`) |
| `cs` | v | Silicon: screenshot the selection ([silicon.md](silicon.md)) |
| `cbs` | v | Silicon: screenshot to clipboard, with buffer context |
| `cc` | v | **Send `@file:lines` to Claude** in the floating terminal |

`Space c c` in visual mode builds a reference like `@src/app.py:10-25`, opens
terminal 1 (same one as `Space t t`) and runs `claude '<ref>' `. Finish typing
your prompt and press Enter.

## `Space f` Files

| Key | Does |
| --- | --- |
| `ff` | Find file |
| `fr` | Recent files |
| `fs` | Save |
| `fS` | Save all |
| `fe` | Edit `init.lua` |
| `fp` | Markdown preview: vertical split running `glow` on the current file (needs `glow`) |
| `fRc` | Connect to remote server |
| `fRf` | Find remote file |
| `fRg` | Live grep on remote |
| `fRe` | Edit ssh configs |

## `Space g` Git

| Key | Does |
| --- | --- |
| `gg` | Neogit status |
| `gc` / `gp` / `gP` / `gb` | Commit / pull / push / checkout branch |
| `gd` / `gD` | Diffview open / close |
| `gh` / `gH` | File history (buffer) / repo history |
| `gt` / `gT` / `gS` | Telescope: branches / commits / status |
| `gr` / `gR` | Octo: PRs awaiting my review / all PRs |

## `Space h` Hunks

See [gitsigns.md](gitsigns.md): `hs hr hS hu hR hp hb hd hD`.

## `Space l` LSP

| Key | Does |
| --- | --- |
| `ld` / `lD` | Definition / declaration |
| `lt` | Type definition |
| `lr` | References |
| `lh` | Hover docs |
| `ls` | Signature help |
| `li` | `:LspInfo` |
| `lR` | `:LspRestart` |

## `Space p` Project

| Key | Does |
| --- | --- |
| `pp` | Switch project (`Telescope projects`; needs the telescope-project extension, which this config does not install) |

## `Space q` Quit

| Key | Does |
| --- | --- |
| `qq` | Quit all (`:qa`) |
| `qs` | Save and quit (`:wq`) |

## `Space s` Search

See [telescope.md](telescope.md): `sf sg sw sd sr sh sk sn s. s/ ss sm sc`.

| Key | Does |
| --- | --- |
| `st` | Grep as a directory/file tree (see [grep-tree.md](grep-tree.md)) |
| `sT` | Same, for the word under the cursor |

## `Space t` Toggles

| Key | Does |
| --- | --- |
| `tn` | Relative line numbers |
| `tl` | Whitespace characters |
| `tw` | Word wrap |
| `tt` | Floating terminal |
| `tf` | Fullscreen (tab) terminal |
| `te` | File explorer (Neo-tree) |
| `th` | LSP inlay hints (only in buffers whose LSP supports them) |

## `Space w` Windows

| Key | Does |
| --- | --- |
| `ww` / `wW` | Next / previous window |
| `wh/wj/wk/wl` | Focus left/down/up/right |
| `ws` / `wv` | Split horizontal / vertical |
| `wd` | Close window |
| `wo` | Keep only this window |
| `w=` | Equalize sizes |
| `w+` / `w-` | Taller / shorter |
| `w>` / `w<` | Wider / narrower |
| `wr` / `wx` | Rotate / exchange windows |

## `Space x` Trouble

See [trouble.md](trouble.md): `xx xX xs xl xL xQ`.

## Related

- `Space q` alone runs `vim.diagnostic.setloclist` if you pause on it.
- Insert `Space` in a keymap table as `<leader>`; both leaders are Space.
