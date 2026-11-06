# Yazi

[yazi.nvim](https://github.com/mikavilpas/yazi.nvim) runs the
[yazi](https://yazi-rs.github.io) terminal file manager in a floating window and
opens what you pick in nvim. Requires the `yazi` binary on your PATH.

Config: `nvim/lua/custom/plugins/yazi.lua`.

## Opening

| Key / command | Does |
| --- | --- |
| `Space .` | Open Yazi at the current file (normal and visual mode) |
| `Space -` | Open Yazi in nvim's working directory |
| `:Yazi` | Same as `Space .` |
| `:Yazi cwd` | Same as `Space -` |
| `:Yazi toggle` | Resume the last Yazi session |

`<C-Up>` is meant to resume the last session but its mapping is malformed in the
config (it has an extra positional entry), so use `:Yazi toggle` instead.

Directories do not open in Yazi automatically (`open_for_directories = false`).
netrw is disabled.

## Plugin keys inside Yazi

| Key | Does |
| --- | --- |
| `Enter` | Open the hovered file in nvim |
| `Ctrl-v` | Open in vertical split |
| `Ctrl-x` | Open in horizontal split |
| `Ctrl-t` | Open in new tab |
| `Ctrl-o` | Pick a window to open in |
| `Tab` | Cycle through open buffers |
| `Ctrl-s` | Grep (Telescope) in the current directory |
| `Ctrl-g` | Search and replace in the directory (needs `grug-far`; not installed here) |
| `Ctrl-y` | Copy relative path of selected files |
| `Ctrl-q` | Send selected files to the quickfix list |
| `Ctrl-\` | Change nvim's working directory to Yazi's |
| `F1` | Plugin help |

## Yazi's own keys (the basics)

| Key | Does |
| --- | --- |
| `h` / `j` / `k` / `l` | Parent / down / up / enter |
| `Space` | Select the file (multi-select) |
| `v` | Visual selection |
| `y` / `x` / `p` | Yank / cut / paste |
| `d` / `D` | Trash / permanently delete |
| `a` | Create (end with `/` for a directory) |
| `r` | Rename |
| `.` | Toggle hidden files |
| `/` / `?` | Search forward / backward |
| `z` | Jump with fzf |
| `~` | Yazi help (all keys) |
| `q` | Quit |
