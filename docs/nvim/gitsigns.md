# Gitsigns

[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) marks added,
changed and deleted lines in the sign column and lets you stage, reset, preview
and blame hunks. Current-line blame is on: a faint "author, date, message"
appears at the end of the cursor line after 300ms.

Config: `custom/plugins/git-suite.lua` (the one that wins) and the base
setup in `init.lua`. The `kickstart.plugins.gitsigns` extras are disabled.

Gutter signs: `▎` for add/change/untracked, a delete marker for removed lines.

## Keys

A "hunk" is one contiguous block of changes.

| Key | Mode | Does |
| --- | --- | --- |
| `]h` / `[h` | n | Next / previous hunk |
| `Space h s` | n, v | Stage hunk (visual: stage the selected lines) |
| `Space h r` | n, v | Reset (discard) hunk |
| `Space h S` | n | Stage whole buffer |
| `Space h R` | n | Reset whole buffer (discards all changes in file) |
| `Space h u` | n | Undo last stage (see gotcha) |
| `Space h p` | n | Preview hunk in a floating window |
| `Space h b` | n | Full blame for the current line |
| `Space h d` | n | Diff this file against the index |
| `Space h D` | n | Diff this file against `HEAD` (`~`) |
| `ih` | o, x | Hunk text object: `dih` deletes the hunk, `vih` selects it |

Gotcha: `undo_stage_hunk` was removed from recent gitsigns. If `Space h u`
errors, press `Space h s` on the staged hunk to toggle it back.

## Ex commands

```vim
:Gitsigns toggle_current_line_blame
:Gitsigns toggle_signs
:Gitsigns toggle_linehl
:Gitsigns toggle_word_diff
:Gitsigns toggle_deleted           " show deleted lines inline
:Gitsigns preview_hunk_inline
:Gitsigns setqflist                " hunks to quickfix
:Gitsigns blame                    " full-file blame window
:Gitsigns refresh
```

## Workflow

1. Edit; see `▎` marks.
2. `]h` to hop between changes, `Space h p` to peek at the old text.
3. `Space h s` to stage the good ones, `Space h r` to throw away the rest.
4. `Space g c` to commit (see [neogit.md](neogit.md)).
