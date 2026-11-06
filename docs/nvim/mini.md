# mini.nvim

[mini.nvim](https://github.com/nvim-mini/mini.nvim) is a collection of small
modules. Enabled here: **ai** (text objects), **surround**, **statusline**,
**animate** (smooth scrolling only). The colorscheme `miniautumn` is from the
same suite.

Config: `init.lua` (ai, surround, statusline) and `custom/plugins/mini.lua`
(animate, mouse-wheel handling, the markdown-fence text object); colorscheme in
`custom/options.lua`.

## mini.ai: better text objects

Use after an operator (`d`, `c`, `y`, `v`). `a` = around (includes delimiters),
`i` = inside.

| Keys | Selects |
| --- | --- |
| `ci(` / `ci)` / `cib` | Inside parentheses |
| `ci[` / `ci{` / `ciB` | Inside brackets / braces |
| `ci"` / `ci'` / `` ci` `` / `ciq` | Inside any quote |
| `cit` | Inside an HTML/XML tag |
| `caf` / `cif` | Function call (around / inside) |
| `cia` | Function argument (inside) |
| `ci?` | User prompt: asks for the left and right characters |
| `cii(` / `cil(` | **Next** / **last** parentheses (looks ahead / behind, up to 500 lines) |
| `yic` / `yac` | Markdown fenced code block (inside / including the fences); a local addition |
| `ciw` | Normal vim word (still there) |

Kickstart binds "next" to `ii` / `aa` (not mini.ai's default `in` / `an`) so it
doesn't clash with Neovim 0.12's built-in node selection on `an` / `in`. Side
effect: `aa` is now "around next", so **"around argument" can no longer be typed
as `caa` / `daa`**; use `cia` / `dia` (inside argument). I checked that these
mappings exist but haven't tried `daa` interactively.

Examples: `dia` delete an argument; `vif` select a call's inside;
`yiiq` yank the next quoted string.

## mini.surround

| Keys | Does |
| --- | --- |
| `saiw)` | **Add** `)` surround around inner word |
| `sa` + motion + char | Add surround (visual: `sa` + char) |
| `sd'` | **Delete** surrounding `'` |
| `sr)'` | **Replace** surrounding `)` with `'` |
| `sf` / `sF` | Find surround right / left |
| `sh` | Highlight surround |
| `sn` | Update `n_lines` |

Examples: `saiw"` wraps the word in quotes; `sr"'` changes `"x"` to `'x'`.
See `:help mini.surround` for more surround types (function calls, tags).

`s` is no longer the plain "substitute" key; use `cl` instead.

## mini.statusline

The bar at the bottom: mode, git branch, diff counts, diagnostics, filename,
filetype, and `line:column`. No keys.

## mini.animate

Scrolling (`Ctrl-d`, `Ctrl-u`, `zz`, ...) is animated over 150 ms. Cursor,
resize, open and close animations are disabled. The mouse wheel scrolls
natively (no animation), because wheel events arrive in bursts that fight the
animation.

## Colorscheme

`miniautumn` is set in `custom/options.lua`. Try others with `Space s c`.
