# render-markdown

[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
renders markdown inside the buffer: styled headings, bullets, checkboxes,
tables, code blocks and callouts. Defaults only (`opts = {}`). It renders in
normal mode and un-renders the line you're editing.

Config: `custom/plugins/render-markdown.lua`.

No keybindings.

## Commands

```vim
:RenderMarkdown toggle         " all buffers
:RenderMarkdown buf_toggle     " this buffer only
:RenderMarkdown enable | disable
:RenderMarkdown expand | contract   " change how much text around the cursor stays raw
:RenderMarkdown preview        " rendered copy in a side buffer
:RenderMarkdown log | debug | config
```

## Related

- `Space f p` opens a `glow` preview in a vertical split (needs `glow`).
- `:checkhealth render-markdown` verifies the treesitter parsers are present.
