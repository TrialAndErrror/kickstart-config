# Diffview

[diffview.nvim](https://github.com/sindrets/diffview.nvim) is a tabpage showing
side-by-side diffs for all changed files, plus file/repo history and a 3-way
merge conflict tool.

Config: `custom/plugins/git-suite.lua` (enhanced diff highlighting; merge layout
`diff3_mixed`; wrap and list turned off in diff buffers).

## Launch keys

| Key | Does |
| --- | --- |
| `Space g d` | Open Diffview (working tree vs index/HEAD) |
| `Space g D` | Close Diffview |
| `Space g h` | History of the current file |
| `Space g H` | History of the whole repo |

## Ex commands

```vim
:DiffviewOpen                       " working tree changes
:DiffviewOpen HEAD~3                " compare against a commit
:DiffviewOpen main...HEAD           " what this branch changed vs main
:DiffviewOpen --staged
:DiffviewFileHistory %              " current file
:DiffviewFileHistory                " whole repo
:DiffviewFileHistory --range=main..HEAD
:'<,'>DiffviewFileHistory           " history for the selected lines
:DiffviewFocusFiles                 " jump to the file panel
:DiffviewToggleFiles                " hide/show the file panel
:DiffviewRefresh
:DiffviewClose
```

## Keys inside Diffview

| Key | Does |
| --- | --- |
| `Tab` / `Shift-Tab` | Next / previous file |
| `j` / `k` | Move in the file panel |
| `Enter` / `o` | Open the selected file diff |
| `-` | Stage / unstage the file (or hunk in the diff) |
| `S` / `U` | Stage all / unstage all |
| `X` | Restore (discard) the file |
| `R` | Refresh |
| `L` | Open the commit log (history view) |
| `Space e` | Focus the file panel |
| `Space b` | Toggle the file panel (buffer-local, so it replaces the buffer menu here) |
| `[x` / `]x` | Previous / next conflict |
| `g?` | Help: every Diffview key |
| `q` | Close (with `:DiffviewClose`) |

## Merge conflicts (3-way)

When there are conflicts, `:DiffviewOpen` shows an **ours | merged | theirs**
layout. Resolve in the middle buffer.

| Key | Does |
| --- | --- |
| `Space c o` | Take OURS for this conflict |
| `Space c t` | Take THEIRS |
| `Space c b` | Take BASE |
| `Space c a` | Take ALL (both) |
| `d x` | Delete the conflict region |
| `d o` / `d p` | Vim's `diffget` / `diffput` also work |

Capital `C` variants (`Space C o`, ...) apply to the whole file.

## Tip

`:DiffviewOpen origin/main...HEAD` plus `Tab` is a quick self-review before
opening a PR. Use [Octo](octo.md) to review someone else's PR.
