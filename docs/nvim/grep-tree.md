# Grep tree

A small built-in module (no plugin) that shows grep results as a collapsible
tree, like JetBrains "Find in Files". Results are grouped by directory, then
file, then matching line, so you can see at a glance which files share a
directory. Use [Telescope](telescope.md) live grep when you want fuzzy,
as-you-type search; use this when you want to survey *where* a term shows up.

Config: `custom/grep_tree.lua` (module) and `custom/keybindings/search.lua` (keys).
Needs `ripgrep` (`rg`), which Telescope already requires.

```
▾ Found occurrences of "permit"  73 results
  ▾ construction_monitor/commands  18 results
      ▾  get_processed_data.py  11 results
          5  def get_processed_data(parsed_hits_data):
          13  permits_found = []
      ▸  get_monthly_cm_data.py  2 results
```

## Launching

| Key / command | Does |
| --- | --- |
| `Space s t` | Prompt for a term, search from the cwd |
| `Space s T` | Search the word under the cursor |
| `:GrepTree {term}` | Same as `Space s t`, with the term on the command line |
| `:GrepTree` | Prompt for a term |

The term is a ripgrep regex, smart-case (case-insensitive unless it has a
capital). Hidden files are included; `.git` is skipped. Results open in a
15-line split at the bottom.

## Inside the results window

| Key | Does |
| --- | --- |
| `Enter` / `o` | On a match: open the file at that line and column in your previous window. On a directory or file: fold / unfold |
| `Tab` | Fold / unfold the node under the cursor |
| `l` | Expand |
| `h` | Collapse; if already collapsed (or on a match), jump to the parent |
| `E` | Expand everything |
| `C` | Collapse all files (directories stay open) |
| `R` | Re-run the same search |
| `q` | Close the window |

## Notes

- Directories are shown as full relative paths (`construction_monitor/commands`),
  not nested folders.
- Each row shows its result count.
- Leading whitespace is trimmed from matching lines; the match is highlighted.
- Re-running reuses the same buffer, so `Space s t` again replaces the results.
