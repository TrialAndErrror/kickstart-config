# Bufferline

[bufferline.nvim](https://github.com/akinsho/bufferline.nvim) shows every open
buffer as a tab along the top. It also shows LSP diagnostic counts per buffer
and shifts right when the Neo-tree sidebar is open.

Config: `nvim/lua/custom/plugins/bufferline.lua`.

## Keys

| Key | Does |
| --- | --- |
| `Space b n` | Next buffer |
| `Space b p` | Previous buffer |
| `Space b c` | Pick a buffer: each tab shows a letter, press it to jump |
| `Space b o` | Close all other buffers |
| `Space b d` | Delete current buffer |
| `Space b b` | Fuzzy-switch buffer (Telescope) |

## Mouse

| Action | Result |
| --- | --- |
| Left click a tab | Switch to it |
| Right click a tab | Close it (`bdelete!`) |
| Hover a tab | Reveals its close button |
| Drag a tab | Reorder |

## Ex commands

```vim
:BufferLineCycleNext        :BufferLineCyclePrev
:BufferLineMoveNext         :BufferLineMovePrev        " reorder
:BufferLinePick             :BufferLinePickClose       " pick one to close
:BufferLineCloseOthers      :BufferLineCloseLeft       :BufferLineCloseRight
:BufferLineTogglePin                                   " pin a tab so it stays first
:BufferLineGoToBuffer 3                                " jump to the 3rd tab
:BufferLineSortByDirectory  :BufferLineSortByExtension
```

No `[b` / `]b` mappings exist in this config; add them in
`custom/keybindings/buffer.lua` if you want them. The built-in `:bnext`,
`:bprev`, `Ctrl-^` (alternate buffer) also work.
