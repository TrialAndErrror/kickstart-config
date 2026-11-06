# Silicon

[silicon.lua](https://github.com/0oAstro/silicon.lua) renders code as a pretty
screenshot via the `silicon` CLI. It must be installed
(`cargo install silicon` or your package manager, plus a font).

Config: `custom/plugins/silicon.lua` (defaults) and `custom/keybindings/code.lua`.

## Keys (visual mode)

Select lines with `V` first.

| Key | Does |
| --- | --- |
| `Space c s` | Screenshot the selection (saved to a file per the plugin defaults) |
| `Space c b s` | Screenshot to the clipboard, showing the whole buffer with the selection highlighted |

Normal mode has no silicon keys in this config.

## Command line

Use `lua require('silicon').visualise_cmdline({})` after selecting a range
(`:'<,'>lua ...` does not work with plain `lua`). Options such as
`to_clip = true`, `show_buf = true`, `visible = true` mirror the keys above.
