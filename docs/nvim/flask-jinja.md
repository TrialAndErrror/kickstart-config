# Flask / Jinja2 support

Not a single plugin: `custom/plugins/flask.lua` (filetype detection and
formatter wiring) and `custom/lsp_servers.lua` (servers and tools) extend other
plugins for Python and Jinja2 template work.

## What it sets up

- **Filetype detection**: `.jinja`, `.jinja2`, `.j2`, and any `.html` under a
  `templates/` directory open as `htmldjango` (Jinja syntax highlighting).
- **Language servers/tools**: `basedpyright` (Python LSP) and `jinja_lsp` are
  enabled, and `djlint` (template formatter/linter) is installed, all from
  `custom/lsp_servers.lua`.
- **Formatting**: `htmldjango`, `jinja`, `jinja2` format with `djlint` via
  [Conform](conform.md), when you press `Space f` (there is no format on save).
- **Parsers**: `python` and `jinja` are installed automatically the first time
  you open such a file ([treesitter.md](treesitter.md)).

## Usage

All the normal LSP keys apply in Python files: `Space l d`, `Space l r`,
`Space l h`, `Space c r`, `Space c f` ([lsp.md](lsp.md)).

Check things are working:

```vim
:set filetype?        " should say htmldjango in a template
:LspInfo              " basedpyright attached to .py files
:ConformInfo          " djlint listed for templates
:Mason                " basedpyright, jinja-lsp and djlint installed
```

If basedpyright can't find your packages, start nvim from the project root with
the virtualenv activated.
