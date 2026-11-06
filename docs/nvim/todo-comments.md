# todo-comments

[todo-comments.nvim](https://github.com/folke/todo-comments.nvim) highlights
`TODO`, `FIXME`, `NOTE`, `HACK`, `WARN`, `PERF`, `TEST` in comments and lets you
search them. Sign icons are off.

Config: `init.lua` (`signs = false`).

## Keys

| Key | Does |
| --- | --- |
| `]t` | Next todo comment |
| `[t` | Previous todo comment |

(Octo overrides `]t`/`[t` in its own review buffers only.)

## Commands

```vim
:TodoTelescope             " fuzzy list of all todos in the project
:TodoTelescope keywords=TODO,FIXME
:TodoTrouble               " list in Trouble
:TodoQuickFix              " fill quickfix
:TodoLocList
```

## Keywords

Write them as `TODO:`, `FIXME:`, `HACK:`, `NOTE:`, `PERF:`, `WARN:`,
`TEST:`. Aliases: `BUG`, `FIXIT`, `ISSUE` count as FIX; `XXX` as WARN. The match
only applies inside comments.
