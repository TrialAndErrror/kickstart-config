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

Options (see `./install.sh --help`):

| Flag | Does |
| --- | --- |
| `--dest DIR` | Install the config to `DIR` instead of `~/.config/nvim` |
| `--prefix DIR` | Portable install: config in `DIR/config`, launcher in `DIR/bin` (see below) |
| `--name NAME` | Launcher / `NVIM_APPNAME` for `--prefix` (default `nvim-kickstart`) |
| `--bin-dir DIR` | With `--prefix`: symlink the launcher into `DIR` (e.g. `~/.local/bin`) |
| `--yes` | Never prompt (implied when stdin isn't a terminal) |
| `--no-backup` | Skip backing up an existing config |
| `--sync` | Run a headless `:Lazy restore` after install |
Env overrides for the download path: `KICKSTART_CONFIG_REPO` (`owner/repo`),
`KICKSTART_CONFIG_REF` (branch/tag/sha).

### Portable install (anywhere, on your PATH)

```bash
./install.sh --prefix ~/tools/kickstart --bin-dir ~/.local/bin
# or without --bin-dir, then add DIR/bin to PATH yourself:
./install.sh --prefix /opt/kickstart && export PATH="/opt/kickstart/bin:$PATH"
nvim-kickstart
```

The config goes in `PREFIX/config` and a launcher in `PREFIX/bin/nvim-kickstart`
(`--name` to change). The launcher runs nvim with `NVIM_APPNAME` set and keeps a
`~/.config/<name>` symlink pointing at the install, so your regular `~/.config/nvim`
is untouched and the directory can be moved (run the launcher from its new
location; re-run with `--bin-dir` to refresh a PATH symlink).

An existing `~/.config/nvim` is backed up to
`~/.local/share/nvim-config-backups/` first; `./uninstall.sh` restores one
(`nvim-*` backups only; portable installs are backed up as `portable-*` and
restored by hand). To remove a portable install, delete its `PREFIX` directory,
the `~/.config/<name>` symlink, and any `--bin-dir` symlink.
`~/.config/nvim/lua/local/` (machine-local plugin specs) is preserved across reinstalls.

## Updating installs

`install.sh` records every install in `~/.local/share/kickstart-config/installs.tsv`.
`update.sh` lists them and re-runs the installer for each with its original options
(backup first, `lua/local/` preserved):

```bash
./update.sh --list                  # show installs made from this repo
./update.sh --pull --sync           # git pull, update all, then :Lazy restore each
./update.sh ~/tools/kickstart       # only update one install
./update.sh --adopt ~/.config/nvim  # register an install made before update.sh existed
```

Flags: `--list`, `--pull`, `--sync`, `--adopt DIR`, `--no-backup`, `--yes`.
Run it from a clone; it installs from that clone's `nvim/`.

## Requirements

- **Required:** Neovim >= 0.10, git (plus curl + tar for the one-liner)
- **Recommended:** ripgrep, make, a C compiler, tree-sitter CLI, yazi, a Nerd Font

## Layout

```
install.sh / update.sh / uninstall.sh
nvim/        the config itself (init.lua, lua/custom/*, lazy-lock.json)
docs/nvim/   one cheat-sheet page per plugin
```

Plugin versions are pinned in `nvim/lazy-lock.json`; `:Lazy restore` reinstalls them.
Start with [docs/nvim/README.md](docs/nvim/README.md).
