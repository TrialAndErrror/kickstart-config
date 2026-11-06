# Neogit

[Neogit](https://github.com/NeogitOrg/neogit) is a Magit-style git interface:
a status buffer where you stage, commit, push, branch, rebase and stash with
single keys and popup menus. Integrates with [Diffview](diffview.md).

Config: `custom/plugins/git-suite.lua` (`disable_commit_confirmation = true`,
diffview integration on). Loads on first use.

## Launch keys

| Key | Does |
| --- | --- |
| `Space g g` | Open the Neogit status buffer |
| `Space g c` | Commit directly (opens the commit message editor) |
| `Space g p` | Pull |
| `Space g P` | Push |
| `Space g b` | Checkout a branch |
| `:Neogit` | Open status; `:Neogit commit`, `:Neogit log`, `:Neogit branch`, `:Neogit cwd=<dir>` |

## In the status buffer

| Key | Does |
| --- | --- |
| `Tab` | Fold/unfold the section or file under the cursor (shows the diff) |
| `1` `2` `3` `4` | Set fold depth for the whole buffer |
| `s` / `S` | Stage file or hunk / stage all unstaged |
| `u` / `U` | Unstage file or hunk / unstage all |
| `x` | Discard changes under the cursor |
| `Enter` | Open the file at that spot |
| `c` | Commit popup |
| `b` | Branch popup |
| `P` | Push popup |
| `F` | Pull popup |
| `f` | Fetch popup |
| `m` | Merge popup |
| `r` | Rebase popup |
| `l` | Log popup |
| `Z` | Stash popup |
| `X` | Reset popup |
| `A` | Cherry-pick popup |
| `V` | Revert popup |
| `d` | Diff popup (opens in Diffview) |
| `$` | Show git command history |
| `Ctrl-r` | Refresh |
| `y` | Yank the commit hash / path |
| `?` | Help popup: every key |
| `q` | Close |

Popup menus show switches (`-a`, `-f`, ...) and actions; press the key shown
next to each. For example: `c` then `c` makes a commit; `P` then `p` pushes to
the push remote; `b` then `b` checks out a branch.

## In the commit message editor

| Key | Does |
| --- | --- |
| `Ctrl-c Ctrl-c` | Submit the commit |
| `Ctrl-c Ctrl-k` | Abort |
| `:wq` | Also commits |
| `Alt-p` / `Alt-n` | Previous / next commit message in history |

## Typical flow

1. `Space g g`
2. `Tab` on a file to see its diff; `s` to stage; or `S` for everything.
3. `c` `c`, write the message, `Ctrl-c Ctrl-c`.
4. `P` `p` to push.

## Notes

- Neogit also reads `use_magit_keybindings = true` from the config, but that
  option has been deprecated upstream; the defaults above are what you get.
- Press `?` in any Neogit buffer for the authoritative key list for your version.
