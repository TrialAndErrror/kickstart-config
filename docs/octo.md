# Octo (GitHub PRs in Neovim)

[octo.nvim](https://github.com/pwntester/octo.nvim) lets you list, review and
comment on GitHub pull requests from inside Neovim. It needs the `gh` CLI
installed and authenticated (`gh auth login`).

Config lives in `config/nvim/lua/custom/plugins/octo.lua`.

## Keybindings

`<leader>` and `<localleader>` are both Space.

| Key | Command | What it does |
| --- | --- | --- |
| `<leader>gr` | `:Octo search is:pr is:open review-requested:@me` | Open PRs where you are a requested reviewer |
| `<leader>gR` | `:Octo pr list` | All PRs in the current repo |
| `<localleader>b` | (Octo's own mapping) | Hide/show the changed-files panel during a review |
| `<localleader><space>` (Space Space) | patched `toggle_viewed` | In a diff pane: mark the current file viewed and go to the next file. On the last file it stays put and shows a warning notification (with a count of files not yet viewed) instead of wrapping. In the panel: toggle viewed on the file under the cursor |

Notes:

- `<leader>gr` searches across every repo you can access, not just the current
  one. To limit it, add a `repo:owner/name` qualifier to the search string in
  `octo.lua`.
- `review-requested:@me` only matches PRs where you are still a requested
  reviewer. After you submit a review, the PR drops off the list.
- Octo loads the first time you press either `<leader>g` key.

## Changed-files panel

Octo normally opens the changed-files list as a split across the bottom of the
screen. The config overrides `FilePanel:open()` so that it opens as a centered
floating window instead. This gives the diff panes the full screen height.

- Width is 50% of the screen (`float_width_ratio` in `octo.lua`).
- Height fits the file list, up to 20 rows (`float_max_height` in `octo.lua`).
- Press `<localleader>b` (Space, then b) to hide it while you read the diffs,
  and again to bring it back.
- Picking a file from the panel with Enter hides the panel automatically, so
  the diff is unobstructed. Press `<localleader>b` to bring it back.
- `]q` / `[q` (next/previous file) and `]Q` / `[Q` (last/first file) work with
  the panel hidden. Octo only allows them while the panel is open, so the
  config patches that check.
- The float covers the middle of both diff panes while it is open.

Caveat: the override reimplements `FilePanel:open()` and relies on Octo's
internals. If a plugin update makes the panel stop appearing, check this
override first.

## Icons

File icons come from `nvim-web-devicons`, which requires a Nerd Font and
`vim.g.have_nerd_font = true` in `init.lua`. If that flag is `false`, lazy.nvim
disables devicons everywhere and Octo reports that it is missing. Run
`:Lazy sync` after changing the flag.

See [FONTS.md](../FONTS.md) for installing Nerd Fonts.
