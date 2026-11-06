# kickstart-config

My Neovim setup: [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) plus
custom plugins, keybindings and LSP config. Self-contained: everything lives in
`nvim/`, which gets copied to `~/.config/nvim`.

## Install

One-liner (downloads the repo tarball, no clone needed):

```bash
curl -fsSL https://raw.githubusercontent.com/TrialAndErrror/kickstart-config/main/install.sh | bash
# non-interactive, and restore pinned plugins right away:
curl -fsSL https://raw.githubusercontent.com/TrialAndErrror/kickstart-config/main/install.sh | bash -s -- --yes --sync
```

From a clone:

```bash
git clone https://github.com/TrialAndErrror/kickstart-config.git
cd kickstart-config && ./install.sh
```

Options: `--dest DIR`, `--yes`, `--no-backup`, `--sync` (see `./install.sh --help`).
Env overrides for the download path: `KICKSTART_CONFIG_REPO` (`owner/repo`),
`KICKSTART_CONFIG_REF` (branch/tag/sha).

An existing `~/.config/nvim` is backed up to
`~/.local/share/nvim-config-backups/` first; `./uninstall.sh` restores one.
`~/.config/nvim/lua/local/` (machine-local plugin specs) is preserved across reinstalls.

## Requirements

- **Required:** Neovim >= 0.10, git (plus curl + tar for the one-liner)
- **Recommended:** ripgrep, make, a C compiler, tree-sitter CLI, yazi, a Nerd Font

## Layout

```
install.sh / uninstall.sh
nvim/        the config itself (init.lua, lua/custom/*, lazy-lock.json)
docs/nvim/   one cheat-sheet page per plugin
```

Plugin versions are pinned in `nvim/lazy-lock.json`; `:Lazy restore` reinstalls them.
Start with [docs/nvim/README.md](docs/nvim/README.md).
