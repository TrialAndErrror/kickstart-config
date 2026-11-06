# lazy.nvim

[lazy.nvim](https://github.com/folke/lazy.nvim) is the plugin manager. It
bootstraps itself on first launch, lazy-loads plugins on command/key/event, and
pins versions in `nvim/lazy-lock.json`.

Config: `init.lua` (the `require("lazy").setup` call). Add a plugin by dropping
a file returning a spec table in `lua/custom/plugins/` (imported automatically).
`lua/local/plugins/` is also imported for machine-specific plugins.

## Commands

```vim
:Lazy                  " dashboard
:Lazy sync             " install + update + clean
:Lazy update           " update all (rewrites lazy-lock.json)
:Lazy restore          " go back to the versions in lazy-lock.json
:Lazy install | clean | check | log | profile | health
:Lazy reload <plugin>
```

## Keys in the `:Lazy` window

| Key | Does |
| --- | --- |
| `I` | Install missing |
| `U` | Update all |
| `S` | Sync |
| `X` | Clean unused |
| `C` | Check for updates |
| `L` | Log |
| `P` | Profile (startup time) |
| `R` | Restore from lockfile |
| `Enter` / `K` | Plugin details |
| `?` | Help |
| `q` | Close |

## Tip

After pulling this repo on another machine, `:Lazy restore` installs the exact
locked versions.
