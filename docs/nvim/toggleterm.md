# ToggleTerm

[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) gives you
persistent terminals you can show and hide. Loaded lazily on first use of
`:ToggleTerm` / `:TermExec`.

Config: `nvim/lua/custom/plugins/toggle-term.lua` (defaults) and
`custom/keybindings/toggle.lua`.

## Keys

| Key | Does |
| --- | --- |
| `Space t t` | Toggle floating terminal |
| `Space t f` | Toggle fullscreen terminal (opens in its own tab) |
| `Esc Esc` | Terminal mode to normal mode |
| `Ctrl-h/j/k/l` | Move to another window (from normal mode in the terminal) |
| `i` | Back into terminal mode from normal mode |
| `Space c c` (visual) | Send `@file:lines` to a Claude session in terminal 1 ([custom-keybindings.md](custom-keybindings.md)) |

Run commands in terminal 1 by default; `Space t t` and `Space c c` share it, so
a running Claude session reappears when you toggle.

## Ex commands

```vim
:ToggleTerm                          " toggle terminal 1
:2ToggleTerm direction=horizontal    " terminal number 2, as a split
:ToggleTerm direction=float|vertical|horizontal|tab
:ToggleTerm size=20
:TermExec cmd="npm test"             " run a command in a terminal
:TermExec cmd="make" direction=horizontal
:ToggleTermToggleAll                 " show/hide all terminals
:ToggleTermSendCurrentLine 1         " send current line to terminal 1
:ToggleTermSendVisualLines 1         " send selected lines
:ToggleTermSendVisualSelection 1
:TermSelect                          " pick from open terminals
:ToggleTermSetName
```

## Tips

- Exiting the shell (`exit` or `Ctrl-d`) closes that terminal for good; hiding
  it keeps the process alive.
- `<leader>fp` is separate: it opens a plain `:terminal` split running `glow`.
