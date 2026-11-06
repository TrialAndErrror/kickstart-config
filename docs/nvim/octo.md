# Octo

[octo.nvim](https://github.com/pwntester/octo.nvim) lets you browse, review,
comment on and merge GitHub PRs and issues without leaving nvim. Requires the
`gh` CLI, authenticated (`gh auth login`).

This page is the cheat sheet. The detailed write-up of the custom review panel
tweaks is in [../octo.md](../octo.md).

Config: `custom/plugins/octo.lua`. Loads on the first `Space g r` / `Space g R`.

## Launch keys

| Key | Does |
| --- | --- |
| `Space g r` | PRs where you are a requested reviewer (all repos) |
| `Space g R` | All PRs in the current repo |

## Common commands

```vim
:Octo pr list
:Octo pr search <query>
:Octo pr edit 123                 " open PR #123
:Octo pr checkout                 " check out the PR you're viewing
:Octo pr create                   " create a PR from the current branch
:Octo pr diff                     " show the PR diff
:Octo pr changes
:Octo pr merge [commit|squash|rebase]
:Octo pr ready | draft | close | reopen
:Octo issue list
:Octo issue create
:Octo issue edit 45
:Octo search is:pr is:open review-requested:@me
:Octo review start | resume | submit | discard | comments | commit
:Octo comment add | delete
:Octo thread resolve | unresolve
:Octo reviewer add
:Octo label add | remove
:Octo assignee add | remove
:Octo actions                     " GitHub Actions runs
:Octo notification list
:Octo repo list | fork | view
```

## In a PR or issue buffer (`<localleader>` = Space)

| Key | Does |
| --- | --- |
| `Enter` | Options menu for the thing under the cursor |
| `Space v s` | Start a review |
| `Space v r` | Resume a pending review |
| `Space c a` | Add a comment |
| `Space c r` | Reply to a comment |
| `Space c d` | Delete a comment |
| `Space r t` / `Space r T` | Resolve / unresolve thread |
| `]c` / `[c` | Next / previous comment |
| `Space p o` | Checkout PR |
| `Space p m` | Merge commit |
| `Space p s m` | Squash and merge |
| `Space p r m` | Rebase and merge |
| `Space p c` | List commits |
| `Space p f` | List changed files |
| `Space p d` | Show PR diff |
| `Space v a` / `Space v d` | Add / remove a reviewer |
| `Space a a` / `Space a d` | Add / remove assignee |
| `Space l a` / `Space l d` | Add / remove label |
| `Space i c` / `Space i o` | Close / reopen |
| `Space r h` `r +` `r -` `r e` `r r` `r l` `r c` `r p` | Reactions: heart, +1, -1, eyes, rocket, laugh, confused, hooray |
| `Ctrl-b` | Open in browser |
| `Ctrl-y` | Copy URL |
| `Ctrl-r` | Reload |
| `gf` | Go to file |
| `Space q a` | Approve PR |

## During a review (diff tab)

| Key | Does |
| --- | --- |
| `Space b` | Hide / show the changed-files panel (a floating window in this config) |
| `Space e` | Focus the changed-files panel |
| `]q` / `[q` | Next / previous changed file (works with panel hidden) |
| `]Q` / `[Q` | Last / first file |
| `]u` / `[u` | Next / previous **unviewed** file |
| `Space Space` | In a diff: mark viewed and go to next file. In the panel: toggle viewed |
| `Space c a` | Add a review comment (also on a visual selection) |
| `Space s a` | Add a suggestion (replaces the selected lines) |
| `]t` / `[t` | Next / previous thread |
| `Space v s` | Submit the review (approve / comment / request changes) |
| `Space v d` | Discard the review |
| `Space C` | Review a single commit |
| `Ctrl-a` | Approve |
| `Ctrl-m` | Comment |
| `Ctrl-r` | Request changes |
| `Ctrl-c` | Close the review tab |

In the changed-files panel: `j`/`k` move, `Enter` opens the diff (and hides the
panel), `R` refreshes.

## Typical review

1. `Space g r`, pick a PR.
2. `Space v s` to start a review. The diff tab opens.
3. `Enter` a file, read, `Space c a` to comment, `Space Space` when done with the file.
4. When finished: `Space v s` and choose approve/comment/request changes.

## Pickers

The PR/issue lists use Telescope: `Ctrl-o` checkout, `Ctrl-r` merge,
`Ctrl-b` browser, `Ctrl-y` copy URL.
