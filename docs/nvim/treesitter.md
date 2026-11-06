# Treesitter

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (the
`main` branch, a full rewrite) installs and manages Tree-sitter parsers, which
give accurate syntax highlighting and indentation.

Config: `init.lua` (kickstart's treesitter block, unchanged).

Needs Neovim 0.12+, the `tree-sitter` CLI and a C compiler on the machine. It
does **not** support lazy-loading, which is why its spec uses `lazy = false`.

Parsers installed up front: bash, c, diff, html, lua, luadoc, markdown,
markdown_inline, query, vim, vimdoc. Open a file whose parser is available but
not installed and it is downloaded, compiled and enabled automatically (the
first open of a new filetype is a bit slower). So Python, Go, Jinja and the rest
need no list entry.

No keybindings; it's driven by commands.

## Commands

```vim
:TSInstall python go       " install parsers (runs in the background)
:TSUninstall python
:TSUpdate                  " update all installed parsers
:TSLog                     " install/update log; check it when a parser fails to build
```

## Handy built-ins

```vim
:InspectTree               " live syntax tree of the buffer
:Inspect                   " highlight groups under the cursor
:checkhealth vim.treesitter
```

If highlighting looks wrong after a plugin update, run `:TSUpdate`.

## History

nvim-treesitter was archived on 2026-04-03 and has since been un-archived and is
actively maintained again. This config used `tree-sitter-manager.nvim` in
between, and went back to the stock plugin on 2026-11-06.
