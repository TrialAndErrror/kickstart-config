# Neo-tree

[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) is a file tree
sidebar. It follows the current buffer (`follow_current_file`) and does not
take over netrw/directory opening (`hijack_netrw_behavior = disabled`).

Config: `nvim/lua/custom/plugins/neo-tree.lua`.

## Open and close

| Key / command | Does |
| --- | --- |
| `\` | Reveal the current file in the tree (focus it). Press `\` inside the tree to close it |
| `Space t e` | Toggle the tree (`:Neotree toggle`) |
| `q` | Close (in tree) |
| `:Neotree reveal` / `:Neotree toggle` / `:Neotree close` | Same via commands |
| `:Neotree float` | Show as a floating window |
| `:Neotree buffers` | Tree of open buffers |
| `:Neotree git_status` | Tree of changed files |
| `<` / `>` | Cycle between filesystem / buffers / git status sources |

The bufferline offsets itself so tabs don't draw over the tree.

## Navigating

| Key | Does |
| --- | --- |
| `j` / `k` | Move |
| `Enter` | Open file / toggle folder (double-click also works) |
| `l` | Focus preview (after `P`) |
| `P` | Toggle preview |
| `s` | Open in vertical split |
| `S` | Open in horizontal split |
| `t` | Open in new tab |
| `w` | Open with window picker |
| `C` | Close this folder |
| `z` | Collapse all folders |
| `Backspace` | Go up to the parent directory |
| `.` | Set the tree root to this folder |
| `R` | Refresh |
| `e` | Toggle auto-expand width |
| `i` | Show file details |
| `?` | Help: all mappings |

## File operations

| Key | Does |
| --- | --- |
| `a` | New file (end the name with `/` to make a folder) |
| `A` | New directory |
| `d` | Delete |
| `r` | Rename |
| `b` | Rename keeping the extension (basename only) |
| `y` / `x` / `p` | Copy / cut / paste |
| `c` / `m` | Copy / move (prompts for a destination path) |
| `Ctrl-r` | Clear clipboard |
| `Tab` | Select/multi-select entries |
| `T` / `u` / `U` | Trash / undo trash / restore (needs a trash utility) |

## Filtering and sorting

| Key | Does |
| --- | --- |
| `/` | Fuzzy filter files |
| `D` | Fuzzy filter directories |
| `#` | Fuzzy sort |
| `f` | Filter on submit (Enter to apply) |
| `Ctrl-x` | Clear filter |
| `H` | Toggle hidden files |
| `[g` / `]g` | Previous / next git-modified file |
| `o` then `c d g m n s t` | Order by created / diagnostics / git / modified / name / size / type |

## Git status source (`<`/`>` to switch)

`A` add all, `ga` add file, `gu` unstage, `gU` undo last commit, `gr` revert,
`gc` commit, `gp` push, `gl` pull, `gg` commit and push.

## Buffers source

`d` or `bd` deletes the buffer under the cursor.
